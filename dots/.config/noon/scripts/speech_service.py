#!/usr/bin/env python3
import argparse
import csv
import os
import signal
import socket
import subprocess
import sys
from pathlib import Path

SOCKET_PATH = Path("/tmp/speech_tts.sock")
LOCK_FILE = Path("/tmp/speech_tts.lock")


_csv_out = csv.writer(sys.stdout)
def _csv(event, data=None):
    row = ["service", event]
    if data is not None:
        row.append(str(data))
    _csv_out.writerow(row)
    sys.stdout.flush()

def log(status, msg):
    print(f"speech|{status}|{msg}", file=sys.stderr, flush=True)


def tts_is_running():
    if not LOCK_FILE.exists():
        return False
    return Path(f"/proc/{LOCK_FILE.read_text().strip()}").exists()


def main():
    parser = argparse.ArgumentParser(description="Speech service: STT and TTS")
    parser.add_argument("--config", type=Path, help="Config file path")

    stt = parser.add_argument_group("STT")
    stt.add_argument("--stt", action="store_true", help="Run speech-to-text")

    tts = parser.add_argument_group("TTS")
    tts.add_argument("--tts-load", action="store_true", help="Start TTS daemon")
    tts.add_argument("--tts-unload", action="store_true", help="Stop TTS daemon")
    tts.add_argument("--tts-status", action="store_true", help="Check TTS daemon status")

    parser.add_argument("text", nargs="*", help="Text to speak")
    args = parser.parse_args()

    if args.stt:
        from speech.stt import run_stt
        run_stt(args.config)

    elif args.tts_status:
        running = tts_is_running()
        _csv("status", "running" if running else "stopped")
        log("ok", "daemon_running" if running else "daemon_stopped")

    elif args.tts_load:
        if tts_is_running():
            _csv("error", "daemon_already_running")
            log("error", "daemon_already_running")
            sys.exit(1)
        if not args.config:
            _csv("error", "config_required")
            log("error", "config_required")
            sys.exit(1)
        daemon = Path(__file__).parent / "speech" / "tts.py"
        subprocess.Popen(
            [sys.executable, str(daemon), "--config", str(args.config)],
            stderr=sys.stderr,
        )
        _csv("daemon_started")
        log("ok", "daemon_started")

    elif args.tts_unload:
        if not tts_is_running():
            _csv("error", "daemon_not_running")
            log("error", "daemon_not_running")
            sys.exit(1)
        os.kill(int(LOCK_FILE.read_text().strip()), signal.SIGTERM)
        _csv("daemon_stopped")
        log("ok", "daemon_stopped")

    elif args.text:
        if not tts_is_running() or not SOCKET_PATH.exists():
            _csv("error", "daemon_not_running")
            log("error", "daemon_not_running")
            sys.exit(1)
        text = " ".join(args.text)
        with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as s:
            s.connect(str(SOCKET_PATH))
            s.sendall(text.encode())
        _csv("sent", text)
        log("ok", "sent")

    else:
        _csv("error", "no_action")
        log("error", "no_action")
        sys.exit(1)


if __name__ == "__main__":
    main()
