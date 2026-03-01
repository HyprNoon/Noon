import base64
import hashlib
import json
import os
import sys
import threading
import time
from concurrent.futures import ThreadPoolExecutor, as_completed

from mutagen import File
from mutagen.flac import Picture
from mutagen.id3 import APIC, ID3, ID3NoHeaderError
from mutagen.mp4 import MP4Cover

SUPPORTED = {
    ".mp3",
    ".m4a",
    ".flac",
    ".ogg",
    ".opus",
    ".wav",
    ".wma",
    ".aiff",
    ".ape",
    ".wv",
}
WORKERS = min(16, (os.cpu_count() or 4) * 2)  # I/O-bound: more threads than cores

# Thread-safe print
_print_lock = threading.Lock()


def tprint(msg):
    with _print_lock:
        print(msg)


def get_hash(filepath):
    return hashlib.md5(filepath.encode()).hexdigest()[:12]


def extract_cover(audio, filepath, coverarts_dir, file_key):
    ext = os.path.splitext(filepath)[1].lower()
    data, img_ext = None, "jpg"

    try:
        if ext == ".mp3":
            tags = ID3(filepath)
            for tag in tags.values():
                if isinstance(tag, APIC):
                    data = tag.data
                    img_ext = "png" if tag.mime == "image/png" else "jpg"
                    break

        elif ext == ".m4a":
            if audio and audio.tags:
                covers = audio.tags.get("covr", [])
                if covers:
                    data = bytes(covers[0])
                    img_ext = (
                        "png" if covers[0].imageformat == MP4Cover.FORMAT_PNG else "jpg"
                    )

        elif ext == ".flac":
            if audio and audio.pictures:
                pic = audio.pictures[0]
                data, img_ext = pic.data, ("png" if pic.mime == "image/png" else "jpg")

        elif ext in (".ogg", ".opus"):
            if audio and audio.get("metadata_block_picture"):
                raw = base64.b64decode(audio["metadata_block_picture"][0])
                pic = Picture(raw)
                data, img_ext = pic.data, ("png" if pic.mime == "image/png" else "jpg")

    except Exception as e:
        tprint(f"  [COVER ERR] {os.path.basename(filepath)}: {e}")
        return None

    if data:
        out_name = f"{file_key}.{img_ext}"
        out_path = os.path.join(coverarts_dir, out_name)
        with open(out_path, "wb") as f:
            f.write(data)
        return os.path.join(coverarts_dir, out_name)

    return None


def extract_tags(audio, filepath):
    ext = os.path.splitext(filepath)[1].lower()
    meta = {}
    if audio is None or audio.tags is None:
        return meta

    def first(values):
        return str(values[0]) if values else None

    try:
        if ext == ".mp3":
            t = audio.tags
            meta["title"] = str(t["TIT2"]) if "TIT2" in t else None
            meta["artist"] = str(t["TPE1"]) if "TPE1" in t else None
            meta["album"] = str(t["TALB"]) if "TALB" in t else None
            meta["year"] = str(t["TDRC"]) if "TDRC" in t else None
            meta["track"] = str(t["TRCK"]) if "TRCK" in t else None
            meta["genre"] = str(t["TCON"]) if "TCON" in t else None
            meta["comment"] = str(t["COMM::eng"]) if "COMM::eng" in t else None

        elif ext == ".m4a":
            t = audio.tags
            meta["title"] = first(t.get("\xa9nam"))
            meta["artist"] = first(t.get("\xa9ART"))
            meta["album"] = first(t.get("\xa9alb"))
            meta["year"] = first(t.get("\xa9day"))
            meta["track"] = (
                str(t.get("trkn", [[None]])[0][0]) if t.get("trkn") else None
            )
            meta["genre"] = first(t.get("\xa9gen"))
            meta["comment"] = first(t.get("\xa9cmt"))

        else:  # FLAC, OGG, Opus, WAV, WMA, AIFF, APE, WV
            t = audio.tags
            meta["title"] = first(t.get("title"))
            meta["artist"] = first(t.get("artist"))
            meta["album"] = first(t.get("album"))
            meta["year"] = first(t.get("date"))
            meta["track"] = first(t.get("tracknumber"))
            meta["genre"] = first(t.get("genre"))
            meta["comment"] = first(t.get("comment"))

    except Exception as e:
        tprint(f"  [TAG ERR] {os.path.basename(filepath)}: {e}")

    return meta


def process_file(filename, directory, coverarts_dir):
    filepath = os.path.join(directory, filename)
    file_key = get_hash(filepath)
    mtime = os.path.getmtime(filepath)
    size = os.path.getsize(filepath)

    audio = None
    try:
        audio = File(filepath, easy=False)
    except Exception as e:
        tprint(f"  [READ ERR] {filename}: {e}")

    tags = extract_tags(audio, filepath)
    cover = extract_cover(audio, filepath, coverarts_dir, file_key)
    duration = None
    if audio and audio.info:
        try:
            duration = round(audio.info.length, 2)
        except Exception:
            pass

    return file_key, {
        "hash": file_key,
        "filename": filename,
        "filepath": filepath,
        "size_bytes": size,
        "mtime": mtime,
        "duration_seconds": duration,
        "cover_art": cover,
        **tags,
    }


