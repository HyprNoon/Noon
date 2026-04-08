#!/usr/bin/env bash
set -euo pipefail

parameters="$1"
url="$2"
destination="$3"

format="${parameters%%|*}"
postargs="${parameters#*|}"
[[ "$postargs" == "$parameters" ]] && postargs=""

json_file="$HOME/.local/state/noon/downloads.json"
mkdir -p "$(dirname "$json_file")"

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

label="$(basename "$output_file")"
file_uri="file://$output_file"

upsert_entry() {
    local received="$1"
    local total="$2"
    local state="$3"
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
            signiture: "yt-dlp",
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

upsert_entry 0 0 "Running"

while IFS= read -r line; do
    echo "$line"
    IFS=',' read -r received total speed eta <<< "$line"
    if [[ "$received" =~ ^[0-9]+$ && "$total" =~ ^[0-9]+$ ]]; then
        upsert_entry "$received" "$total" "Running"
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

total_bytes="$(stat -c%s "$output_file" 2>/dev/null || echo 0)"
upsert_entry "$total_bytes" "$total_bytes" "Finished"
