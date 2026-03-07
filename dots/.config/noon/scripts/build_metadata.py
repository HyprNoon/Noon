import base64
import hashlib
import json
import math
import os
import shutil
import sys
import time
from concurrent.futures import ProcessPoolExecutor, as_completed

from mutagen import File
from mutagen.flac import Picture
from mutagen.id3 import APIC, ID3
from mutagen.mp4 import MP4Cover

try:
    import orjson

    def _json_loads(s):
        return orjson.loads(s)

    def _json_dumps(obj, fh):
        fh.write(
            orjson.dumps(
                obj, option=orjson.OPT_INDENT_2 | orjson.OPT_NON_STR_KEYS
            ).decode()
        )

except ImportError:

    def _json_loads(s):
        return json.loads(s)

    def _json_dumps(obj, fh):
        json.dump(obj, fh, indent=2, ensure_ascii=False, default=str)


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
WORKERS = os.cpu_count() or 8


# ---------------------------------------------------------------------------
# Helpers (must be top-level for pickling)
# ---------------------------------------------------------------------------


def get_hash(filepath):
    return hashlib.md5(filepath.encode()).hexdigest()[:12]


def _cover_hash(data):
    return hashlib.md5(data).hexdigest()[:16]


def _write_cover_local(file_key, data, img_ext, coverarts_dir, local_dedup):
    """
    Write cover inside the worker process — no bytes cross the IPC pipe.
    local_dedup: plain dict, per-chunk, handles duplicates within the batch.
    Inter-chunk duplicates are handled by the exists() check (layer 1).
    """
    out_name = f"{file_key}.{img_ext}"
    out_path = os.path.join(coverarts_dir, out_name)

    # Layer 1: already on disk from a previous run or a sibling chunk
    if os.path.exists(out_path):
        return out_path

    # Layer 2: duplicate within this chunk
    img_hash = _cover_hash(data)
    if img_hash in local_dedup:
        existing = local_dedup[img_hash]
        try:
            os.link(existing, out_path)
        except OSError:
            shutil.copy2(existing, out_path)
        return out_path

    with open(out_path, "wb") as f:
        f.write(data)
    local_dedup[img_hash] = out_path
    return out_path


def _extract_cover(audio, filepath, file_key, coverarts_dir, local_dedup):
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
        print(f"  [COVER ERR] {os.path.basename(filepath)}: {e}", flush=True)
        return None

    if not data:
        return None

    return _write_cover_local(file_key, data, img_ext, coverarts_dir, local_dedup)


def _extract_tags(audio, filepath):
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
        else:
            t = audio.tags
            meta["title"] = first(t.get("title"))
            meta["artist"] = first(t.get("artist"))
            meta["album"] = first(t.get("album"))
            meta["year"] = first(t.get("date"))
            meta["track"] = first(t.get("tracknumber"))
            meta["genre"] = first(t.get("genre"))
            meta["comment"] = first(t.get("comment"))
    except Exception as e:
        print(f"  [TAG ERR] {os.path.basename(filepath)}: {e}", flush=True)

    return meta


def process_chunk(args):
    """
    Process an entire batch of files inside a single worker process.
    args: (chunk: list[(filepath, mtime, size)], coverarts_dir)

    Returns a list of (file_key, record) — NO image bytes in the return value.
    Cover files are written to disk directly from the worker.
    IPC traffic = N_CORES roundtrips total, not N_FILES.
    """
    chunk, coverarts_dir = args
    local_dedup = {}  # img_hash -> path, scoped to this chunk
    results = []

    for filepath, mtime, size in chunk:
        filename = os.path.basename(filepath)
        file_key = get_hash(filepath)

        audio = None
        try:
            audio = File(filepath, easy=False)
        except Exception as e:
            print(f"  [READ ERR] {filename}: {e}", flush=True)

        tags = _extract_tags(audio, filepath)
        cover = _extract_cover(audio, filepath, file_key, coverarts_dir, local_dedup)

        duration = None
        if audio and audio.info:
            try:
                duration = round(audio.info.length, 2)
            except Exception:
                pass

        results.append(
            (
                file_key,
                {
                    "hash": file_key,
                    "filename": filename,
                    "filepath": filepath,
                    "size_bytes": size,
                    "mtime": mtime,
                    "duration_seconds": duration,
                    "cover_art": cover,
                    **tags,
                },
            )
        )

    return results


