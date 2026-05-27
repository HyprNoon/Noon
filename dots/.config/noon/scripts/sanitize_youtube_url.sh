#!/usr/bin/env bash

URL="$1"

if [ -z "$URL" ]; then
    exit 1
fi

if ! command -v yt-dlp &> /dev/null; then
    exit 1
fi

RAW_STREAM_URL=$(yt-dlp -4 --no-playlist --no-warnings --extract-audio --get-url -f bestaudio "$URL" 2>/dev/null | tr -d '\r\n')

if [ -z "$RAW_STREAM_URL" ]; then
    exit 1
fi

noon ipc call global preview_url "$RAW_STREAM_URL"
