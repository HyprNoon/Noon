import json
import os
import re
import socket
import subprocess
import sys
import time
from urllib.parse import parse_qs, urlencode, urlparse, urlunparse

from .config import get_player_conf, set_player_conf


class Player:
    def __init__(self, name: str):
        self.name = name
        self.conf = get_player_conf(name)
        self.socket_path = self.conf["socketPath"]
        self.pid_file = f"/tmp/beats_{name}.pid"
        self.bus_name = f"org.mpris.MediaPlayer2.beats.{name}"

    def _send(self, command: list):
        payload = json.dumps({"command": command}) + "\n"
        try:
            with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as s:
                s.connect(self.socket_path)
                s.sendall(payload.encode())
                s.settimeout(2)
                try:
                    return json.loads(s.recv(4096).decode().strip())
                except (socket.timeout, json.JSONDecodeError):
                    return None
        except (ConnectionRefusedError, FileNotFoundError, OSError):
            return None

    def _normalize_url(self, url: str) -> str:
        parsed = urlparse(url)
        if "music.youtube.com" in (parsed.hostname or ""):
            parsed = parsed._replace(netloc="www.youtube.com")
        qs = parse_qs(parsed.query, keep_blank_values=True)
        if "list" in qs:
            qs["list"] = [re.sub(r"^VL", "", qs["list"][0])]
        new_query = urlencode({k: v[0] for k, v in qs.items()})
        return urlunparse(parsed._replace(query=new_query))

    def is_running(self) -> bool:
        if not os.path.exists(self.socket_path):
            return False
        result = self._send(["get_property", "pid"])
        return result is not None and result.get("error") == "success"

    def launch(self, source: str) -> bool:
        cmd = [
            "mpv",
            "--no-video",
            "--no-terminal",
            "--idle=yes",
            "--gapless-audio=yes",
            f"--input-ipc-server={self.socket_path}",
        ]
        if self.conf.get("loopPlaylist", False):
            cmd.append("--loop-playlist=inf")
        vn = self.conf.get("volumeNormalization", {})
        if vn.get("enabled", False):
            cmd.append(f"--replaygain={vn.get('replaygain', 'track')}")
        if source.startswith("http"):
            cmd += ["--ytdl-format=bestaudio", source]
        else:
            cmd.append(f"--playlist={source}")
        with open(self.conf["mpvLog"], "a") as log:
            subprocess.Popen(cmd, stdout=log, stderr=log, start_new_session=True)
        for _ in range(30):
            time.sleep(0.2)
            if self.is_running():
                count = self.get_property("playlist-count")
                if count is not None and int(count) > 0:
                    self.apply_eq()
                    return True
        return False

    def ensure_running(self, source: str) -> bool:
        if self.is_running():
            return True
        if os.path.exists(self.socket_path):
            os.remove(self.socket_path)
        return self.launch(source)

    def stop(self):
        self._send(["quit"])
        if os.path.exists(self.socket_path):
            os.remove(self.socket_path)
        if os.path.exists(self.pid_file):
            with open(self.pid_file) as f:
                content = f.read().strip()
            try:
                subprocess.run(["kill", content])
            except Exception:
                pass
            os.remove(self.pid_file)

    def refresh_config(self):
        self.conf = get_player_conf(self.name)
        if self.is_running():
            self.apply_eq()

    def build_eq_filter(self) -> str:
        freqs = [31, 62, 125, 250, 500, 1000, 2000, 4000, 8000, 16000]
        bands = self.conf["eq"]["eqBands"]
        parts = [
            f"equalizer=f={freq}:width_type=o:width=2:g={float(gain)}"
            for freq, gain in zip(freqs, bands)
        ]
        return ",".join(parts)

    def apply_eq(self):
        eq = self.conf.get("eq", {})
        bands = eq.get("eqBands", [0] * 10)
        if not eq.get("enabled", False) or all(b == 0 for b in bands):
            self._send(["af", "set", ""])
            return
        if len(bands) == 10:
            self._send(["af", "set", f"lavfi=[{self.build_eq_filter()}]"])

    def get_property(self, prop: str):
        result = self._send(["get_property", prop])
        if result and result.get("error") == "success":
            return result.get("data")
        return None

    def play_index(self, index: int, source: str):
        self.ensure_running(source)
        self._send(["playlist-play-index", index])

    def play_file(self, filepath: str, source: str):
        self.ensure_running(source)
        self._send(["loadfile", filepath, "replace"])

    def play_url(self, url: str):
        url = self._normalize_url(url)
        if self.is_running():
            self._send(["quit"])
            for _ in range(20):
                time.sleep(0.1)
                if not self.is_running():
                    break
        if os.path.exists(self.socket_path):
            os.remove(self.socket_path)
        success = self.launch(url)
        if not success:
            print(f"Failed to launch player for URL: {url}", file=sys.stderr)

    def play_pause(self, source: str):
        self.ensure_running(source)
        self._send(["cycle", "pause"])

    def next(self, source: str):
        self.ensure_running(source)
        self._send(["playlist-next"])

    def prev(self, source: str):
        self.ensure_running(source)
        self._send(["playlist-prev"])

    def seek(self, seconds: float, source: str):
        self.ensure_running(source)
        self._send(["seek", seconds, "relative"])

    def status(self) -> dict:
        if not self.is_running():
            return {"running": False, "player": self.name}
        props = [
            "media-title",
            "playlist-pos",
            "pause",
            "time-pos",
            "duration",
            "volume",
        ]
        keys = ["title", "index", "paused", "position", "duration", "volume"]
        result = {"running": True, "player": self.name}
        for prop, key in zip(props, keys):
            r = self._send(["get_property", prop])
            result[key] = r.get("data") if r else None
        return result

    def get_queue(self) -> list:
        count = self.get_property("playlist-count")
        if not count:
            return []
        queue = []
        for i in range(int(count)):
            item = self.get_property(f"playlist/{i}")
            queue.append(
                {
                    "index": i,
                    "filename": item.get("filename", ""),
                    "title": item.get("title", item.get("filename", "")),
                    "current": item.get("current", False),
                    "playing": item.get("playing", False),
                }
            )
        current_index = next((i for i, t in enumerate(queue) if t["current"]), 0)
        return queue[current_index:] + queue[:current_index]

    def queue_add(self, url_or_path: str, source: str):
        """Appends a track to the end of the playlist."""
        self.ensure_running(source)
        url_or_path = (
            self._normalize_url(url_or_path)
            if url_or_path.startswith("http")
            else url_or_path
        )
        self._send(["loadfile", url_or_path, "append"])

    def queue_remove(self, index: int, source: str):
        """Removes a track by playlist index."""
        self.ensure_running(source)
        self._send(["playlist-remove", index])

    def queue_move(self, index: int, new_index: int, source: str):
        """Moves a track from index to new_index."""
        self.ensure_running(source)
        self._send(["playlist-move", index, new_index])

    def queue_clear(self, source: str):
        """Clears all tracks except the currently playing one."""
        self.ensure_running(source)
        self._send(["playlist-clear"])

    def sync_queue(self):
        queue = self.get_queue()
        set_player_conf("main", "queue", queue)
        return queue
