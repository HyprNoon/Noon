import argparse
import hashlib
import json
import os
import random
import subprocess
import sys
import tempfile
import time
import urllib.request
import webbrowser
from concurrent.futures import ThreadPoolExecutor

import ytmusicapi
from ytmusicapi import OAuthCredentials, YTMusic

CONFIG_PATH = os.path.expanduser("~/.config/HyprNoon/beats.json")
OAUTH_PATH = os.path.expanduser("~/.local/state/noon/user/generated/oauth.json")
CACHE_DIR = os.path.expanduser("~/.cache/noon/user/generated/beats/hitsCovers")
CPU_COUNT = os.cpu_count() or 4

_TOKEN_FIELDS = {
    "scope",
    "token_type",
    "access_token",
    "refresh_token",
    "expires_at",
    "expires_in",
    "refresh_token_expires_in",
}


def load_config() -> dict:
    if not os.path.exists(CONFIG_PATH):
        return {}
    with open(CONFIG_PATH, "r", encoding="utf-8") as f:
        return json.load(f)


def save_config(config: dict) -> None:
    os.makedirs(os.path.dirname(CONFIG_PATH), exist_ok=True)
    with open(CONFIG_PATH, "w", encoding="utf-8") as f:
        json.dump(config, f, indent=2, ensure_ascii=False)


def load_oauth() -> dict:
    if not os.path.exists(OAUTH_PATH):
        return {}
    with open(OAUTH_PATH, "r", encoding="utf-8") as f:
        return json.load(f)


def save_oauth(token: dict) -> None:
    os.makedirs(os.path.dirname(OAUTH_PATH), exist_ok=True)
    with open(OAUTH_PATH, "w", encoding="utf-8") as f:
        json.dump(token, f, indent=2, ensure_ascii=False)


def _sanitize_token(token: dict) -> dict:
    return {k: v for k, v in token.items() if k in _TOKEN_FIELDS}


def _get_oauth_credentials():
    cid = os.environ.get("YTMUSIC_CLIENT_ID")
    sec = os.environ.get("YTMUSIC_CLIENT_SECRET")
    return (cid, sec) if cid and sec else (None, None)


def get_yt_client(config: dict) -> YTMusic:
    token = load_oauth()
    cid, sec = _get_oauth_credentials()
    is_auth = bool(token and cid and sec)
    if config.get("isAuth") != is_auth:
        config["isAuth"] = is_auth
        save_config(config)
    if not is_auth:
        return YTMusic()
    with tempfile.NamedTemporaryFile(mode="w", suffix=".json", delete=False) as tmp:
        json.dump(token, tmp)
        tmp_path = tmp.name
    try:
        return YTMusic(tmp_path, oauth_credentials=OAuthCredentials(cid, sec))
    except Exception:
        config["isAuth"] = False
        save_config(config)
        return YTMusic()
    finally:
        if os.path.exists(tmp_path):
            os.remove(tmp_path)


def thumb_cache_path(url: str) -> str:
    return os.path.join(CACHE_DIR, hashlib.md5(url.encode()).hexdigest() + ".jpg")


def fetch_thumbnail(song_url: str, thumb_url: str):
    if not thumb_url or not song_url:
        return
    path = thumb_cache_path(song_url)
    if os.path.exists(path):
        return
    os.makedirs(CACHE_DIR, exist_ok=True)
    try:
        req = urllib.request.Request(thumb_url, headers={"User-Agent": "Mozilla/5.0"})
        with urllib.request.urlopen(req, timeout=10) as resp, open(path, "wb") as f:
            f.write(resp.read())
    except:
        pass


def fetch_thumbnails_async(items):
    with ThreadPoolExecutor(max_workers=CPU_COUNT) as pool:
        for item in items:
            t_url = item.pop("_thumb_url", "")
            pool.submit(fetch_thumbnail, item["url"], t_url)


def extract_thumb(item):
    vid = item.get("videoId")
    if vid:
        return f"https://i.ytimg.com/vi/{vid}/mqdefault.jpg"
    ts = item.get("thumbnails")
    if isinstance(ts, list) and ts:
        return ts[0].get("url", "")
    t = item.get("thumbnail")
    if isinstance(t, dict):
        nest = t.get("thumbnails", [])
        if nest:
            return nest[0].get("url", "")
    return ""


def build_track(item, via):
    vid = item.get("videoId")
    url = f"https://music.youtube.com/watch?v={vid}" if vid else ""
    arts = item.get("artists") or []
    return {
        "title": item.get("title", "Unknown"),
        "artist": arts[0].get("name", "Unknown") if arts else "Unknown",
        "url": url,
        "thumbnail": thumb_cache_path(url) if url else "",
        "isPlaylist": False,
        "tracks": [],
        "via": via,
        "_thumb_url": extract_thumb(item),
    }


