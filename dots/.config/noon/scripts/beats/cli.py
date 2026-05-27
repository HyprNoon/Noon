import argparse
import json
import os
import subprocess
import sys
import time

import mpd

from .config import load_conf
from .library import LibraryManager
from .player import Player

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


def _mpd_conf(name: str, host: str, music_dir: str) -> str:
    sock_dir = os.path.dirname(host)
    os.makedirs(sock_dir, exist_ok=True)
    return (
        f'music_directory "{music_dir}"\n'
        f'db_file "{os.path.join(sock_dir, name)}.db"\n'
        f'pid_file "{os.path.join(sock_dir, name)}.pid"\n'
        f'log_file "{os.path.join(sock_dir, name)}.log"\n'
        f'bind_to_address "{host}"\n'
        'restore_paused "yes"\n'
        'auto_update "yes"\n'
        'audio_output {\n'
        '  type "pipewire"\n'
        f'  name "{name}"\n'
        '}\n'
    )


def _ensure_mpd(name: str, host: str, music_dir: str):
    if _mpd_ping(host):
        return

    if os.path.exists(host):
        os.remove(host)

    print(f"Starting MPD ({name}) on {host}...", file=sys.stderr, flush=True)
    conf = _mpd_conf(name, host, music_dir)
    conf_file = os.path.join(os.path.dirname(host), f"{name}.conf")
    with open(conf_file, "w") as f:
        f.write(conf)
    subprocess.Popen(
        ["mpd", conf_file],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )

    if _wait_for_mpd(host):
        print(f"  {name} ready.", file=sys.stderr, flush=True)
    else:
        print(f"  Failed to start MPD ({name}).", file=sys.stderr, flush=True)
        sys.exit(1)


BRIDGE_BIN = "mpd-mpris"


def _kill_bridge():
    subprocess.run(["killall", "-9", "mpd-mpris"], capture_output=True, timeout=5)
    subprocess.run(["killall", "mpd-mpris"], capture_output=True, timeout=5)
    time.sleep(0.5)


def _ensure_mpd_mpris():
    _kill_bridge()

    print("Starting MPRIS bridge...", file=sys.stderr, flush=True)
    subprocess.Popen(
        [BRIDGE_BIN, "-network", "unix", "-host", MPD_SOCKET, "-no-instance"],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    time.sleep(1)


def init(player: str, port: int):
    conf = load_conf()
    players = conf.get("players", {})
    for name, pconf in players.items():
        if "host" not in pconf:
            continue
        music_dir = os.path.expanduser(pconf.get("musicDirectory", "~/Music"))
        host = os.path.expanduser(pconf["host"])
        _ensure_mpd(name, host, music_dir)

    _ensure_mpd_mpris()
    print("Init complete. Run 'beats serve' to start the web UI.", file=sys.stderr, flush=True)


def kill():
    _kill_bridge()
    subprocess.run(["killall", "-9", "mpd"], capture_output=True, timeout=5)
    time.sleep(1)

    for sock in os.listdir(os.path.dirname(MPD_SOCKET)):
        path = os.path.join(os.path.dirname(MPD_SOCKET), sock)
        if os.path.exists(path) and (sock.endswith("_socket") or sock == "socket"):
            os.remove(path)

    print("All stopped.", file=sys.stderr, flush=True)


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
            "fetch",
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

    conf = load_conf()
    pconf = conf.get("players", {}).get(args.player)
    if pconf:
        host = os.path.expanduser(pconf["host"])
        if not _mpd_ping(host):
            print(f"MPD ({args.player}) not running. Initializing...", file=sys.stderr, flush=True)
            init(args.player, args.port)
        else:
            _ensure_mpd_mpris()

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
        "fetch": lambda: (p.refresh_config(), lib.build_covers(), p.update_db(), print("Fetch complete.", file=sys.stderr)),
    }
    dispatch[args.command]()


if __name__ == "__main__":
    main()