def write_m3u(hashmap, directory, m3u_path):
    """
    Write an #EXTM3U playlist sorted alphabetically by filename.
    Each entry gets:
        #EXTINF:<duration>,<artist> - <title>
        <absolute filepath>

    Returns an ordered list of hash keys matching the playlist order,
    so callers can stamp playlist_index onto each entry.
    """
    # Sort entries by filename (case-insensitive) — same order as music_files
    ordered = sorted(hashmap.values(), key=lambda e: e["filename"].lower())

    lines = ["#EXTM3U", ""]
    for entry in ordered:
        duration = int(entry.get("duration_seconds") or -1)
        artist = entry.get("artist") or "Unknown Artist"
        title = entry.get("title") or os.path.splitext(entry["filename"])[0]
        lines.append(f"#EXTINF:{duration},{artist} - {title}")
        lines.append(entry["filepath"])
        lines.append("")

    with open(m3u_path, "w", encoding="utf-8") as f:
        f.write("\n".join(lines))

    # Return hash keys in playlist order so we can assign playlist_index
    return [entry["hash"] for entry in ordered]


def build_metadata(directory, force=False):
    directory = os.path.abspath(directory)

    if not os.path.isdir(directory):
        print(f"Error: '{directory}' is not a valid directory.")
        sys.exit(1)

    coverarts_dir = os.path.join(directory, ".coverarts")
    os.makedirs(coverarts_dir, exist_ok=True)

    # Load existing metadata for incremental diffing
    meta_path = os.path.join(directory, ".metadata")
    existing = {}
    if os.path.exists(meta_path):
        try:
            with open(meta_path, "r", encoding="utf-8") as f:
                existing = json.load(f)
        except Exception:
            pass

    # Build mtime index from existing data: filepath -> (key, entry)
    existing_by_path = {
        v["filepath"]: (k, v)
        for k, v in existing.items()
        if "filepath" in v and "mtime" in v
    }

    music_files = sorted(
        f for f in os.listdir(directory) if os.path.splitext(f)[1].lower() in SUPPORTED
    )

    if not music_files:
        print("No supported audio files found.")
        return

    # Partition: unchanged (cached) vs needs processing
    to_process = []
    hashmap = {}

    for filename in music_files:
        filepath = os.path.join(directory, filename)
        mtime = os.path.getmtime(filepath)

        if not force and filepath in existing_by_path:
            key, entry = existing_by_path[filepath]
            if entry["mtime"] == mtime:
                hashmap[key] = entry
                continue

        to_process.append(filename)

    skipped = len(music_files) - len(to_process)
    print(f"  Total:   {len(music_files)} files")
    print(f"  Cached:  {skipped} unchanged (skipped)")
    print(f"  Pending: {len(to_process)} to process")
    print(f"  Workers: {WORKERS} threads\n")

    if not to_process:
        print("  Nothing changed — .metadata is already up to date.")
        # Re-generate the playlist anyway so it stays in sync with current files
        _finalize(hashmap, directory, meta_path)
        return

    t0 = time.perf_counter()

    with ThreadPoolExecutor(max_workers=WORKERS) as pool:
        futures = {
            pool.submit(process_file, fn, directory, coverarts_dir): fn
            for fn in to_process
        }
        done = 0
        for future in as_completed(futures):
            filename = futures[future]
            try:
                key, entry = future.result()
                hashmap[key] = entry
                done += 1
                tprint(f"  [{done}/{len(to_process)}] {filename}")
            except Exception as e:
                tprint(f"  [ERR] {filename}: {e}")

    elapsed = time.perf_counter() - t0

    _finalize(hashmap, directory, meta_path)

    rate = len(to_process) / elapsed if elapsed > 0 else float("inf")
    print(f"\n  Done in {elapsed:.2f}s  ({rate:.0f} files/sec)")
    print(f"  Wrote {len(hashmap)} total entries  →  {meta_path}")
    print(
        f"  Cover arts                        →  {os.path.join(directory, '.coverarts')}"
    )


def _finalize(hashmap, directory, meta_path):
    """Write .m3u playlist, stamp playlist_index onto every entry, save .metadata."""
    m3u_path = os.path.join(directory, ".playlist.m3u")

    ordered_keys = write_m3u(hashmap, directory, m3u_path)

    # Stamp playlist_index (0-based) onto each entry
    for idx, key in enumerate(ordered_keys):
        if key in hashmap:
            hashmap[key]["playlist_index"] = idx

    with open(meta_path, "w", encoding="utf-8") as f:
        json.dump(hashmap, f, indent=2, ensure_ascii=False, default=str)

    print(f"  Playlist                          →  {m3u_path}")


if __name__ == "__main__":
    args = [a for a in sys.argv[1:] if not a.startswith("-")]
    force = "-f" in sys.argv[1:]

    if len(args) != 1:
        print("Usage: python build_metadata.py [-f] <directory>")
        sys.exit(1)

    build_metadata(args[0], force=force)