# ---------------------------------------------------------------------------
# Scan / playlist / finalize
# ---------------------------------------------------------------------------


def _scan_music(directory):
    entries = []
    with os.scandir(directory) as it:
        for entry in it:
            if entry.is_file() and os.path.splitext(entry.name)[1].lower() in SUPPORTED:
                entries.append(entry)
    entries.sort(key=lambda e: e.name.lower())
    return entries


def _make_chunks(items, n):
    """Split items into n roughly equal chunks."""
    size = math.ceil(len(items) / n)
    return [items[i : i + size] for i in range(0, len(items), size)]


def write_m3u(hashmap, directory, m3u_path):
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
    return [entry["hash"] for entry in ordered]


def _finalize(hashmap, directory, meta_path):
    m3u_path = os.path.join(directory, ".playlist.m3u")
    ordered_keys = write_m3u(hashmap, directory, m3u_path)
    for idx, key in enumerate(ordered_keys):
        if key in hashmap:
            hashmap[key]["playlist_index"] = idx
    with open(meta_path, "w", encoding="utf-8") as f:
        _json_dumps(hashmap, f)
    print(f"  Playlist                          →  {m3u_path}")


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------


def build_metadata(directory, force=False):
    directory = os.path.abspath(directory)

    if not os.path.isdir(directory):
        print(f"Error: '{directory}' is not a valid directory.")
        sys.exit(1)

    coverarts_dir = os.path.join(directory, ".coverarts")
    os.makedirs(coverarts_dir, exist_ok=True)

    meta_path = os.path.join(directory, ".metadata")
    existing = {}
    if os.path.exists(meta_path):
        try:
            with open(meta_path, "r", encoding="utf-8") as f:
                existing = _json_loads(f.read())
        except Exception:
            pass

    existing_by_path = {
        v["filepath"]: (k, v)
        for k, v in existing.items()
        if "filepath" in v and "mtime" in v
    }

    music_entries = _scan_music(directory)
    if not music_entries:
        print("No supported audio files found.")
        return

    to_process = []
    hashmap = {}

    for entry in music_entries:
        filepath = entry.path
        stat = entry.stat()
        mtime = stat.st_mtime

        if not force and filepath in existing_by_path:
            key, cached = existing_by_path[filepath]
            if cached["mtime"] == mtime:
                hashmap[key] = cached
                continue

        to_process.append((filepath, stat.st_mtime, stat.st_size))

    skipped = len(music_entries) - len(to_process)
    print(f"  Total:   {len(music_entries)} files")
    print(f"  Cached:  {skipped} unchanged (skipped)")
    print(f"  Pending: {len(to_process)} to process")
    print(f"  Workers: {WORKERS} processes\n")

    if not to_process:
        print("  Nothing changed — .metadata is already up to date.")
        _finalize(hashmap, directory, meta_path)
        return

    # Split into per-worker chunks — N_CORES IPC roundtrips instead of N_FILES
    chunks = _make_chunks(to_process, WORKERS)
    chunk_args = [(chunk, coverarts_dir) for chunk in chunks]

    t0 = time.perf_counter()

    with ProcessPoolExecutor(max_workers=WORKERS) as pool:
        futures = {
            pool.submit(process_chunk, args): i for i, args in enumerate(chunk_args)
        }
        done = 0
        for future in as_completed(futures):
            try:
                for key, record in future.result():
                    hashmap[key] = record
                    done += 1
                    print(
                        f"  [{done}/{len(to_process)}] {record['filename']}", flush=True
                    )
            except Exception as e:
                print(f"  [CHUNK ERR] {e}", flush=True)

    elapsed = time.perf_counter() - t0
    _finalize(hashmap, directory, meta_path)

    rate = len(to_process) / elapsed if elapsed > 0 else float("inf")
    print(f"\n  Done in {elapsed:.2f}s  ({rate:.0f} files/sec)")
    print(f"  Wrote {len(hashmap)} total entries  →  {meta_path}")
    print(f"  Cover arts                        →  {coverarts_dir}")


if __name__ == "__main__":
    args = [a for a in sys.argv[1:] if not a.startswith("-")]
    force = "-f" in sys.argv[1:]

    if len(args) != 1:
        print("Usage: python build_metadata.py [-f] <directory>")
        sys.exit(1)

    build_metadata(args[0], force=force)
