import json
import os
import sys

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
