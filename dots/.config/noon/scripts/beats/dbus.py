import json
import os
import subprocess
import sys
import time

from .config import load_conf


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


def register_dbus(player):
    from dasbus.connection import SessionMessageBus
    from dasbus.server.interface import dbus_interface
    from dasbus.typing import Bool, Dict, Double, Int, Str, Variant
    from gi.repository import GLib

    obj_path = f"/org/mpris/MediaPlayer2/{player.name}"

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
                "mpris:length": Variant("x", int((s.get("duration") or 0) * 1_000_000)),
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

    @dbus_interface(f"org.mpris.MediaPlayer2.beats.{player.name}")
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
    bus.register_service(player.bus_name)
    GLib.MainLoop().run()
