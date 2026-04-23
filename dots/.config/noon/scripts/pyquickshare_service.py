#!/usr/bin/env python3
"""Quick Share backend service for Quickshell QML frontend."""

import asyncio
import importlib
import json
import os
import signal
import socket
import sys
import threading
import time
from pathlib import Path

from pyquickshare import discover_services, receive, send_to

try:

    async def _noop(*a, **kw):
        pass

    importlib.import_module("pyquickshare.firewalld").temporarily_open_port = _noop
except Exception:
    pass


_PID_FILE = Path(os.environ.get("XDG_RUNTIME_DIR", "/tmp")) / "quickshare-backend.pid"
_LOCK_FILE = Path(os.environ.get("XDG_RUNTIME_DIR", "/tmp")) / "quickshare-backend.lock"


def _acquire_lock() -> bool:
    try:
        fd = os.open(str(_LOCK_FILE), os.O_CREAT | os.O_EXCL | os.O_WRONLY)
        os.write(fd, str(os.getpid()).encode())
        os.close(fd)
        return True
    except FileExistsError:
        try:
            existing_pid = int(_LOCK_FILE.read_text())
            os.kill(existing_pid, 0)
            return False
        except (ValueError, ProcessLookupError):
            _LOCK_FILE.unlink(missing_ok=True)
            return _acquire_lock()


def _release_lock():
    try:
        pid_in_lock = int(_LOCK_FILE.read_text())
        if pid_in_lock == os.getpid():
            _LOCK_FILE.unlink(missing_ok=True)
    except Exception:
        pass


def _write_pid():
    _PID_FILE.write_text(str(os.getpid()))


def _remove_pid():
    try:
        if int(_PID_FILE.read_text()) == os.getpid():
            _PID_FILE.unlink(missing_ok=True)
    except Exception:
        pass


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


class Bridge:
    def __init__(self):
        self._recv_task = None
        self._discovered = {}
        self._output_dir = str(Path.home() / "Downloads" / "QuickShare")
        self._pending_request = None
        self._discovering = False

    async def start_receiving(self, output_dir: str = ""):
        if self._recv_task and not self._recv_task.done():
            return emit("error", message="Receiver already active")

        if output_dir.strip():
            self._output_dir = output_dir

        try:
            os.makedirs(os.path.join(self._output_dir, "downloads"), exist_ok=True)
            os.chdir(self._output_dir)
        except Exception as e:
            return emit("error", message=f"Directory setup failed: {e}")

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
            return emit("error", message="Could not determine listening port")

        ip, hostname = local_ip(), socket.gethostname()
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
                emit(
                    "transferRequest",
                    sender=getattr(req.header, "file_name", "Unknown"),
                    pin=req.pin,
                )

                if await req.respond:
                    try:
                        results = await req.done
                        downloads_dir = os.path.join(self._output_dir, "downloads")
                        files = [
                            str(Path(self._output_dir) / r.path)
                            if hasattr(r, "path")
                            else r.name
                            for r in results
                        ]
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

    def _check_pending(self, action: str):
        req = self._pending_request
        if req is None or req.respond.done():
            emit("error", message=f"No pending transfer to {action}")
            return None
        return req

    async def accept_transfer(self):
        if req := self._check_pending("accept"):
            req.respond.set_result(True)
            emit("receiveProgress", progress=0.0)

    async def reject_transfer(self):
        if req := self._check_pending("reject"):
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
        if self._discovering:
            return emit("error", message="Discovery already in progress")
        self._discovering = True
        self._discovered = {}
        count = 0

        try:
            queue = await discover_services()
        except Exception as e:
            emit("error", message=f"Discovery init failed: {e}")
            self._discovering = False
            return emit("discoverDone", total=0)

        seen: set[str] = set()
        try:
            while count < 30:
                try:
                    info = await asyncio.wait_for(queue.get(), timeout=12.0)
                except asyncio.TimeoutError:
                    break
                if info.name in seen:
                    continue
                seen.add(info.name)
                props = info.properties or {}
                raw_name = props.get(b"n", b"") or props.get(b"name", b"")
                name = (
                    raw_name.decode(errors="ignore").strip()
                    or info.name.split(".")[0].replace("-", " ").strip().title()
                    or f"Device {count + 1}"
                )
                self._discovered[count] = info
                emit("deviceFound", index=count, name=name)
                count += 1
        except Exception as e:
            emit("error", message=f"Discovery error: {e}")
        finally:
            self._discovering = False
            emit("discoverDone", total=count)

    async def send_file(self, index: int, path: str):
        if not (device := self._discovered.get(index)):
            return emit("error", message=f"Device {index} not found")
        p = Path(path).absolute()
        if not p.is_file():
            return emit("error", message=f"File not found: {path}")
        emit("sendProgress", progress=0.0)
        last_err = None
        for attempt in range(4):
            try:
                await send_to(device, file=str(p))
                return emit("sendComplete", fileName=p.name)
            except Exception as e:
                last_err = e
                await asyncio.sleep(min(1 * 2**attempt, 16))
        emit("error", message=f"Send failed after retries: {last_err}")


_bridge = Bridge()


async def dispatch(data: dict):
    match data.get("cmd"):
        case "startReceiving":
            await _bridge.start_receiving(data.get("outputDir", ""))
        case "stopReceiving":
            await _bridge.stop_receiving()
        case "acceptTransfer":
            await _bridge.accept_transfer()
        case "rejectTransfer":
            await _bridge.reject_transfer()
        case "discoverDevices":
            await _bridge.discover()
        case "sendFile":
            await _bridge.send_file(data.get("deviceIndex"), data.get("path", ""))
        case "ping":
            emit("pong")


async def main():
    emit("ready")
    loop = asyncio.get_running_loop()

    def stdin_reader():
        for line in sys.stdin:
            if line := line.strip():
                try:
                    asyncio.run_coroutine_threadsafe(dispatch(json.loads(line)), loop)
                except Exception:
                    pass

    threading.Thread(target=stdin_reader, daemon=True).start()
    await asyncio.Event().wait()


if __name__ == "__main__":
    if not _acquire_lock():
        emit("error", message="Another instance is already running")
        sys.exit(1)

    import atexit

    atexit.register(_release_lock)
    atexit.register(_remove_pid)

    _write_pid()

    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        pass
    finally:
        _release_lock()
        _remove_pid()
