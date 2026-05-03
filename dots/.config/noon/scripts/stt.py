#!/usr/bin/env python3
import argparse
import fcntl
import json
import os
import signal
import subprocess
import sys
import threading
from pathlib import Path

LOCK_FILE = Path("/tmp/stt.lock")
CHUNK_SECONDS = 3
OVERLAP_SECONDS = 0.5


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--config", type=Path, default=None)
    return parser.parse_args()


def main():
    lock_fd = os.open(LOCK_FILE, os.O_CREAT | os.O_RDWR, 0o644)
    try:
        fcntl.flock(lock_fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
    except OSError:
        os.close(lock_fd)
        print("STT already running", file=sys.stderr)
        sys.exit(1)
    os.ftruncate(lock_fd, 0)
    os.write(lock_fd, f"{os.getpid()}\n".encode())

    try:
        args = parse_args()
        config = {}
        if args.config:
            config = json.loads(args.config.read_text())

        import ctypes
        cublas_path = "/usr/lib/ollama/libcublas.so.12"
        if os.path.exists(cublas_path):
            ctypes.CDLL(cublas_path)

        import numpy as np
        import sounddevice as sd
        from faster_whisper import WhisperModel

        model_name = config.get("whisper_model", "base")
        device = config.get("device", "pipewire")
        sample_rate = 16000
        chunk_samples = int(CHUNK_SECONDS * sample_rate)
        overlap_samples = int(OVERLAP_SECONDS * sample_rate)

        all_chunks = []
        window_chunks = []
        lock = threading.Lock()
        stop_event = threading.Event()
        last_printed = ""

        cache = Path.home() / ".cache/huggingface/hub"
        model_cached = (
            any(model_name in str(p) for p in cache.glob("**/config.json"))
            if cache.exists()
            else False
        )
        if not model_cached:
            print(f"Downloading model '{model_name}'...", file=sys.stderr)
        model = WhisperModel(model_name, device="cuda", compute_type="int8")
        if not model_cached:
            print("Download complete.", file=sys.stderr)

        signal.signal(signal.SIGTERM, lambda *_: stop_event.set())
        signal.signal(signal.SIGINT, lambda *_: stop_event.set())

        def callback(indata, frames, time, status):
            with lock:
                all_chunks.append(indata.copy())
                window_chunks.append(indata.copy())

        def transcribe_loop():
            nonlocal last_printed
            while not stop_event.is_set():
                with lock:
                    total = sum(c.shape[0] for c in window_chunks)
                if total < chunk_samples:
                    threading.Event().wait(0.5)
                    continue
                with lock:
                    audio_window = np.concatenate(window_chunks).flatten()
                    kept_samples = min(overlap_samples, len(audio_window))
                    kept = audio_window[-kept_samples:]
                    window_chunks.clear()
                    window_chunks.append(kept.reshape(-1, 1))
                segments, _ = model.transcribe(
                    audio_window,
                    language=config.get("language"),
                    beam_size=1,
                    best_of=1,
                    vad_filter=True,
                )
                text = " ".join(s.text.strip() for s in segments).strip()
                if text and text != last_printed:
                    print(text, flush=True)
                    last_printed = text

        result = subprocess.run(
            ["pactl", "get-source-mute", "@DEFAULT_SOURCE@"],
            capture_output=True, text=True, timeout=3
        )
        if "Mute: yes" in result.stdout:
            print("Microphone is muted — unmute to start STT", file=sys.stderr)
            return

        t = threading.Thread(target=transcribe_loop, daemon=True)
        t.start()

        print("Recording... (Ctrl+C or SIGTERM to stop)", file=sys.stderr)
        with sd.InputStream(
            samplerate=sample_rate,
            channels=1,
            dtype="float32",
            device=device,
            callback=callback,
        ):
            stop_event.wait()

    finally:
        fcntl.flock(lock_fd, fcntl.LOCK_UN)
        os.close(lock_fd)
        LOCK_FILE.unlink(missing_ok=True)


if __name__ == "__main__":
    main()
