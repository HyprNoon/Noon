#!/usr/bin/env bash

PLUGINS_DIR="$HOME/.noon_plugins"

CMD="${1:?Usage: $(basename "$0") <command> [group] [target] [-f] [-g group]}"
GROUP="$2"
TARGET="$3"
FORCE=0
GROUP_OVERRIDE=""

for ((i=2; i<=$#; i++)); do
    case "${!i}" in
        -f) FORCE=1 ;;
        -g) next=$((i+1)); GROUP_OVERRIDE="${!next}"; ((i++)) ;;
    esac
done

[[ "$CMD" == "install" ]] && TARGET="$2"

_find_plugin_dir() {
    for dir in "$PLUGINS_DIR/$GROUP"/*/; do
        local manifest="$dir/manifest.json"
        [[ -f "$manifest" ]] || continue
        local name
        name=$(jq -r '.name' "$manifest")
        [[ "$name" == "$TARGET" ]] && { echo "$dir"; return; }
    done
    local direct="$PLUGINS_DIR/$GROUP/$TARGET"
    [[ -d "$direct" ]] && echo "$direct"
}

list() {
    local first=1
    echo "{"
    for dir in "$PLUGINS_DIR/$GROUP"/*/; do
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

_write_qmldir() {
    local dir="$1"
    local module="$2"
    local out="$dir/qmldir"
    [[ -f "$out" && "$FORCE" -eq 0 ]] && return

    {
        printf 'module %s\n' "$module"
        while IFS= read -r qml; do
            local component basename_qml is_singleton
            basename_qml=$(basename "$qml")
            component=$(basename "$qml" .qml)
            is_singleton=$(echo "$singletons_json" | jq -r --arg f "$basename_qml" 'if . | contains([$f]) then "1" else "0" end')
            if [[ "$is_singleton" == "1" ]]; then
                printf 'singleton %s %s %s\n' "$component" "$version" "$basename_qml"
            else
                printf '%s %s %s\n' "$component" "$version" "$basename_qml"
            fi
        done < <(find "$dir" -maxdepth 1 -name "*.qml" | sort)
    } > "$out"

    echo "  Created qmldir for module $module"
}

_ensure_qml_setup() {
    local plugin_dir="$1"
    local manifest="$plugin_dir/manifest.json"

    [[ -f "$manifest" ]] || { echo "  [qml] no manifest at $manifest"; return; }

    local name version singletons_json
    name=$(jq -r '.name' "$manifest")
    version=$(jq -r '.version // "1.0"' "$manifest")
    singletons_json=$(jq -r '[.singletons // [] | .[] ] | @json' "$manifest")

    if [[ ! -f "$plugin_dir/qmldir" || "$FORCE" -eq 1 ]]; then
        _write_qmldir "$plugin_dir" "$name"

        while IFS= read -r subdir; do
            local rel_sub sub_module
            rel_sub="${subdir#$plugin_dir/}"
            sub_module="$name.$(echo "$rel_sub" | tr '/' '.')"
            _write_qmldir "$subdir" "$sub_module"
        done < <(find "$plugin_dir" -mindepth 1 -type d | sort)
    fi
}

enable() {
    local plugin_dir
    plugin_dir=$(_find_plugin_dir)
    [[ -n "$plugin_dir" && -d "$plugin_dir" ]] || { echo "Plugin '$GROUP/$TARGET' not found"; exit 1; }
    local manifest="$plugin_dir/manifest.json"
    local tmp
    tmp=$(mktemp)
    jq '.enabled = true' "$manifest" > "$tmp" && mv "$tmp" "$manifest"
    _ensure_qml_setup "$plugin_dir"
    echo "Enabled $(jq -r '.name' "$manifest")"
}

disable() {
    local plugin_dir
    plugin_dir=$(_find_plugin_dir)
    [[ -n "$plugin_dir" && -d "$plugin_dir" ]] || { echo "Plugin '$GROUP/$TARGET' not found"; exit 1; }
    local manifest="$plugin_dir/manifest.json"
    local tmp
    tmp=$(mktemp)
    jq '.enabled = false' "$manifest" > "$tmp" && mv "$tmp" "$manifest"
    echo "Disabled $(jq -r '.name' "$manifest")"
}

install() {
    TARGET="${TARGET/#\~/$HOME}"
    [[ -e "$TARGET" ]] || { echo "Source '$TARGET' not found"; exit 1; }

    local name group tmp mf manifest_file
    case "$TARGET" in
        *.tar.gz|*.tar|*.zip)
            tmp=$(mktemp -d)
            if [[ "$TARGET" == *.zip ]]; then
                unzip -q "$TARGET" -d "$tmp"
            else
                tar -xf "$TARGET" -C "$tmp"
            fi
            mf=$(find "$tmp" -maxdepth 2 -name manifest.json | head -1)
            [[ -f "$mf" ]] || { rm -rf "$tmp"; echo "No manifest.json in archive"; exit 1; }
            name=$(jq -r '.name' "$mf")
            group=$(jq -r '.pluginGroup // empty' "$mf")
            [[ -n "$GROUP_OVERRIDE" ]] && group="$GROUP_OVERRIDE"
            [[ -n "$group" ]] || { rm -rf "$tmp"; echo "No pluginGroup in manifest, use -g to specify"; exit 1; }
            cp -r "$(dirname "$mf")" "$PLUGINS_DIR/$group/$name"
            rm -rf "$tmp"
            ;;
        *)
            if [[ -d "$TARGET" ]]; then
                manifest_file="$TARGET/manifest.json"
                [[ -f "$manifest_file" ]] || { echo "No manifest.json in '$TARGET'"; exit 1; }
                name=$(jq -r '.name' "$manifest_file")
                group=$(jq -r '.pluginGroup // empty' "$manifest_file")
                [[ -n "$GROUP_OVERRIDE" ]] && group="$GROUP_OVERRIDE"
                [[ -n "$group" ]] || { echo "No pluginGroup in manifest, use -g to specify"; exit 1; }
                cp -r "$TARGET" "$PLUGINS_DIR/$group/$name"
            else
                echo "Unsupported format. Use a directory, .tar, .tar.gz, or .zip"
                exit 1
            fi
            ;;
    esac

    _ensure_qml_setup "$PLUGINS_DIR/$group/$name"
    echo "Installed $group/$name"
}

remove() {
    [[ -n "$TARGET" ]] || { echo "Usage: $(basename "$0") remove <group> <name>"; exit 1; }
    local plugin_dir
    plugin_dir=$(_find_plugin_dir)
    [[ -d "$plugin_dir" ]] || { echo "Plugin '$GROUP/$TARGET' not found"; exit 1; }
    rm -rf "$plugin_dir"
    echo "Removed $GROUP/$TARGET"
}

case "$CMD" in
    list)    list ;;
    enable)  enable ;;
    disable) disable ;;
    install) install ;;
    remove)  remove ;;
    *)       echo "Unknown command: $CMD"; exit 1 ;;
esac
