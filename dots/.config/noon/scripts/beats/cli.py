import argparse
import json
import os
import subprocess
import sys
import time

import mpd

from .library import LibraryManager
from .player import Player

MPD_CONF = os.path.expanduser("~/.config/mpd/mpd.conf")
MPD_SOCKET = os.path.expanduser("~/.cache/noon/beats/mpd/socket")


def _mpd_ping(sock: str, timeout: float = 3) -> bool:
    try:
        c = mpd.MPDClient()
        c.timeout = timeout
        c.connect(sock, 0)
        c.ping()
        c.disconnect()
        return True
    except Exception:
        return False


def _wait_for_mpd(sock: str, max_sec: int = 15) -> bool:
    for _ in range(max_sec * 2):
        if _mpd_ping(sock):
            return True
        time.sleep(0.5)
    return False


def _ensure_mpd():
    if _mpd_ping(MPD_SOCKET):
        print("MPD already running.", flush=True)
        return

    if os.path.exists(MPD_SOCKET):
        print("Removing stale MPD socket...", flush=True)
        os.remove(MPD_SOCKET)

    print("Starting MPD...", flush=True)
    try:
        subprocess.run(
            ["systemctl", "--user", "start", "mpd"],
            capture_output=True, timeout=10,
        )
    except Exception:
        subprocess.Popen(
            ["mpd", MPD_CONF],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )

    if _wait_for_mpd(MPD_SOCKET):
        print("  MPD started.", flush=True)
    else:
        print("  Failed to start MPD.", file=sys.stderr, flush=True)
        sys.exit(1)


def _ensure_mpd_mpris():
    if _pgrep_alive(r"[m]pd-mpris.*unix.*" + MPD_SOCKET.replace("/", r"\/")) and _mpd_ping(MPD_SOCKET):
        print("mpd-mpris already running.", flush=True)
        return

    print("Starting mpd-mpris...", flush=True)
    subprocess.Popen(
        ["mpd-mpris", "-network", "unix", "-host", MPD_SOCKET],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    time.sleep(1)

    if _pgrep_alive("[m]pd-mpris"):
        print("  mpd-mpris started.", flush=True)
    else:
        print("  Warning: mpd-mpris may not have started.", file=sys.stderr, flush=True)


def init(player: str, port: int):
    _ensure_mpd()
    _ensure_mpd_mpris()

    import asyncio
    from .web_client import BeatsWebServer
    print(f"Starting beats web server on port {port}...", flush=True)
    asyncio.run(BeatsWebServer(player, port).start())


def _pgrep_alive(pattern: str) -> bool:
    try:
        r = subprocess.run(
            ["ps", "-eo", "pid,stat,args"],
            capture_output=True, text=True, timeout=5,
        )
        for line in r.stdout.splitlines():
            if pattern in line:
                parts = line.split(None, 2)
                if len(parts) >= 2 and not parts[1].startswith("Z"):
                    return True
        return False
    except Exception:
        return True


def kill():
    print("Stopping mpd-mpris...", flush=True)
    subprocess.run(["pkill", "-f", r"[m]pd-mpris"], capture_output=True, timeout=5)
    time.sleep(1)

    if _pgrep_alive("[m]pd-mpris"):
        print("  Force killing mpd-mpris...", flush=True)
        subprocess.run(["pkill", "-9", "-f", r"[m]pd-mpris"], capture_output=True, timeout=5)
        time.sleep(0.5)

    print(f"  mpd-mpris {'still running' if _pgrep_alive('[m]pd-mpris') else 'stopped'}.", flush=True)

    if _mpd_ping(MPD_SOCKET):
        print("Stopping MPD...", flush=True)
        r = subprocess.run(
            ["systemctl", "stop", "mpd"],
            capture_output=True, timeout=10,
        )
        if r.returncode != 0:
            subprocess.run(["pkill", "mpd"], capture_output=True, timeout=5)
        time.sleep(1.5)

        if _mpd_ping(MPD_SOCKET):
            print("  Force killing MPD...", flush=True)
            subprocess.run(["pkill", "-9", "mpd"], capture_output=True, timeout=5)

    if os.path.exists(MPD_SOCKET):
        os.remove(MPD_SOCKET)
        print("  Socket cleaned.", flush=True)

    print("MPD stopped.", flush=True)


def main():
    parser = argparse.ArgumentParser(description="beats - MPD controller")
    parser.add_argument("--player", type=str, default="main")
    parser.add_argument("--port", type=int, default=8090)
    parser.add_argument(
        "command",
        choices=[
            "play-file",
            "play-url",
            "play-by-name",
            "play-pause",
            "next",
            "prev",
            "stop",
            "seek",
            "volume",
            "status",
            "refresh-config",
            "resume-main",
            "queue",
            "queue-add",
            "queue-remove",
            "queue-move",
            "queue-clear",
            "build-playlist",
            "library",
            "list-artists",
            "list-albums",
            "list-genres",
            "build-covers",
            "update-db",
            "serve",
            "init",
            "kill",
        ],
    )
    parser.add_argument("--index", type=int, default=0)
    parser.add_argument("--new-index", type=int, default=0)
    parser.add_argument("--seconds", type=float, default=5.0)
    parser.add_argument("--volume", type=int, default=50)
    parser.add_argument("--file", type=str, default="")
    parser.add_argument("--url", type=str, default="")
    parser.add_argument("--name", type=str, default="")
    parser.add_argument("--list", type=str, default="", dest="list_titles")
    args = parser.parse_args()

    if args.command == "init":
        init(args.player, args.port)
        return

    if args.command == "kill":
        kill()
        return

    if args.command == "serve":
        import asyncio
        from .web_client import BeatsWebServer
        asyncio.run(BeatsWebServer(args.player, args.port).start())
        return

    p = Player(args.player)
    lib = LibraryManager(args.player)

    dispatch = {
        "play-file": lambda: p.play_file(args.file),
        "play-url": lambda: p.play_url(args.url),
        "play-by-name": lambda: p.play_by_name(args.name),
        "play-pause": p.play_pause,
        "next": p.next,
        "prev": p.prev,
        "stop": p.stop,
        "seek": lambda: p.seek(args.seconds),
        "volume": lambda: p.set_volume(args.volume),
        "status": lambda: print(json.dumps(p.status())),
        "refresh-config": p.refresh_config,
        "resume-main": p.resume_main,
        "queue": lambda: print(json.dumps(p.get_queue())),
        "queue-add": lambda: p.queue_add(args.url or args.file),
        "queue-remove": lambda: p.queue_remove(args.index),
        "queue-move": lambda: p.queue_move(args.index, args.new_index),
        "queue-clear": p.queue_clear,
        "build-playlist": lambda: p.build_playlist(args.list_titles),
        "library": lambda: print(json.dumps(lib.get_library())),
        "list-artists": lambda: print(json.dumps(lib.list_artists())),
        "list-albums": lambda: print(json.dumps(lib.list_albums())),
        "list-genres": lambda: print(json.dumps(lib.list_genres())),
        "build-covers": lib.build_covers,
        "update-db": lambda: (p.update_db(), print("Database update triggered.")),
    }
    dispatch[args.command]()


if __name__ == "__main__":
    main()
