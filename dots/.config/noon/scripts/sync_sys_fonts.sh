#!/bin/bash

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --family) FAMILY="$2"; shift ;;
        --size) SIZE="$2"; shift ;;
    esac
    shift
done

if [[ -z "$FAMILY" || -z "$SIZE" ]]; then
    echo "Usage: $0 --family \"Font Name\" --size X"
    exit 1
fi

gsettings set org.gnome.desktop.interface font-name "${FAMILY} ${SIZE}"
kwriteconfig6 --file kdeglobals --group General --key font "${FAMILY},${SIZE},-1,5,50,0,0,0,0,0"
kwriteconfig6 --file kdeglobals --group General --key fixed "${FAMILY},${SIZE},-1,5,50,0,0,0,0,0"
