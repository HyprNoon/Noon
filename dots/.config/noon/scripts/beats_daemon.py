#!/usr/bin/env python3

import argparse
import json
import os
import re
import socket
import subprocess
import sys
import time
from urllib.parse import parse_qs, urlencode, urlparse, urlunparse

CONF_PATH = os.path.expanduser("~/.config/HyprNoon/beats.json")

DEFAULTS = {
    "players": {
        "main": {
            "socketPath": "/tmp/beats_main.sock",
            "mpvLog": "/tmp/beats_main.log",
            "loopPlaylist": True,
            "volumeNormalization": {"enabled": True, "replaygain": "track"},
            "eq": {"enabled": True, "eqBands": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]},
        },
        "preview": {
            "socketPath": "/tmp/beats_preview.sock",
            "mpvLog": "/tmp/beats_preview.log",
            "loopPlaylist": False,
            "volumeNormalization": {"enabled": False, "replaygain": "track"},
            "eq": {"enabled": False, "eqBands": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]},
        },
    }
}


def load_conf() -> dict:
    if not os.path.exists(CONF_PATH):
        os.makedirs(os.path.dirname(CONF_PATH), exist_ok=True)
        with open(CONF_PATH, "w") as f:
            json.dump(DEFAULTS, f, indent=4)
        return DEFAULTS
    with open(CONF_PATH, "r") as f:
        return json.load(f)


def get_player_conf(name: str) -> dict:
    conf = load_conf()
    players = conf.get("players", {})
    if name not in players:
        print(f"Unknown player: {name}")
        sys.exit(1)
    return players[name]


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

    def is_running(self) -> bool:
        if not os.path.exists(self.socket_path):
            return False
        result = self._send(["get_property", "pid"])
        return result is not None and result.get("error") == "success"

    def get_property(self, prop: str):
        result = self._send(["get_property", prop])
        if result and result.get("error") == "success":
            return result.get("data")
        return None

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
            cmd += [
                "--ytdl-format=bestaudio",
                "--ytdl-raw-options=yes-playlist=",
                source,
            ]
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

    def play_index(self, index: int, source: str):
        self.ensure_running(source)
        self._send(["playlist-play-index", index])

    def play_file(self, filepath: str, source: str):
        self.ensure_running(source)
        self._send(["loadfile", filepath, "replace"])

    def _normalize_url(self, url: str) -> str:

        parsed = urlparse(url)
        if "music.youtube.com" in (parsed.hostname or ""):
            parsed = parsed._replace(netloc="www.youtube.com")
        qs = parse_qs(parsed.query, keep_blank_values=True)
        if "list" in qs:
            qs["list"] = [re.sub(r"^VL", "", qs["list"][0])]
        new_query = urlencode({k: v[0] for k, v in qs.items()})
        return urlunparse(parsed._replace(query=new_query))

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

    def register_dbus(self):
        from dasbus.connection import SessionMessageBus
        from dasbus.server.interface import dbus_interface
        from dasbus.typing import Bool, Dict, Double, Int, Str, Variant
        from gi.repository import GLib

        player = self
        obj_path = f"/org/mpris/MediaPlayer2/{self.name}"

        @dbus_interface("org.mpris.MediaPlayer2")
        class RootIface:
            def get_CanQuit(self) -> Bool:
                return True

            def get_CanRaise(self) -> Bool:
                return False

            def get_HasTrackList(self) -> Bool:
                return False

            def get_Identity(self) -> Str:
                return f"beats.{player.name}"

            def get_SupportedUriSchemes(self) -> Dict[Str, Str]:
                return {}

            def get_SupportedMimeTypes(self) -> Dict[Str, Str]:
                return {}

            def Quit(self) -> None:
                player.stop()

        @dbus_interface("org.mpris.MediaPlayer2.Player")
        class PlayerIface:
            def get_PlaybackStatus(self) -> Str:
                s = player.status()
                if not s["running"]:
                    return "Stopped"
                return "Paused" if s.get("paused") else "Playing"

            def get_LoopStatus(self) -> Str:
                return "Playlist" if player.conf.get("loopPlaylist") else "None"

            def set_LoopStatus(self, value: Str) -> None:
                pass

            def get_Shuffle(self) -> Bool:
                return False

            def set_Shuffle(self, value: Bool) -> None:
                pass

            def get_Volume(self) -> Double:
                v = player.get_property("volume")
                return (v or 100) / 100.0

            def set_Volume(self, value: Double) -> None:
                player._send(["set_property", "volume", value * 100])

            def get_Position(self) -> Int:
                pos = player.get_property("time-pos")
                return int((pos or 0) * 1_000_000)

            def get_MinimumRate(self) -> Double:
                return 1.0

            def get_MaximumRate(self) -> Double:
                return 1.0

            def get_Rate(self) -> Double:
                return 1.0

            def set_Rate(self, value: Double) -> None:
                pass

            def get_CanGoNext(self) -> Bool:
                return True

            def get_CanGoPrevious(self) -> Bool:
                return True

            def get_CanPlay(self) -> Bool:
                return True

            def get_CanPause(self) -> Bool:
                return True

            def get_CanSeek(self) -> Bool:
                return True

            def get_CanControl(self) -> Bool:
                return True

            def get_Metadata(self) -> Dict[Str, Variant]:
                s = player.status()
                return {
                    "mpris:trackid": Variant(
                        "o", "/org/mpris/MediaPlayer2/TrackList/NoTrack"
                    ),
                    "xesam:title": Variant("s", s.get("title") or ""),
                    "mpris:length": Variant(
                        "x", int((s.get("duration") or 0) * 1_000_000)
                    ),
                }

            def PlayPause(self) -> None:
                player.play_pause("")

            def Play(self) -> None:
                player._send(["set_property", "pause", False])

            def Pause(self) -> None:
                player._send(["set_property", "pause", True])

            def Next(self) -> None:
                player.next("")

            def Previous(self) -> None:
                player.prev("")

            def Stop(self) -> None:
                player.stop()

            def Seek(self, offset: Int) -> None:
                player.seek(offset / 1_000_000, "")

            def SetPosition(self, track_id: Str, position: Int) -> None:
                player._send(["seek", position / 1_000_000, "absolute"])

            def OpenUri(self, uri: Str) -> None:
                player.play_url(uri)

        @dbus_interface(f"org.mpris.MediaPlayer2.beats.{self.name}")
        class BeatsIface:
            def PlayIndex(self, index: Int, source: Str) -> None:
                player.play_index(index, source)

            def PlayFile(self, filepath: Str, source: Str) -> None:
                player.play_file(filepath, source)

            def PlayUrl(self, url: Str) -> None:
                player.play_url(url)

            def RefreshConfig(self) -> None:
                player.refresh_config()

            def Status(self) -> Str:
                return json.dumps(player.status())

        bus = SessionMessageBus()
        bus.publish_object(obj_path, RootIface())
        bus.publish_object(obj_path, PlayerIface())
        bus.publish_object(obj_path, BeatsIface())
        bus.register_service(self.bus_name)
        GLib.MainLoop().run()


