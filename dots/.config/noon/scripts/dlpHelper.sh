#!/usr/bin/env bash
set -euo pipefail

json_file="$HOME/.local/state/noon/downloads.json"
mkdir -p "$(dirname "$json_file")"

upsert_entry() {
    local file_uri="$1"
    local label="$2"
    local url="$3"
    local received="$4"
    local total="$5"
    local state="$6"
    local progress=0
    if [[ "$total" -gt 0 ]]; then
        progress=$(( received * 100 / total ))
    fi
    local new_entry
    new_entry=$(jq -n \
        --arg dest "$file_uri" \
        --arg label "$label" \
        --arg url "$url" \
        --arg state "$state" \
        --argjson received "$received" \
        --argjson total "$total" \
        --argjson progress "$progress" \
        '{
            signature: "yt-dlp",
            destination: $dest,
            headers: { Origin: "", Referer: "" },
            label: $label,
            progress: $progress,
            receivedBytes: $received,
            state: $state,
            totalBytes: $total,
            url: $url
        }')
    local tmp
    tmp="$(mktemp)"
    if [[ -f "$json_file" ]]; then
        jq --arg dest "$file_uri" --argjson entry "$new_entry" '
            if (.downloads | map(.destination) | index($dest)) != null then
                .downloads |= map(if .destination == $dest then $entry else . end)
            else
                .downloads += [$entry]
            end
        ' "$json_file" > "$tmp"
    else
        jq -n --argjson entry "$new_entry" '{ downloads: [$entry] }' > "$tmp"
    fi
    mv "$tmp" "$json_file"
}

run_download() {
    local format="$1"
    local postargs="$2"
    local destination="$3"
    local url="$4"

    local output_file
    output_file="$(yt-dlp \
        --quiet \
        --no-playlist \
        --cookies-from-browser firefox \
        -f "$format" \
        $postargs \
        --print filename \
        --simulate \
        -o "$destination/%(title)s.%(ext)s" \
        "$url" 2>/dev/null)"

    local label file_uri
    label="$(basename "$output_file")"
    file_uri="file://$output_file"

    upsert_entry "$file_uri" "$label" "$url" 0 0 "Running"

    while IFS= read -r line; do
        echo "$line"
        IFS=',' read -r received total speed eta <<< "$line"
        if [[ "$received" =~ ^[0-9]+$ && "$total" =~ ^[0-9]+$ ]]; then
            upsert_entry "$file_uri" "$label" "$url" "$received" "$total" "Running"
        fi
    done < <(yt-dlp \
        --quiet \
        --progress \
        --no-playlist \
        --cookies-from-browser firefox \
        --progress-template "%(progress.downloaded_bytes)s,%(progress.total_bytes)s,%(progress._speed_str)s,%(progress._eta_str)s" \
        --newline \
        -f "$format" \
        $postargs \
        -o "$destination/%(title)s.%(ext)s" \
        "$url" 2>/dev/null)

    local total_bytes
    total_bytes="$(stat -c%s "$output_file" 2>/dev/null || echo 0)"
    upsert_entry "$file_uri" "$label" "$url" "$total_bytes" "$total_bytes" "Finished"
}

cmd="${1:-}"

case "$cmd" in
    --download-song)
        title="$2"
        artist="$3"
        destination="$4"
        query="ytsearch1:${artist} ${title} official audio"
        resolved_url="$(yt-dlp --quiet --no-playlist --print webpage_url "$query" 2>/dev/null | head -n1)"
        run_download "bestaudio/best" "--extract-audio --audio-format mp3 --audio-quality 0" "$destination" "$resolved_url"
        ;;
    *)
        parameters="$1"
        url="$2"
        destination="$3"
        format="${parameters%%|*}"
        postargs="${parameters#*|}"
        [[ "$postargs" == "$parameters" ]] && postargs=""
        run_download "$format" "$postargs" "$destination" "$url"
        ;;
esac
