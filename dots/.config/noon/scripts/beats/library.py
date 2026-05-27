import base64
import hashlib
import json
import math
import os
import sys
from concurrent.futures import ProcessPoolExecutor, as_completed

import mpd

from .config import get_player_conf

WORKERS = os.cpu_count() or 4
TEMP_FILE = os.path.expanduser("~/.local/state/noon/user/generated/beats_library.json")


def _process_chunk(args: tuple) -> list:
    """
    Runs in a worker process.
    Returns list of (rel_path, rel_cover_path).
    Writes cover files directly to disk.
    """
    chunk, music_dir, covers_dir = args

    from mutagen import File
    from mutagen.flac import Picture
    from mutagen.id3 import APIC, ID3
    from mutagen.mp4 import MP4Cover

    local_dedup = {}
    results = []

    for rel_path in chunk:
        abs_path = os.path.join(music_dir, rel_path)
        if not os.path.exists(abs_path):
            continue

        ext = os.path.splitext(abs_path)[1].lower()
        file_key = hashlib.md5(rel_path.encode()).hexdigest()[:12]
        data, img_ext = None, "jpg"

        try:
            audio = File(abs_path, easy=False)
            if audio is None:
                continue

            if ext == ".mp3":
                tags = ID3(abs_path)
                for tag in tags.values():
                    if isinstance(tag, APIC):
                        data = tag.data
                        img_ext = "png" if tag.mime == "image/png" else "jpg"
                        break
            elif ext == ".m4a":
                if audio.tags:
                    covers = audio.tags.get("covr", [])
                    if covers:
                        data = bytes(covers[0])
                        img_ext = (
                            "png"
                            if covers[0].imageformat == MP4Cover.FORMAT_PNG
                            else "jpg"
                        )
            elif ext == ".flac":
                if audio.pictures:
                    pic = audio.pictures[0]
                    data = pic.data
                    img_ext = "png" if pic.mime == "image/png" else "jpg"
            elif ext in (".ogg", ".opus"):
                if audio.get("metadata_block_picture"):
                    raw = base64.b64decode(audio["metadata_block_picture"][0])
                    pic = Picture(raw)
                    data = pic.data
                    img_ext = "png" if pic.mime == "image/png" else "jpg"
        except Exception as e:
            print(f"  [COVER ERR] {rel_path}: {e}", file=sys.stderr, flush=True)
            continue

        if not data:
            continue

        out_name = f"{file_key}.{img_ext}"
        out_path = os.path.join(covers_dir, out_name)

        if not os.path.exists(out_path):
            img_hash = hashlib.md5(data).hexdigest()[:16]
            if img_hash in local_dedup:
                import shutil

                try:
                    os.link(local_dedup[img_hash], out_path)
                except OSError:
                    shutil.copy2(local_dedup[img_hash], out_path)
            else:
                with open(out_path, "wb") as f:
                    f.write(data)
                local_dedup[img_hash] = out_path

        rel_cover = os.path.relpath(out_path, music_dir)
        results.append((rel_path, rel_cover))

    return results


def _make_chunks(items: list, n: int) -> list:
    size = math.ceil(len(items) / n) if items else 1
    return [items[i : i + size] for i in range(0, len(items), size)]


class LibraryManager:
    def __init__(self, player_name: str = "main"):
        conf = get_player_conf(player_name)
        self.host = conf["host"]
        self.port = conf["port"]
        self.password = conf.get("password", "")
        self.music_dir = self._get_music_dir()
        self.covers_dir = os.path.join(self.music_dir, ".coverarts")

    def _connect(self) -> mpd.MPDClient:
        c = mpd.MPDClient()
        c.connect(self.host, self.port)
        if self.password:
            c.password(self.password)
        return c

    def _run(self, fn):
        try:
            c = self._connect()
            result = fn(c)
            c.disconnect()
            return result
        except Exception as e:
            print(f"MPD error: {e}", file=sys.stderr)
            return None

    def _get_music_dir(self) -> str:
        try:
            c = self._connect()
            result = c.config()
            c.disconnect()
            return os.path.expanduser(result.get("music_directory", "~/Music"))
        except Exception:
            return os.path.expanduser("~/Music")

    def _cover_map_path(self) -> str:
        return os.path.join(self.music_dir, ".covermap.json")

    def _load_cover_map(self) -> dict:
        path = self._cover_map_path()
        if os.path.exists(path):
            try:
                with open(path) as f:
                    return json.load(f)
            except Exception:
                pass
        return {}

    def _save_cover_map(self, cover_map: dict):
        with open(self._cover_map_path(), "w") as f:
            json.dump(cover_map, f, indent=2, ensure_ascii=False)

    def build_covers(self):
        os.makedirs(self.covers_dir, exist_ok=True)
        cover_map = self._load_cover_map()

        tracks = self._run(lambda c: c.listallinfo()) or []
        pending = [
            t["file"] for t in tracks if t.get("file") and t["file"] not in cover_map
        ]

        total = len(tracks)
        cached = total - len(pending)
        print(f"  Total:   {total}")
        print(f"  Cached:  {cached}")
        print(f"  Pending: {len(pending)}")
        print(f"  Workers: {WORKERS}\n")

        if not pending:
            print("  Nothing to do.")
            return cover_map

        chunks = _make_chunks(pending, WORKERS)
        chunk_args = [(chunk, self.music_dir, self.covers_dir) for chunk in chunks]

        done = 0
        with ProcessPoolExecutor(max_workers=WORKERS) as pool:
            futures = {
                pool.submit(_process_chunk, arg): i for i, arg in enumerate(chunk_args)
            }
            for future in as_completed(futures):
                try:
                    for rel_path, rel_cover in future.result():
                        cover_map[rel_path] = rel_cover
                        done += 1
                        print(f"  [{done}/{len(pending)}] {rel_path}", flush=True)
                except Exception as e:
                    print(f"  [CHUNK ERR] {e}", file=sys.stderr)

        self._save_cover_map(cover_map)
        print(f"\nDone. {done} new covers extracted.")
        return cover_map

    def get_library(self) -> list:
        cover_map = self._load_cover_map()
        tracks = self._run(lambda c: c.listallinfo()) or []
        result = []
        for track in tracks:
            if "file" not in track:
                continue
            rel = track["file"]
            result.append(
                {
                    "file": rel,
                    "title": track.get("title") or os.path.basename(rel),
                    "artist": track.get("artist", ""),
                    "album": track.get("album", ""),
                    "genre": track.get("genre", ""),
                    "date": track.get("date", ""),
                    "duration": float(track.get("duration", 0)),
                    "cover": cover_map.get(rel, ""),
                }
            )
        with open(TEMP_FILE, "w", encoding="utf-8") as f:
            json.dump(result, f, ensure_ascii=False, indent=2)
        return result

    def list_artists(self) -> list:
        result = self._run(lambda c: c.list("artist")) or []
        return sorted(set(r.get("artist", "") for r in result if r.get("artist")))

    def list_albums(self) -> list:
        result = self._run(lambda c: c.list("album")) or []
        return sorted(set(r.get("album", "") for r in result if r.get("album")))

    def list_genres(self) -> list:
        result = self._run(lambda c: c.list("genre")) or []
        return sorted(set(r.get("genre", "") for r in result if r.get("genre")))

    def update_db(self):
        self._run(lambda c: c.update())
