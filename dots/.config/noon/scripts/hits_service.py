import argparse
import hashlib
import json
import os
import random
import sys
import urllib.request
from concurrent.futures import ThreadPoolExecutor, as_completed

from ytmusicapi import YTMusic

CONFIG_PATH = os.path.expanduser("~/.config/HyprNoon/beats.json")

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


def load_config() -> dict:
    if not os.path.exists(CONFIG_PATH):
        return {}
    with open(CONFIG_PATH, "r", encoding="utf-8") as f:
        return json.load(f)


def get_hits_config(config: dict) -> dict:
    return config.get("hits", {})


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
        "isPlaylist": False,
        "tracks": [],
        "_thumb_url": thumb_url,
    } | ({"via": via} if via else {})


def build_playlist(item, via, tracks: list) -> dict:
    title = item.get("title", "Unknown")
    playlist_id = item.get("playlistId") or item.get("browseId", "")
    playlist_url = (
        f"https://music.youtube.com/playlist?list={playlist_id}" if playlist_id else ""
    )
    thumb_url = extract_thumbnail_url(item)
    return {
        "title": title,
        "artist": "Various",
        "url": playlist_url,
        "thumbnail": thumb_cache_path(playlist_url) if playlist_url else "",
        "isPlaylist": True,
        "tracks": tracks,
        "_thumb_url": thumb_url,
    } | ({"via": via} if via else {})


def fetch_playlist_tracks(yt: YTMusic, playlist_id: str) -> list:
    try:
        data = yt.get_playlist(playlist_id, limit=50)
        raw_tracks = data.get("tracks", [])
        result = []
        for t in raw_tracks:
            video_id = t.get("videoId")
            if not video_id:
                continue
            artists = t.get("artists") or []
            artist = artists[0].get("name", "Unknown") if artists else "Unknown"
            song_url = f"https://music.youtube.com/watch?v={video_id}"
            result.append(
                {
                    "title": t.get("title", "Unknown"),
                    "artist": artist,
                    "url": song_url,
                    "thumbnail": thumb_cache_path(song_url),
                }
            )
        return result
    except Exception:
        return []


def fetch_thumbnails_async(items):
    pool = ThreadPoolExecutor(max_workers=CPU_COUNT)
    for item in items:
        thumb_url = item.pop("_thumb_url", "")
        pool.submit(fetch_thumbnail, item["url"], thumb_url)
    pool.shutdown(wait=False)


def fetch_seed_tracks(seed, limit):
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


def fetch_seed_playlists(seed, limit):
    yt = YTMusic()
    try:
        search = yt.search(seed, filter="playlists")
        if not search:
            return []
        results = []
        for item in search[:limit]:
            playlist_id = item.get("playlistId") or item.get("browseId", "")
            if not playlist_id:
                continue
            tracks = fetch_playlist_tracks(yt, playlist_id)
            results.append(build_playlist(item, via=seed, tracks=tracks))
        return results
    except Exception:
        return []


def cmd_search(args):
    yt = YTMusic()
    results = yt.search(args.query, filter="songs", limit=args.limit)
    tracks = [build_track(item, via="search") for item in results[: args.limit]]
    fetch_thumbnails_async(tracks)
    print(json.dumps(tracks, indent=2, ensure_ascii=False))


def cmd_recommend(args):
    config = load_config()
    hits_config = get_hits_config(config)
    recommendations_mode = hits_config.get("recommendationsMode", "tracks")

    with open(args.file, "r", encoding="utf-8") as f:
        library = json.load(f)

    local_tracks = {
        f"{item.get('artist', '')} - {item.get('title', '')}".strip().lower()
        for item in library.values()
    }
    seen_keys = set(local_tracks)
    track_list = list(local_tracks)
    num_seeds = max(3, args.limit // 4)
    seeds = random.sample(track_list, min(len(track_list), num_seeds))

    recommendations = []

    if recommendations_mode in ("tracks", "both"):
        with ThreadPoolExecutor(max_workers=CPU_COUNT) as pool:
            futures = {
                pool.submit(fetch_seed_tracks, seed, args.limit): seed for seed in seeds
            }
            for future in as_completed(futures):
                for track in future.result():
                    if len(recommendations) >= args.limit:
                        break
                    key = f"{track['artist']} - {track['title']}".lower()
                    if key in seen_keys:
                        continue
                    seen_keys.add(key)
                    recommendations.append(track)
                if len(recommendations) >= args.limit:
                    break

    if recommendations_mode in ("playlists", "both"):
        seen_urls = {r["url"] for r in recommendations}
        with ThreadPoolExecutor(max_workers=CPU_COUNT) as pool:
            futures = {
                pool.submit(fetch_seed_playlists, seed, 3): seed for seed in seeds
            }
            for future in as_completed(futures):
                for playlist in future.result():
                    if len(recommendations) >= args.limit:
                        break
                    if playlist["url"] in seen_urls:
                        continue
                    seen_urls.add(playlist["url"])
                    recommendations.append(playlist)
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
