#!/usr/bin/env bash

PLUGINS_DIR="${1:?Usage: plugins.sh <plugins_dir> <command>}"
CMD="${2:?Commands: list, enable, disable, install, remove}"
TARGET="$3"

list() {
    local first=1
    echo "{"
    for dir in "$PLUGINS_DIR"/*/; do
        local manifest="$dir/manifest.json"
        [[ -f "$manifest" ]] || continue
        local name absdir content
        name=$(jq -r '.name' "$manifest")
        absdir=$(realpath "$dir")
        content=$(sed "s|@plugins|$absdir|g" "$manifest" | jq '. + {isPlugin: true}')
        [[ $first -eq 1 ]] && first=0 || printf ",\n"
        printf "  \"%s\": %s" "$name" "$content"
    done
    printf "\n}\n"
}

enable() {
    local manifest="$PLUGINS_DIR/$TARGET/manifest.json"
    [[ -f "$manifest" ]] || { echo "Plugin '$TARGET' not found"; exit 1; }
    local tmp=$(mktemp)
    jq '.enabled = true' "$manifest" > "$tmp" && mv "$tmp" "$manifest"
    echo "Enabled $TARGET"
}

disable() {
    local manifest="$PLUGINS_DIR/$TARGET/manifest.json"
    [[ -f "$manifest" ]] || { echo "Plugin '$TARGET' not found"; exit 1; }
    local tmp=$(mktemp)
    jq '.enabled = false' "$manifest" > "$tmp" && mv "$tmp" "$manifest"
    echo "Disabled $TARGET"
}

install() {
    # TARGET here is a path to a plugin dir or tarball
    [[ -e "$TARGET" ]] || { echo "Source '$TARGET' not found"; exit 1; }
    local name
    if [[ -d "$TARGET" ]]; then
        [[ -f "$TARGET/manifest.json" ]] || { echo "No manifest.json in '$TARGET'"; exit 1; }
        name=$(jq -r '.name' "$TARGET/manifest.json")
        cp -r "$TARGET" "$PLUGINS_DIR/$name"
    elif [[ "$TARGET" == *.tar.gz ]]; then
        local tmp=$(mktemp -d)
        tar -xzf "$TARGET" -C "$tmp"
        local mf
        mf=$(find "$tmp" -maxdepth 2 -name manifest.json | head -1)
        [[ -f "$mf" ]] || { echo "No manifest.json in archive"; exit 1; }
        name=$(jq -r '.name' "$mf")
        cp -r "$(dirname "$mf")" "$PLUGINS_DIR/$name"
        rm -rf "$tmp"
    else
        echo "Unsupported format. Use a directory or .tar.gz"
        exit 1
    fi
    echo "Installed $name"
}

remove() {
    local dir="$PLUGINS_DIR/$TARGET"
    [[ -d "$dir" ]] || { echo "Plugin '$TARGET' not found"; exit 1; }
    rm -rf "$dir"
    echo "Removed $TARGET"
}

case "$CMD" in
    list)    list ;;
    enable)  enable ;;
    disable) disable ;;
    install) install ;;
    remove)  remove ;;
    *)       echo "Unknown command: $CMD"; exit 1 ;;
esac
