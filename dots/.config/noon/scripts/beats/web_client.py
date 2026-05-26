import asyncio
import json
import mimetypes
import os
import urllib.parse
import urllib.request

from websockets import Request, Response
from websockets.datastructures import Headers

from .bridge import UnixWebSocketBridge

HERE = os.path.dirname(os.path.abspath(__file__))
STATIC_DIR = os.path.join(HERE, "page")

COVER_MAX_SIZE = 320
COVER_CACHE_DAYS = 30
_STATIC_CACHE = f"public, max-age={COVER_CACHE_DAYS * 86400}"


def _load_cover(path: str) -> tuple[bytes, str]:
    mime, _ = mimetypes.guess_type(path)
    with open(path, "rb") as f:
        return f.read(), mime or "image/jpeg"


def _resp(code: int, body: str | bytes, mime: str = "text/plain",
          cache: str = "") -> Response:
    if isinstance(body, str):
        body = body.encode()
    h = Headers({"Content-Type": mime, "Access-Control-Allow-Origin": "*"})
    if cache:
        h["Cache-Control"] = cache
    reason = {200: "OK", 400: "Bad Request", 403: "Forbidden", 404: "Not Found"}.get(
        code, "Error"
    )
    return Response(code, reason, h, body)


class BeatsWebServer:
    def __init__(self, player: str = "main", port: int = 8090,
                 host: str = "0.0.0.0"):
        self.player = player
        self.port = port
        self.host = host

    def _static(self, path: str) -> Response | None:
        path = path.split("?", 1)[0]
        if path == "/":
            path = "/index.html"
        filepath = os.path.normpath(os.path.join(STATIC_DIR, path.lstrip("/")))
        if not filepath.startswith(STATIC_DIR):
            return _resp(403, "Forbidden")
        if not os.path.isfile(filepath):
            return None
        mime, _ = mimetypes.guess_type(filepath)
        cache = "" if mime == "text/html" else _STATIC_CACHE
        with open(filepath, "rb") as f:
            return _resp(200, f.read(), mime or "application/octet-stream", cache)

    def _api(self, path: str) -> Response | None:
        if path == "/api/config":
            from .config import load_conf
            return _resp(200, json.dumps(load_conf()), "application/json")

        if path == "/api/players":
            from .config import load_conf
            from .player import Player
            conf = load_conf()
            players = conf.get("players", {})
            result = {}
            for name in players:
                host = players[name].get("host", "")
                if host and os.path.exists(os.path.expanduser(host)):
                    p = Player(name)
                    s = p.status()
                    running = s.get("running", False)
                else:
                    running = False
                result[name] = {
                    "name": name,
                    "running": running,
                    "hasPassword": bool(players[name].get("password", "")),
                }
            return _resp(200, json.dumps(result), "application/json")

        if path == "/api/library":
            from .library import LibraryManager
            lib = LibraryManager(self.player)
            return _resp(200, json.dumps(lib.get_library()), "application/json")

        if path == "/api/queue":
            from .player import Player
            return _resp(200, json.dumps(Player(self.player).get_queue()),
                         "application/json")

        if path.startswith("/api/play-by-name/"):
            name = urllib.parse.unquote(path.removeprefix("/api/play-by-name/"))
            if not name:
                return _resp(400, "Bad Request")
            from .player import Player
            Player(self.player).play_by_name(name)
            return _resp(200, "OK", "application/json")

        if path == "/api/lyrics" or path.startswith("/api/lyrics?"):
            parsed = urllib.parse.urlparse(path)
            qs = urllib.parse.parse_qs(parsed.query)
            title = qs.get("title", [""])[0]
            artist = qs.get("artist", [""])[0]
            if not title:
                return _resp(400, '{"error": "missing title"}', "application/json")

            async def fetch_lyrics():
                script = os.path.join(HERE, "..", "lyrics_service.py")
                loop = asyncio.get_event_loop()
                try:
                    proc = await asyncio.create_subprocess_exec(
                        "python3", script, "--title", title, "--artist", artist,
                        stdout=asyncio.subprocess.PIPE, stderr=asyncio.subprocess.PIPE,
                    )
                    out, _ = await asyncio.wait_for(proc.communicate(), timeout=15)
                    data = json.loads(out.decode())
                    if "error" in data:
                        return _resp(404, json.dumps(data), "application/json")
                    return _resp(200, json.dumps(data), "application/json")
                except Exception as e:
                    return _resp(500, json.dumps({"error": str(e)}), "application/json")

            return fetch_lyrics()

        if path.startswith("/api/covers/"):
            rel = urllib.parse.unquote(path.removeprefix("/api/covers/"))
            if not rel:
                return _resp(400, "Bad Request")
            from .library import LibraryManager
            lib = LibraryManager(self.player)
            music_dir = lib.music_dir
            cover_map = lib._load_cover_map()

            cover_rel = cover_map.get(rel)
            if not cover_rel:
                dir_path = os.path.dirname(os.path.join(music_dir, rel))
                for name in ("cover.jpg", "cover.png", "folder.jpg", "folder.png",
                             "AlbumArt.jpg", "AlbumArt.png", "front.jpg", "front.png"):
                    candidate = os.path.join(dir_path, name)
                    if os.path.isfile(candidate):
                        cover_rel = os.path.relpath(candidate, music_dir)
                        break

            if not cover_rel:
                full_candidate = os.path.normpath(os.path.join(music_dir, rel))
                if full_candidate.startswith(os.path.normpath(music_dir)) and os.path.isfile(full_candidate):
                    cover_rel = rel

            if not cover_rel:
                return _resp(404, "Not Found")
            full = os.path.normpath(os.path.join(music_dir, cover_rel))
            if not full.startswith(os.path.normpath(music_dir)):
                return _resp(403, "Forbidden")
            if not os.path.isfile(full):
                return _resp(404, "Not Found")
            data, mime = _load_cover(full)
            return _resp(200, data, mime, _STATIC_CACHE)

        return None

    def _on_http(self, conn, req: Request) -> Response | None:
        path = req.path
        if req.headers.get("Upgrade", "").lower() == "websocket":
            return None
        if path.startswith("/api/"):
            resp = self._api(path)
            return resp if resp else _resp(404, "Not Found")
        resp = self._static(path)
        if resp is not None:
            return resp
        return _resp(404, "Not Found")

    async def _on_ws(self, websocket):
        player = websocket.request.path.strip("/") or self.player
        from .config import load_conf
        conf = load_conf()
        players = conf.get("players", {})
        if player not in players:
            await websocket.close(4004, f"unknown player: {player}")
            return
        pconf = players[player]
        bridge = UnixWebSocketBridge(pconf["host"])
        await bridge.bridge(websocket)

    async def start(self):
        print(f"  beats [{self.player}] → http://{self.host}:{self.port}")
        from websockets.asyncio.server import serve
        async with serve(self._on_ws, self.host, self.port,
                         process_request=self._on_http) as srv:
            await srv.serve_forever()


def main():
    import sys
    player = sys.argv[1] if len(sys.argv) > 1 else "main"
    port = int(sys.argv[2]) if len(sys.argv) > 2 else 8090
    host = sys.argv[3] if len(sys.argv) > 3 else "127.0.0.1"
    asyncio.run(BeatsWebServer(player, port, host).start())


if __name__ == "__main__":
    main()
