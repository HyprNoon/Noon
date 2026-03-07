#!/usr/bin/env python3
import json
import subprocess
import sys
import threading
import time

import psutil


def nmcli(*args):
    try:
        return (
            subprocess.check_output(
                ["nmcli"] + list(args), stderr=subprocess.DEVNULL, timeout=1
            )
            .decode()
            .strip()
        )
    except:
        return ""


def fmt_speed(bps):
    for unit in ("B/s", "KB/s", "MB/s", "GB/s"):
        if bps < 1024:
            return f"{bps:.1f} {unit}"
        bps /= 1024
    return f"{bps:.1f} TB/s"


class Cache:
    def __init__(self, ttl):
        self.ttl, self.val, self.exp = ttl, None, 0

    def get(self):
        return self.val if time.monotonic() < self.exp else None

    def set(self, v):
        self.val = v
        self.exp = time.monotonic() + self.ttl
        return v

    def clear(self):
        self.exp = 0


class NetworkMonitor:
    def __init__(self):
        self._iface = Cache(5)
        self._saved = Cache(10)
        self._conn = Cache(3)
        self._scan = ("", [])
        self._io = self._t = self._dl = self._ul = 0

    def iface(self):
        if v := self._iface.get():
            return v
        for n, s in psutil.net_if_stats().items():
            if s.isup and not n.startswith("lo"):
                return self._iface.set(n)
        return self._iface.set("")

    def ip(self):
        for a in psutil.net_if_addrs().get(self.iface(), []):
            if a.family.name == "AF_INET":
                return a.address
        return ""

    def speed(self):
        iface = self.iface()
        if not iface:
            return 0, 0
        io = psutil.net_io_counters(pernic=True).get(iface)
        if not io:
            return self._dl, self._ul
        now = time.monotonic()
        if self._io and (dt := now - self._t) >= 0.5:
            rx, tx = io.bytes_recv - self._io[0], io.bytes_sent - self._io[1]
            if rx >= 0 and tx >= 0:
                self._dl, self._ul = rx / dt, tx / dt
        self._io, self._t = (io.bytes_recv, io.bytes_sent), now
        return self._dl, self._ul

    def saved(self):
        if v := self._saved.get():
            return v
        out = nmcli("-t", "-f", "NAME,TYPE", "connection", "show")
        return self._saved.set(
            {l.split(":", 1)[0] for l in out.splitlines() if "802-11-wireless" in l}
        )

    def networks(self, raw):
        if raw == self._scan[0]:
            return self._scan[1]
        saved, seen, nets = self.saved(), set(), []
        for line in raw.splitlines():
            p = line.replace("\\:", "\x00").split(":")
            if len(p) < 3:
                continue
            ssid = p[2].replace("\x00", ":")
            if not ssid or ssid in seen:
                continue
            seen.add(ssid)
            sig = int(p[1]) if p[1].isdigit() else 0
            nets.append(
                {
                    "active": p[0] == "yes",
                    "ssid": ssid,
                    "strength": sig,
                    "strength_text": f"{sig}%",
                    "security": p[3] if len(p) > 3 else "",
                    "security_text": "Secured" if len(p) > 3 and p[3] else "Open",
                    "saved": ssid in saved,
                }
            )
        self._scan = (raw, nets)
        return nets

    def wifi_icon(self, sig, enabled, status, eth):
        if eth:
            return "lan"
        if not enabled:
            return "signal_wifi_off"
        if status == "connecting":
            return "signal_wifi_statusbar_not_connected"
        if status != "connected":
            return "wifi_find"
        return (
            "signal_wifi_0_bar",
            "network_wifi_1_bar",
            "network_wifi_2_bar",
            "network_wifi_3_bar",
            "network_wifi",
            "signal_wifi_4_bar",
        )[min(5, sig // 17)]

    def status(self):
        iface = self.iface()
        eth = iface.startswith(("eth", "enp", "eno"))
        wifi = iface.startswith(("wlan", "wlp"))
        enabled = nmcli("radio", "wifi") == "enabled"
        wstatus, signal = "disconnected", 0

        if wifi:
            s = nmcli("-t", "-f", "TYPE,STATE", "d", "status")
            if "wifi:connected" in s:
                wstatus = "connected"
                for l in nmcli("-f", "IN-USE,SIGNAL", "device", "wifi").splitlines():
                    if l.lstrip().startswith("*"):
                        try:
                            signal = int(l.split()[1])
                        except:
                            pass
                        break
            elif "wifi:connecting" in s:
                wstatus = "connecting"

        conn = self._conn.get()
        if conn is None:
            conn = self._conn.set(
                nmcli("-t", "-f", "NAME", "c", "show", "--active").split("\n")[0]
                if eth or wifi
                else ""
            )

        dl, ul = self.speed()
        nets = (
            self.networks(nmcli("-g", "ACTIVE,SIGNAL,SSID,SECURITY", "d", "w"))
            if enabled
            else []
        )

        return {
            "wifi_enabled": enabled,
            "ethernet": eth,
            "wifi": wifi,
            "wifi_status": wstatus,
            "network_name": conn,
            "ip_address": self.ip(),
            "signal_strength": signal,
            "signal_strength_text": f"{signal}%",
            "material_icon": self.wifi_icon(signal, enabled, wstatus, eth),
            "wifi_networks": nets,
            "download_speed": dl,
            "download_speed_text": fmt_speed(dl),
            "upload_speed": ul,
            "upload_speed_text": fmt_speed(ul),
        }

    def command(self, line):
        try:
            cmd = json.loads(line)
            a = cmd.get("action")
            if a == "toggle_wifi":
                nmcli(
                    "radio",
                    "wifi",
                    "off" if nmcli("radio", "wifi") == "enabled" else "on",
                )
                self._iface.clear()
            elif a == "enable_wifi":
                nmcli("radio", "wifi", "on" if cmd.get("enabled") else "off")
                self._iface.clear()
            elif a == "rescan_wifi":
                nmcli("dev", "wifi", "list", "--rescan", "yes")
                self._scan = ("", [])
            elif a == "connect":
                args = ["dev", "wifi", "connect", cmd["ssid"]]
                if cmd.get("password"):
                    args += ["password", cmd["password"]]
                nmcli(*args)
                self._saved.clear()
                self._conn.clear()
                self._iface.clear()
            elif a == "disconnect":
                nmcli("connection", "down", cmd["ssid"])
                self._conn.clear()
                self._iface.clear()
            elif a == "forget":
                nmcli("connection", "delete", cmd["ssid"])
                self._saved.clear()
        except Exception as e:
            print(json.dumps({"error": str(e)}), file=sys.stderr, flush=True)


def main():
    sys.stdout.reconfigure(line_buffering=True)
    m = NetworkMonitor()
    threading.Thread(
        target=lambda: [m.command(l.strip()) for l in sys.stdin if l.strip()],
        daemon=True,
    ).start()
    print(json.dumps({"status": "started"}), flush=True)
    while True:
        try:
            print(json.dumps(m.status()), flush=True)
            time.sleep(1)
        except KeyboardInterrupt:
            break
        except Exception as e:
            print(json.dumps({"error": str(e)}), flush=True)
            time.sleep(1)


if __name__ == "__main__":
    main()
