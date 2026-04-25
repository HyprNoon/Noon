import argparse
import json
import sys

from .dbus import ensure_dbus, register_dbus
from .player import Player


def main():
    parser = argparse.ArgumentParser(description="beats - MPV controller")
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
        register_dbus(Player(args.player))
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
