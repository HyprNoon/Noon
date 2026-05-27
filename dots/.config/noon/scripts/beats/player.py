import os
import sys

import mpd

from .config import get_player_conf


class Player:
    def __init__(self, name: str):
        self.name = name
        self._load_conf()

    def _load_conf(self):
        self.conf = get_player_conf(self.name)
        self.host = self.conf["host"]
        self.port = self.conf["port"]
        self.password = self.conf.get("password", "")

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
        except (mpd.ConnectionError, ConnectionRefusedError, OSError) as e:
            print(f"MPD connection error ({self.name}): {e}", file=sys.stderr)
            return None
        except mpd.CommandError as e:
            print(f"MPD command error ({self.name}): {e}", file=sys.stderr)
            return None

    def is_running(self) -> bool:
        try:
            c = self._connect()
            c.ping()
            c.disconnect()
            return True
        except Exception:
            return False

    def play_pause(self):
        def fn(c):
            state = c.status().get("state")
            c.pause(1 if state == "play" else 0)

        self._run(fn)

    def play_by_name(self, name: str):
        def fn(c):
            playlist = c.playlistinfo()
            name_lower = name.lower()
            for item in playlist:
                if (
                    name_lower in item.get("title", "").lower()
                    or name_lower in item.get("file", "").lower()
                ):
                    c.play(int(item["pos"]))
                    return

            library = []
            for t in c.listall():
                if isinstance(t, dict) and "file" in t:
                    library.append(t["file"])
                elif isinstance(t, str) and t.endswith(
                    (".mp3", ".flac", ".ogg", ".m4a")
                ):
                    library.append(t)

            target = next((f for f in library if name_lower in f.lower()), None)

            if target:
                try:
                    c.save("temp_former_queue")
                except mpd.CommandError:
                    pass
                c.clear()
                c.add(target)
                for path in library:
                    if path != target:
                        c.add(path)
                c.repeat(0)
                c.single(0)
                c.play(0)
                return

            print(f"Track not found: {name}", file=sys.stderr)

        self._run(fn)

    def play_file(self, filepath: str):
        def fn(c):
            c.clear()
            c.add(filepath)
            c.play(0)

        self._run(fn)

    def play_url(self, url: str):
        try:
            import yt_dlp
            with yt_dlp.YoutubeDL({
                "quiet": True, "noplaylist": True, "format": "bestaudio/best",
            }) as ydl:
                url = ydl.extract_info(url, download=False).get("url", url)
        except Exception:
            pass
        def fn(c):
            c.clear()
            c.add(url)
            c.play(0)

        self._run(fn)

    def build_playlist(self, titles: str):
        title_list = [t.strip() for t in titles.split(",") if t.strip()]

        def fn(c):
            try:
                c.save("temp_former_queue")
            except mpd.CommandError:
                pass

            library = c.search("any", "")
            title_map = {}
            for track in library:
                if "file" not in track:
                    continue
                track_title = (
                    track.get("title") or os.path.basename(track["file"])
                ).lower()
                title_map[track_title] = track["file"]

            resolved = []
            for title in title_list:
                match = title_map.get(title.lower())
                if match:
                    resolved.append(match)
                else:
                    print(f"Track not found in library: {title}", file=sys.stderr)

            if not resolved:
                print("No tracks resolved, aborting.", file=sys.stderr)
                return

            c.clear()
            for path in resolved:
                c.add(path)
            c.repeat(0)
            c.single(0)
            c.play(0)

        self._run(fn)

    def next(self):
        self._run(lambda c: c.next())

    def prev(self):
        self._run(lambda c: c.previous())

    def stop(self):
        self._run(lambda c: c.stop())

    def seek(self, seconds: float):
        def fn(c):
            status = c.status()
            songid = status.get("songid")
            if songid:
                current = float(status.get("elapsed", 0))
                c.seekid(int(songid), max(0.0, current + seconds))

        self._run(fn)

    def set_volume(self, volume: int):
        self._run(lambda c: c.setvol(max(0, min(100, volume))))

    def status(self) -> dict:
        def fn(c):
            status = c.status()
            song = c.currentsong()
            return {
                "running": True,
                "player": self.name,
                "state": status.get("state"),
                "title": song.get("title") or song.get("file", ""),
                "artist": song.get("artist", ""),
                "album": song.get("album", ""),
                "file": song.get("file", ""),
                "position": float(status.get("elapsed", 0)),
                "duration": float(status.get("duration", 0)),
                "volume": int(status.get("volume", 0)),
                "repeat": status.get("repeat") == "1",
                "random": status.get("random") == "1",
                "queue_length": int(status.get("playlistlength", 0)),
            }

        result = self._run(fn)
        if result is None:
            return {"running": False, "player": self.name}
        return result

    def get_queue(self) -> list:
        def fn(c):
            status = c.status()
            current_pos = int(status.get("song", -1))
            playlist = c.playlistinfo()
            queue = []
            for item in playlist:
                pos = int(item.get("pos", 0))
                queue.append(
                    {
                        "index": pos,
                        "file": item.get("file", ""),
                        "title": item.get("title") or item.get("file", ""),
                        "artist": item.get("artist", ""),
                        "album": item.get("album", ""),
                        "duration": float(item.get("duration", 0)),
                        "current": pos == current_pos,
                    }
                )
            if current_pos >= 0:
                return queue[current_pos:] + queue[:current_pos]
            return queue

        result = self._run(fn)
        return result if result is not None else []

    def queue_add(self, url_or_path: str):
        self._run(lambda c: c.add(url_or_path))

    def queue_remove(self, index: int):
        self._run(lambda c: c.delete(index))

    def queue_move(self, index: int, new_index: int):
        self._run(lambda c: c.move(index, new_index))

    def queue_clear(self):
        self._run(lambda c: c.clear())

    def refresh_config(self):
        self._load_conf()

    def update_db(self):
        self._run(lambda c: c.update())
