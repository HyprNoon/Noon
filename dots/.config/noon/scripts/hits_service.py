import argparse
import hashlib
import json
import os
import random
import urllib.request
from concurrent.futures import ThreadPoolExecutor

from ytmusicapi import YTMusic

CONFIG_PATH = os.path.expanduser("~/.noon/beats.json")
CACHE_DIR = os.path.expanduser("~/.cache/noon/user/generated/beats/hitsCovers")
CPU_COUNT = os.cpu_count() or 8

yt = YTMusic()


def load_config() -> dict:
    if not os.path.exists(CONFIG_PATH):
        return {}
    try:
        with open(CONFIG_PATH, "r", encoding="utf-8") as f:
            return json.load(f)
    except:
        return {}


def save_config(config: dict):
    os.makedirs(os.path.dirname(CONFIG_PATH), exist_ok=True)
    with open(CONFIG_PATH, "w", encoding="utf-8") as f:
        json.dump(config, f, indent=2, ensure_ascii=False)


def thumb_cache_path(url: str) -> str:
    return os.path.join(CACHE_DIR, hashlib.md5(url.encode()).hexdigest() + ".jpg")


def fetch_thumbnail(key: str, thumb_url: str):
    if not key or not thumb_url:
        return
    path = thumb_cache_path(key)
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
            pool.submit(
                fetch_thumbnail, item.get("url") or item.get("videoId", ""), t_url
            )


def extract_thumb(item):
    vid = item.get("videoId")
    if vid:
        return f"https://i.ytimg.com/vi/{vid}/mqdefault.jpg"
    ts = item.get("thumbnails")
    if isinstance(ts, list) and ts:
        return ts[0].get("url", "")
    return ""


def build_track(item, via):
    vid = item.get("videoId")
    url = f"https://music.youtube.com/watch?v={vid}" if vid else ""
    arts = item.get("artists") or []
    return {
        "title": item.get("title", "Unknown"),
        "artist": arts[0].get("name", "Unknown") if arts else "Unknown",
        "videoId": vid,
        "url": url,
        "thumbnail": thumb_cache_path(url) if url else "",
        "isPlaylist": False,
        "tracks": [],
        "via": via,
        "views": item.get("views"),
        "duration": item.get("duration"),
        "year": item.get("year"),
        "isExplicit": item.get("isExplicit"),
        "album": item.get("album", {}).get("name") if item.get("album") else None,
        "_thumb_url": extract_thumb(item),
    }


def build_playlist(item, via):
    pid = item.get("playlistId") or item.get("browseId", "")
    url = f"https://music.youtube.com/playlist?list={pid}" if pid else ""
    return {
        "title": item.get("title", "Unknown"),
        "artist": "Various",
        "url": url,
        "thumbnail": thumb_cache_path(url) if url else "",
        "isPlaylist": True,
        "tracks": [],
        "via": via,
        "_thumb_url": extract_thumb(item),
    }


def cmd_search(args):
    res = yt.search(args.query, filter="songs", limit=args.limit)
    tracks = [build_track(i, "search") for i in res[: args.limit]]
    fetch_thumbnails_async(tracks)
    print(json.dumps(tracks, indent=2, ensure_ascii=False))


def cmd_recommend(args):
    if not os.path.exists(args.file):
        return
    with open(args.file, "r") as f:
        lib = json.load(f)
    usable = [s for s in lib if s.get("artist") or s.get("title")]
    if not usable:
        return
    raw = random.sample(usable, min(len(usable), 5))
    recs = []
    for s in raw:
        res = yt.search(f"{s.get('artist', '')} {s.get('title', '')}", filter="songs")
        if res:
            try:
                wp = yt.get_watch_playlist(videoId=res[0]["videoId"], limit=args.limit)
                recs.extend(
                    build_track(t, "recommend") for t in wp["tracks"] if "videoId" in t
                )
            except:
                continue
    random.shuffle(recs)
    final = recs[: args.limit]
    fetch_thumbnails_async(final)
    print(json.dumps(final, indent=2, ensure_ascii=False))


def cmd_discover(args):
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

    s = sub.add_parser("search")
    s.add_argument("--query", required=True)
    s.add_argument("--limit", type=int, default=20)

    r = sub.add_parser("recommend")
    r.add_argument("file")
    r.add_argument("--limit", type=int, default=20)

    d = sub.add_parser("discover")
    d.add_argument("--limit", type=int, default=20)

    args = parser.parse_args()
    {"search": cmd_search, "recommend": cmd_recommend, "discover": cmd_discover}[
        args.command
    ](args)


if __name__ == "__main__":
    main()