def ensure_dbus():
    conf = load_conf()
    for name in conf.get("players", {}):
        pid_file = f"/tmp/beats_{name}.pid"
        if os.path.exists(pid_file):
            with open(pid_file) as f:
                content = f.read().strip()
            try:
                pid = int(content)
                os.kill(pid, 0)
                continue
            except (ValueError, ProcessLookupError):
                pass
        proc = subprocess.Popen(
            [sys.executable, __file__, "--player", name, "session"],
            start_new_session=True,
        )
        with open(pid_file, "w") as f:
            f.write(str(proc.pid))
    time.sleep(0.5)


def main():
    parser = argparse.ArgumentParser(description="beats_daemon - MPV controller")
    parser.add_argument("--player", type=str, default="main")
    parser.add_argument(
        "command",
        choices=[
            "play-index",
            "play-file",
            "play-url",
            "play-pause",
            "next",
            "prev",
            "stop",
            "seek",
            "status",
            "refresh-config",
            "session",
        ],
    )
    parser.add_argument("--index", type=int, default=0)
    parser.add_argument("--seconds", type=float, default=5.0)
    parser.add_argument("--source", type=str, default="")
    parser.add_argument("--file", type=str, default="")
    parser.add_argument("--url", type=str, default="")
    args = parser.parse_args()

    if args.command == "session":
        Player(args.player).register_dbus()
        return

    ensure_dbus()
    p = Player(args.player)

    dispatch = {
        "play-index": lambda: p.play_index(args.index, args.source),
        "play-file": lambda: p.play_file(args.file, args.source),
        "play-url": lambda: p.play_url(args.url),
        "play-pause": lambda: p.play_pause(args.source),
        "next": lambda: p.next(args.source),
        "prev": lambda: p.prev(args.source),
        "stop": p.stop,
        "seek": lambda: p.seek(args.seconds, args.source),
        "refresh-config": p.refresh_config,
        "status": lambda: print(json.dumps(p.status())),
    }

    dispatch[args.command]()


if __name__ == "__main__":
    main()
