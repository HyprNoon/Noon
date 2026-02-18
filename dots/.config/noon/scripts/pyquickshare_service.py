#!/usr/bin/env python3
"""Quick Share backend service for Quickshell QML frontend."""

import asyncio
import json
import os
import socket
import sys
import threading
from pathlib import Path

from pyquickshare import discover_services, receive, send_to


# Stub out firewalld — not required
async def _noop(*a, **kw):
    pass


import importlib

for _mod in ("pyquickshare.firewalld", "pyquickshare.mdns.receive"):
    try:
        importlib.import_module(_mod).temporarily_open_port = _noop
    except Exception:
        pass

# ── Port detection ───────────────────────────────────────────────


def _listening_ports() -> set[int]:
    ports = set()
    for path in ("/proc/net/tcp", "/proc/net/tcp6"):
        try:
            for line in Path(path).read_text().splitlines()[1:]:
                parts = line.split()
                if len(parts) > 3 and parts[3] == "0A":
                    ports.add(int(parts[1].split(":")[1], 16))
        except FileNotFoundError:
            pass
    return ports


# ── Helpers ──────────────────────────────────────────────────────


def emit(event: str, **kwargs):
    print(json.dumps({"event": event, **kwargs}, ensure_ascii=False), flush=True)


def local_ip() -> str:
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        ip = s.getsockname()[0]
        s.close()
        return ip
    except Exception:
        return socket.gethostbyname(socket.gethostname()) or "127.0.0.1"


# ── Bridge ───────────────────────────────────────────────────────


