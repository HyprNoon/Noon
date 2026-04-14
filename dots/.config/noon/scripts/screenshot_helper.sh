#!/usr/bin/env bash
OUT_PATH="$1"
grimblast save area "$OUT_PATH"
[ -f "$OUT_PATH" ] && echo "$OUT_PATH"
