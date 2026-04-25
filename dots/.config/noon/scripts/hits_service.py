import argparse
import hashlib
import json
import os
import random
import sys
import urllib.request
from concurrent.futures import ThreadPoolExecutor, as_completed

from ytmusicapi import YTMusic

CACHE_DIR = os.path.join(
    os.path.expanduser("~"),
    ".cache",
    "noon",
    "user",
    "generated",
    "beats",
    "hitsCovers",
)
CPU_COUNT = os.cpu_count()


def ensure_cache_dir():
    os.makedirs(CACHE_DIR, exist_ok=True)


def thumb_cache_path(song_url: str) -> str:
    return os.path.join(CACHE_DIR, hashlib.md5(song_url.encode()).hexdigest() + ".jpg")


def fetch_thumbnail(song_url: str, thumb_url: str) -> None:
    if not thumb_url or not song_url:
        return
    path = thumb_cache_path(song_url)
    if os.path.exists(path):
        return
    ensure_cache_dir()
    try:
        req = urllib.request.Request(thumb_url, headers={"User-Agent": "Mozilla/5.0"})
        with urllib.request.urlopen(req, timeout=10) as resp, open(path, "wb") as f:
            f.write(resp.read())
    except Exception:
        pass


def low_res_thumb_url(video_id: str) -> str:
    return f"https://i.ytimg.com/vi/{video_id}/mqdefault.jpg"


def extract_thumbnail_url(item):
    video_id = item.get("videoId")
    if video_id:
        return low_res_thumb_url(video_id)
    thumbs = item.get("thumbnails")
    if isinstance(thumbs, list) and thumbs:
        url = thumbs[0].get("url", "")
        if url:
            return url
    thumb = item.get("thumbnail")
    if isinstance(thumb, dict):
        nested = thumb.get("thumbnails", [])
        if nested:
            return nested[0].get("url", "")
    return ""


def build_track(item, via):
    title = item.get("title", "Unknown")
    video_id = item.get("videoId")
    artists = item.get("artists") or []
    artist = artists[0].get("name", "Unknown") if artists else "Unknown"
    song_url = f"https://music.youtube.com/watch?v={video_id}" if video_id else ""
    thumb_url = extract_thumbnail_url(item)
    return {
        "title": title,
        "artist": artist,
        "url": song_url,
        "thumbnail": thumb_cache_path(song_url) if song_url else "",
        "_thumb_url": thumb_url,
    } | ({"via": via} if via else {})


def fetch_thumbnails_async(tracks):
    pool = ThreadPoolExecutor(max_workers=CPU_COUNT)
    for track in tracks:
        pool.submit(fetch_thumbnail, track["url"], track.pop("_thumb_url"))
    pool.shutdown(wait=False)


def fetch_seed(seed, limit):
    yt = YTMusic()
    try:
        search = yt.search(seed, filter="songs")
        if not search:
            return []
        video_id = search[0].get("videoId")
        if not video_id:
            return []
        playlist = yt.get_watch_playlist(videoId=video_id, limit=15)
        return [
            build_track(item, via=seed)
            for item in playlist.get("tracks", [])
            if item.get("videoId")
        ]
    except Exception:
        return []


def cmd_search(args):
    yt = YTMusic()
    results = yt.search(args.query, filter="songs", limit=args.limit)
    tracks = [build_track(item, via="search") for item in results[: args.limit]]
    fetch_thumbnails_async(tracks)
    print(json.dumps(tracks, indent=2, ensure_ascii=False))


def cmd_recommend(args):
    with open(args.file, "r", encoding="utf-8") as f:
        library = json.load(f)
    local_tracks = {
        f"{item.get('artist', '')} - {item.get('title', '')}".strip().lower()
        for item in library.values()
    }
    seen = set(local_tracks)
    track_list = list(local_tracks)
    num_seeds = max(3, args.limit // 4)
    seeds = random.sample(track_list, min(len(track_list), num_seeds))
    recommendations = []
    with ThreadPoolExecutor(max_workers=CPU_COUNT) as pool:
        futures = {pool.submit(fetch_seed, seed, args.limit): seed for seed in seeds}
        for future in as_completed(futures):
            for track in future.result():
                if len(recommendations) >= args.limit:
                    break
                key = f"{track['artist']} - {track['title']}".lower()
                if key in seen:
                    continue
                seen.add(key)
                recommendations.append(track)
            if len(recommendations) >= args.limit:
                break
    random.shuffle(recommendations)
    recommendations = recommendations[: args.limit]
    fetch_thumbnails_async(recommendations)
    print(json.dumps(recommendations, indent=2, ensure_ascii=False))


def main():
    parser = argparse.ArgumentParser()
    sub = parser.add_subparsers(dest="command", required=True)
    p_search = sub.add_parser("search")
    p_search.add_argument("--query", required=True)
    p_search.add_argument("--limit", type=int, default=20)
    p_recommend = sub.add_parser("recommend")
    p_recommend.add_argument("file")
    p_recommend.add_argument("--limit", type=int, default=20)
    args = parser.parse_args()
    try:
        if args.command == "search":
            cmd_search(args)
        elif args.command == "recommend":
            cmd_recommend(args)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
