import asyncio
import os


class UnixWebSocketBridge:
    def __init__(self, socket_path: str):
        self._socket_path = os.path.expanduser(socket_path)

    async def bridge(self, websocket) -> None:
        reader, writer = await asyncio.open_unix_connection(self._socket_path)
        done = asyncio.Event()

        async def ws_to_unix():
            try:
                while True:
                    msg = await websocket.recv()
                    if isinstance(msg, str):
                        writer.write(msg.encode())
                        await writer.drain()
                    elif isinstance(msg, bytes):
                        writer.write(msg)
                        await writer.drain()
            except Exception:
                pass
            finally:
                done.set()

        async def unix_to_ws():
            try:
                while True:
                    data = await reader.readline()
                    if not data:
                        break
                    await websocket.send(data.decode().rstrip())
            except Exception:
                pass
            finally:
                done.set()

        try:
            await asyncio.gather(ws_to_unix(), unix_to_ws(), return_exceptions=True)
            await done.wait()
        finally:
            try:
                writer.close()
                await writer.wait_closed()
            except Exception:
                pass
            try:
                await websocket.close()
            except Exception:
                pass
