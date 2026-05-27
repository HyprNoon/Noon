#!/usr/bin/env python3
import argparse
import os
import sys

import yt_dlp

PRESETS = {
    ("audio", "best"): ("bestaudio/best", "mp3", "0"),
    ("audio", "standard"): ("bestaudio/best", "mp3", "5"),
    ("audio", "low"): ("bestaudio/best", "mp3", "9"),
    ("video", "best"): ("bestvideo+bestaudio/best", "mp4", None),
    ("video", "standard"): ("bestvideo[height<=720]+bestaudio/best", "mp4", None),
    ("video", "low"): ("bestvideo[height<=480]+bestaudio/best", "mp4", None),
}


def search_url(artist: str, title: str) -> str:
    with yt_dlp.YoutubeDL({"quiet": True, "extract_flat": True}) as ydl:
        info = ydl.extract_info(
            f"ytsearch1:{artist} {title} official audio", download=False
        )
    entries = (info or {}).get("entries") or []
    if not entries:
        sys.exit(f"error: no results for '{artist} – {title}'")
    return entries[0]["url"]


def run(url: str, destination: str, media: str, quality: str, dry_run: bool) -> None:
    fmt, ext, mp3q = PRESETS[(media, quality)]
    ydl_opts = {
        "quiet": True,
        "noplaylist": True,
        "cachedir": False,
        "writethumbnail": True,
        "outtmpl": os.path.join(destination, "%(track,title)s.%(ext)s"),
        "format": fmt,
    }
    if media == "audio":
        ydl_opts["postprocessors"] = [
            {
                "key": "FFmpegExtractAudio",
                "preferredcodec": "mp3",
                "preferredquality": mp3q,
            },
            {"key": "FFmpegMetadata", "add_metadata": True},
            {
                "key": "FFmpegThumbnailsConvertor",
                "format": "jpg",
                "when": "post_process",
            },
            {"key": "EmbedThumbnail"},
        ]
    else:
        ydl_opts["postprocessors"] = [
            {"key": "FFmpegMetadata", "add_metadata": True},
            {
                "key": "FFmpegThumbnailsConvertor",
                "format": "jpg",
                "when": "post_process",
            },
            {"key": "EmbedThumbnail"},
        ]
    if dry_run:
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            info = ydl.extract_info(url, download=False)
            out_path = ydl.prepare_filename(info)
        if media == "audio":
            out_path = os.path.splitext(out_path)[0] + ".mp3"
        print(f"url         : {url}")
        print(f"destination : {out_path}")
        print(f"media       : {media}  quality: {quality}")
        return

    def hook(d: dict) -> None:
        if d["status"] != "downloading":
            return
        recv = d.get("downloaded_bytes", 0)
        total = d.get("total_bytes") or d.get("total_bytes_estimate", 0)
        print(
            f"{recv},{total},{d.get('_speed_str', '?')},{d.get('_eta_str', '?')}",
            flush=True,
        )

    ydl_opts["progress_hooks"] = [hook]
    try:
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            ydl.download([url])
    except Exception as e:
        sys.exit(f"error: {e}")


def main() -> None:
    p = argparse.ArgumentParser(description="yt-dlp download helper")

    src = p.add_mutually_exclusive_group(required=True)
    src.add_argument("--url", help="Direct media URL")
    src.add_argument(
        "--search",
        nargs=2,
        metavar=("ARTIST", "TITLE"),
        help="Search YouTube by artist and title",
    )

    p.add_argument("--audio", dest="media", action="store_const", const="audio")
    p.add_argument("--video", dest="media", action="store_const", const="video")
    p.add_argument("--quality", choices=["best", "standard", "low"], default="best")
    p.add_argument("--destination", "-d", required=True)
    p.add_argument("--dry-run", action="store_true")

    args = p.parse_args()

    if args.media is None:
        p.error("one of --audio or --video is required")

    os.makedirs(args.destination, exist_ok=True)

    url = search_url(*args.search) if args.search else args.url
    run(url, args.destination, args.media, args.quality, args.dry_run)


if __name__ == "__main__":
    main()