def build_playlist(item, via, tracks=None):
    pid = item.get("playlistId") or item.get("browseId", "")
    url = f"https://music.youtube.com/playlist?list={pid}" if pid else ""
    return {
        "title": item.get("title", "Unknown"),
        "artist": "Various",
        "url": url,
        "thumbnail": thumb_cache_path(url) if url else "",
        "isPlaylist": True,
        "tracks": tracks or [],
        "via": via,
        "_thumb_url": extract_thumb(item),
    }


def perform_auth(cid, sec, interactive=False):
    creds = OAuthCredentials(cid, sec)
    device = creds.get_code()
    try:
        subprocess.run(["wl-copy"], input=device["user_code"].encode(), check=True)
    except:
        pass

    webbrowser.open(device["verification_url"])

    if interactive:
        print(f"URL: {device['verification_url']}\nCode: {device['user_code']}")
        input("Press Enter after authorizing...")
    else:
        notify_cmd = [
            "notify-send",
            "Noon Auth",
            f"Code: {device['user_code']}\nClick 'Done' after authorizing in browser.",
            "--action=done=Done",
            "--expire-time=0",
        ]
        subprocess.run(notify_cmd, stdout=subprocess.PIPE)

    return creds.token_from_code(device["device_code"])


def cmd_auth(args, interactive=False):
    config = load_config()
    if args.revoke:
        if os.path.exists(OAUTH_PATH):
            os.remove(OAUTH_PATH)
        config["isAuth"] = False
        save_config(config)
        return
    cid, sec = _get_oauth_credentials()
    if not cid:
        sys.exit(1)
    try:
        raw = perform_auth(cid, sec, interactive)
        save_oauth(_sanitize_token(raw))
        config["isAuth"] = True
        save_config(config)
        subprocess.run(["notify-send", "Noon", "Auth Successful!"])
    except Exception as e:
        subprocess.run(["notify-send", "Noon", f"Auth Failed: {e}"])
        sys.exit(1)


def cmd_search(args):
    yt = get_yt_client(load_config())
    res = yt.search(args.query, filter="songs", limit=args.limit)
    tracks = [build_track(i, "search") for i in res]
    fetch_thumbnails_async(tracks)
    print(json.dumps(tracks, indent=2, ensure_ascii=False))


def cmd_recommend(args):
    yt = get_yt_client(load_config())
    with open(args.file, "r") as f:
        lib = json.load(f)
    seeds = random.sample(list(lib.values()), min(len(lib), 5))
    recs = []
    for s in seeds:
        search = yt.search(f"{s.get('artist')} {s.get('title')}", filter="songs")
        if search:
            try:
                wp = yt.get_watch_playlist(
                    videoId=search[0]["videoId"], limit=args.limit
                )
                recs.extend(
                    [
                        build_track(t, "recommend")
                        for t in wp["tracks"]
                        if "videoId" in t
                    ]
                )
            except:
                continue
    random.shuffle(recs)
    final = recs[: args.limit]
    fetch_thumbnails_async(final)
    print(json.dumps(final, indent=2, ensure_ascii=False))


def cmd_discover(args):
    yt = get_yt_client(load_config())
    home = yt.get_home(limit=10)
    items = []
    for shelf in home:
        for i in shelf.get("contents", []):
            if "videoId" in i:
                items.append(build_track(i, shelf.get("title")))
            elif "playlistId" in i:
                items.append(build_playlist(i, shelf.get("title")))
    random.shuffle(items)
    final = items[: args.limit]
    fetch_thumbnails_async(final)
    print(json.dumps(final, indent=2, ensure_ascii=False))


def main():
    parser = argparse.ArgumentParser()
    sub = parser.add_subparsers(dest="command", required=True)
    sub.add_parser("auth").add_argument("--revoke", action="store_true")
    sub.add_parser("auth-cli").add_argument("--revoke", action="store_true")
    s = sub.add_parser("search")
    s.add_argument("--query", required=True)
    s.add_argument("--limit", type=int, default=20)
    r = sub.add_parser("recommend")
    r.add_argument("file")
    r.add_argument("--limit", type=int, default=20)
    d = sub.add_parser("discover")
    d.add_argument("--limit", type=int, default=20)
    args = parser.parse_args()
    if args.command == "auth":
        cmd_auth(args, interactive=False)
    elif args.command == "auth-cli":
        cmd_auth(args, interactive=True)
    elif args.command == "search":
        cmd_search(args)
    elif args.command == "recommend":
        cmd_recommend(args)
    elif args.command == "discover":
        cmd_discover(args)


if __name__ == "__main__":
    main()
