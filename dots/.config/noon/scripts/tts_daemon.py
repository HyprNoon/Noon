#!/usr/bin/env python3

import argparse
import json
import queue
import socket
import sys
import threading
from pathlib import Path

SOCKET_PATH = "/tmp/tts.sock"
MODELS_DIR = Path.home() / ".local/share/piper"


def log(status, msg):
    print(f"tts|{status}|{msg}", flush=True)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--config", type=Path, required=True)
    args = parser.parse_args()
    config = json.loads(args.config.read_text())

    import numpy as np
    import sounddevice as sd
    from piper.voice import PiperVoice

    model = MODELS_DIR / f"{config['model']}.onnx"
    if not model.exists():
        log("error", f"model_not_found:{model}")
        sys.exit(1)

    volume = float(config.get("volume", 1.0))
    device = config.get("device", "pipewire")

    log("info", "loading_model")
    voice = PiperVoice.load(model, use_cuda=True)
    log("ok", "ready")

    q = queue.Queue()

    def speaker():
        while True:
            text = q.get()
            if text is None:
                break
            log("info", f"speaking:{text}")
            stream = sd.OutputStream(
                samplerate=voice.config.sample_rate,
                channels=1,
                dtype="int16",
                device=device,
            )
            stream.start()
            for chunk in voice.synthesize(text):
                audio = np.frombuffer(chunk.audio_int16_bytes, dtype=np.int16)
                stream.write((audio * volume).clip(-32768, 32767).astype(np.int16))
            stream.stop()
            stream.close()
            log("ok", "done")
            q.task_done()

    threading.Thread(target=speaker, daemon=True).start()

    server = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    try:
        import os

        os.unlink(SOCKET_PATH)
    except FileNotFoundError:
        pass
    server.bind(SOCKET_PATH)
    server.listen()

    try:
        while True:
            conn, _ = server.accept()
            with conn:
                data = b""
                while chunk := conn.recv(4096):
                    data += chunk
            for line in data.decode().splitlines():
                line = line.strip()
                if line:
                    q.put(line)
    finally:
        server.close()
        os.unlink(SOCKET_PATH)


if __name__ == "__main__":
    main()