class Bridge:
    def __init__(self):
        self._recv_task = None
        self._discovered = {}
        self._output_dir = str(Path.home() / "Downloads" / "QuickShare")
        self._pending_request = None  # ShareRequest awaiting user decision

    async def start_receiving(self, output_dir: str = ""):
        if self._recv_task and not self._recv_task.done():
            emit("error", message="Receiver already active")
            return

        if output_dir.strip():
            self._output_dir = output_dir

        try:
            # pyquickshare hardcodes "downloads/" relative to cwd
            os.makedirs(os.path.join(self._output_dir, "downloads"), exist_ok=True)
            os.chdir(self._output_dir)
        except Exception as e:
            emit("error", message=f"Directory setup failed: {e}")
            return

        ports_before = _listening_ports()
        self._recv_task = asyncio.create_task(self._recv_loop())

        recv_port = 0
        for _ in range(35):
            await asyncio.sleep(0.1)
            new = _listening_ports() - ports_before
            if new:
                recv_port = next(iter(new))
                break

        if not recv_port:
            emit("error", message="Could not determine listening port")
            return

        ip = local_ip()
        hostname = socket.gethostname()
        emit(
            "receiving",
            endpointName=hostname,
            ip=ip,
            port=recv_port,
            qrData=f"nearby://{ip}:{recv_port}?name={hostname}",
            authToken="",
        )

    async def _recv_loop(self):
        try:
            eid = socket.gethostname()[:4].upper().ljust(4, "X").encode()
            async for req in receive(endpoint_id=eid):
                self._pending_request = req

                # Emit request with pin — UI must call acceptTransfer or rejectTransfer
                emit(
                    "transferRequest",
                    sender=getattr(req.header, "file_name", "Unknown"),
                    pin=req.pin,
                    # files/size info isn't on the header at this stage
                )

                # Wait for user decision (set by accept_transfer / reject_transfer)
                accepted = await req.respond

                if accepted:
                    try:
                        results = await req.done
                        downloads_dir = os.path.join(self._output_dir, "downloads")
                        files = []
                        for r in results:
                            if hasattr(r, "path"):
                                files.append(str(Path(self._output_dir) / r.path))
                            elif hasattr(r, "name"):
                                files.append(r.name)
                        emit("receiveProgress", progress=1.0)
                        emit("transferComplete", files=files, outputDir=downloads_dir)
                    except Exception as e:
                        emit("receiveProgress", progress=-1.0)
                        emit("error", message=f"Transfer failed: {e}")
                else:
                    emit("transferRejected")

                self._pending_request = None

        except asyncio.CancelledError:
            pass
        except Exception as e:
            emit("error", message=str(e))

    async def accept_transfer(self):
        req = self._pending_request
        if req is None or req.respond.done():
            emit("error", message="No pending transfer to accept")
            return
        req.respond.set_result(True)
        emit("receiveProgress", progress=0.0)

    async def reject_transfer(self):
        req = self._pending_request
        if req is None or req.respond.done():
            emit("error", message="No pending transfer to reject")
            return
        req.respond.set_result(False)

    async def stop_receiving(self):
        if self._pending_request and not self._pending_request.respond.done():
            self._pending_request.respond.set_result(False)
        if self._recv_task:
            self._recv_task.cancel()
            try:
                await self._recv_task
            except asyncio.CancelledError:
                pass
            self._recv_task = None
        self._pending_request = None
        emit("stopped")

    async def discover(self):
        if getattr(self, "_discovering", False):
            emit("error", message="Discovery already in progress")
            return
        self._discovering = True
        self._discovered = {}
        count = 0
        local_ip_addr = local_ip()
        local_hostname = socket.gethostname().lower()

        def parse_device(info):
            props = info.properties or {}
            # b"n" is the human-readable device name in Quick Share mDNS TXT records
            raw_name = props.get(b"n", b"") or props.get(b"name", b"")
            name = raw_name.decode(errors="ignore").strip()
            if not name:
                name = info.name.split(".")[0].strip()
            name = name.replace("-", " ").strip().title() or f"Device {count + 1}"

            ty = (props.get(b"ty", b"") or b"").decode(errors="ignore").lower()
            combined = ty + name.lower()
            if any(k in combined for k in ["phone", "pixel", "galaxy", "iphone"]):
                category = "phone"
            elif any(k in combined for k in ["pad", "tab", "ipad"]):
                category = "tablet"
            elif any(
                k in combined
                for k in ["book", "laptop", "pc", "surface", "chrome", "windows"]
            ):
                category = "laptop"
            else:
                category = "unknown"
            return name, category

        def is_self(info) -> bool:
            try:
                addrs = (
                    info.parsed_addresses()
                    if callable(getattr(info, "parsed_addresses", None))
                    else []
                )
                if local_ip_addr in addrs:
                    return True
                server = (getattr(info, "server", None) or "").lower()
                if server and local_hostname in server:
                    return True
            except Exception:
                pass
            return False

        try:
            queue = await discover_services()
        except Exception as e:
            emit("error", message=f"Discovery init failed: {e}")
            self._discovering = False
            emit("discoverDone", total=0)
            return

        try:
            while count < 30:
                try:
                    info = await asyncio.wait_for(queue.get(), timeout=12.0)
                except asyncio.TimeoutError:
                    break

                if is_self(info):
                    continue

                name, category = parse_device(info)
                self._discovered[count] = info
                emit("deviceFound", index=count, name=name, category=category)
                count += 1

        except Exception as e:
            emit("error", message=f"Discovery error: {e}")
        finally:
            self._discovering = False
            emit("discoverDone", total=count)

    async def send_file(self, index: int, path: str):
        device = self._discovered.get(index)
        if not device:
            emit("error", message=f"Device {index} not found")
            return

        p = Path(path).absolute()
        if not p.is_file():
            emit("error", message=f"File not found: {path}")
            return

        emit("sendProgress", progress=0.0)
        last_err = None
        for _attempt in range(4):
            try:
                await send_to(device, file=str(p))
                emit("sendComplete", fileName=p.name)
                return
            except Exception as e:
                last_err = e
                await asyncio.sleep(min(1 * 2**_attempt, 16))
        emit("error", message=f"Send failed after retries: {last_err}")


# ── Main loop ────────────────────────────────────────────────────

_bridge = Bridge()


async def dispatch(data: dict):
    cmd = data.get("cmd")
    if cmd == "startReceiving":
        await _bridge.start_receiving(data.get("outputDir", ""))
    elif cmd == "stopReceiving":
        await _bridge.stop_receiving()
    elif cmd == "acceptTransfer":
        await _bridge.accept_transfer()
    elif cmd == "rejectTransfer":
        await _bridge.reject_transfer()
    elif cmd == "discoverDevices":
        await _bridge.discover()
    elif cmd == "sendFile":
        await _bridge.send_file(data.get("deviceIndex"), data.get("path", ""))
    elif cmd == "ping":
        emit("pong")


async def main():
    emit("ready")
    loop = asyncio.get_running_loop()

    def stdin_reader():
        for line in sys.stdin:
            line = line.strip()
            if not line:
                continue
            try:
                asyncio.run_coroutine_threadsafe(dispatch(json.loads(line)), loop)
            except Exception:
                pass

    threading.Thread(target=stdin_reader, daemon=True).start()
    await asyncio.Event().wait()


if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        pass
