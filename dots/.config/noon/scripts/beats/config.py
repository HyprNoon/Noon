import json
import os
import sys

CONF_PATH = os.path.expanduser("~/.config/HyprNoon/beats.json")

DEFAULTS = {
    "players": {
        "main": {
            "host": os.path.expanduser("~/.cache/noon/beats/mpd/socket"),
            "port": 0,
            "password": "",
            "musicDirectory": os.path.expanduser("~/Music"),
        },
        "preview": {
            "host": os.path.expanduser("~/.cache/noon/beats/mpd/preview_socket"),
            "port": 0,
            "password": "",
            "musicDirectory": os.path.expanduser("~/Music"),
        },
    }
}


def load_conf() -> dict:
    if not os.path.exists(CONF_PATH):
        os.makedirs(os.path.dirname(CONF_PATH), exist_ok=True)
        with open(CONF_PATH, "w") as f:
            json.dump(DEFAULTS, f, indent=4)
        return DEFAULTS
    try:
        with open(CONF_PATH, "r") as f:
            return json.load(f)
    except (json.JSONDecodeError, IOError):
        os.makedirs(os.path.dirname(CONF_PATH), exist_ok=True)
        with open(CONF_PATH, "w") as f:
            json.dump(DEFAULTS, f, indent=4)
        return DEFAULTS


def get_player_conf(name: str) -> dict:
    conf = load_conf()
    players = conf.get("players", {})
    if name not in players:
        print(f"Unknown player: {name}")
        sys.exit(1)
    return players[name]


def set_player_conf(name: str, key: str, value):
    conf = load_conf()
    if name not in conf.get("players", {}):
        print(f"Unknown player: {name}")
        sys.exit(1)
    conf["players"][name][key] = value
    with open(CONF_PATH, "w") as f:
        json.dump(conf, f, indent=4, ensure_ascii=False)
