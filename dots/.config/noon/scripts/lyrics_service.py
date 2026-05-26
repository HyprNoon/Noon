#!/usr/bin/env python3
"""Fetches lyrics from LRCLib with disk cache. Outputs JSON to stdout."""

import argparse
import hashlib
import json
import os
import re
import sys
from urllib.parse import quote
from urllib.request import Request, urlopen

CACHE = os.path.expanduser("~/.cache/noon/beats/lyrics/")
LRCLIB = "https://lrclib.net/api/search"
UA = "beats-lyrics/1.0"


SEP = r"\s*(?:[–—－−_|/•·]|\s+-+\s+)\s*"


def clean_title(s, artist=""):
    s = re.sub(r"\s*[\(\[].*?[\)\]]\s*", " ", s)
    s = re.sub(
        r"\s*-\s*(Official|Lyric|Audio|Video|Music\s*Video|Visualizer|Remaster(?:ed)?)\s*$",
        "",
        s,
        flags=re.I,
    )
    s = re.sub(r"\s+", " ", s).strip().lower()

    if artist:
        a = re.escape(artist)
        s = re.sub(SEP + a + "$", "", s, flags=re.I)
        s = re.sub("^" + a + SEP, "", s, flags=re.I)
        s = s.strip()

    return s


def clean_artist(s):
    s = re.sub(r"\s+(?:feat\.|featuring|ft\.|with|x|&)\s+.*", "", s, flags=re.I)
    s = re.sub(r"\s*[\(\[].*?[\)\]]\s*", " ", s)
    return re.sub(r"\s+", " ", s).strip().lower()


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--title", required=True)
    p.add_argument("--artist", default="")
    p.add_argument("--cache-dir", default=CACHE)
    p.add_argument(
        "--cached-only", action="store_true", help="Only check cache, skip fetch"
    )
    a = p.parse_args()

    title, artist, cache_dir = a.title.strip(), a.artist.strip(), a.cache_dir
    if not title:
        print(json.dumps({"syncedLyrics": "", "plainLyrics": "", "error": "missing title"}))
        return

    c_artist = clean_artist(artist)
    c_title = clean_title(title, c_artist)
    key = hashlib.md5(f"{c_title}|{c_artist}".encode()).hexdigest()[:12]
    path = os.path.join(cache_dir, f"{key}.json")
    out = None

    if os.path.isfile(path):
        try:
            with open(path) as f:
                out = json.load(f)
                out["source"] = "cache"
        except (json.JSONDecodeError, OSError):
            pass

    if not out and not a.cached_only:
        try:
            url = f"{LRCLIB}?track_name={quote(c_title)}&artist_name={quote(c_artist)}"
            with urlopen(Request(url, headers={"User-Agent": UA}), timeout=10) as r:
                data = json.loads(r.read().decode())
            if isinstance(data, list) and data:
                d = data[0]
                out = {
                    "syncedLyrics": d.get("syncedLyrics") or "",
                    "plainLyrics": d.get("plainLyrics") or "",
                    "source": "api",
                }
                if out["syncedLyrics"] or out["plainLyrics"]:
                    try:
                        os.makedirs(cache_dir, exist_ok=True)
                        with open(path, "w") as f:
                            json.dump(out, f)
                    except OSError:
                        pass
            else:
                out = {"syncedLyrics": "", "plainLyrics": "", "source": "api"}
        except Exception as e:
            out = {"syncedLyrics": "", "plainLyrics": "", "error": str(e), "source": "api"}

    if not out:
        out = {"syncedLyrics": "", "plainLyrics": "", "source": "miss"}

    print(json.dumps(out))


if __name__ == "__main__":
    main()
