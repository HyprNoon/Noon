#!/usr/bin/env bash
set -euo pipefail

url="$1"
dir="$2"
format="${3}"

yt-dlp \
    --no-playlist \
    -f "$format" \
    -o "$dir/%(title)s.%(ext)s" \
    "$url"
