#!/usr/bin/env python3
import argparse
import csv
import json
import os
import socket
import sys
import threading
from pathlib import Path

SOCKET_PATH = "/tmp/speech_tts.sock"
LOCK_FILE = Path("/tmp/speech_tts.lock")
MODELS_DIR = Path.home() / ".local/share/piper"


_csv_out = csv.writer(sys.stdout)
def _csv(event, text=None):
    row = ["tts", event]
    if text is not None:
        row.append(text)
    _csv_out.writerow(row)
    sys.stdout.flush()


def run_tts_daemon(config):
    LOCK_FILE.write_text(str(os.getpid()))

    import numpy as np
    import sounddevice as sd
    from piper.voice import PiperVoice

    model = MODELS_DIR / f"{config['model']}.onnx"
    if not model.exists():
        _csv("error", f"model_not_found:{model}")
        sys.exit(1)

    volume = float(config.get("volume", 1.0))
    device = config.get("device", "pipewire")

    _csv("loading_model")
    voice = PiperVoice.load(model)
    _csv("ready")

    text_lock = threading.Lock()
    current_text = None
    text_available = threading.Event()
    cancel = threading.Event()

    def speaker():
        nonlocal current_text
        while True:
            text_available.wait()
            with text_lock:
                text = current_text
                current_text = None
                text_available.clear()
            if text is None:
                break

            cancel.clear()
            _csv("speaking", text)
            stream = sd.OutputStream(
                samplerate=voice.config.sample_rate,
                channels=1,
                dtype="int16",
                device=device,
            )
            stream.start()
            for chunk in voice.synthesize(text):
                if cancel.is_set():
                    break
                audio = np.frombuffer(chunk.audio_int16_bytes, dtype=np.int16)
                stream.write((audio * volume).clip(-32768, 32767).astype(np.int16))
            stream.stop()
            stream.close()
            if not cancel.is_set():
                _csv("done")

    threading.Thread(target=speaker, daemon=True).start()

    server = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    try:
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
                    with text_lock:
                        current_text = line
                        cancel.set()
                        text_available.set()
    finally:
        server.close()
        os.unlink(SOCKET_PATH)
        LOCK_FILE.unlink(missing_ok=True)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--config", type=Path, required=True)
    args = parser.parse_args()
    config = json.loads(args.config.read_text())
    run_tts_daemon(config)


if __name__ == "__main__":
    main()
