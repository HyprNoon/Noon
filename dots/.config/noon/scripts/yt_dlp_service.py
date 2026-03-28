#!/usr/bin/env python3
"""
Final yt-dlp Service - Fixed for your setup
"""

import argparse
import json
import mimetypes
import threading
import time
from pathlib import Path

import yt_dlp

JOBS_DIR = Path.home() / ".ytdlp-manager"
JOBS_FILE = JOBS_DIR / "jobs.json"
JOBS_DIR.mkdir(parents=True, exist_ok=True)


def load_jobs():
    if JOBS_FILE.exists():
        try:
            with open(JOBS_FILE, "r", encoding="utf-8") as f:
                return json.load(f)
        except:
            return {}
    return {}


def save_jobs(jobs):
    try:
        with open(JOBS_FILE, "w", encoding="utf-8") as f:
            json.dump(jobs, f, indent=2, ensure_ascii=False)
    except:
        pass


def get_label(url: str):
    try:
        with yt_dlp.YoutubeDL({"quiet": True, "noplaylist": True}) as ydl:
            info = ydl.extract_info(url, download=False)
            title = (
                info.get("title", "video").replace("/", "_").replace("\\", "_").strip()
            )
            ext = info.get("ext", "mp4")
            return f"{title}.{ext}"
    except:
        return f"video_{int(time.time())}.mp4"


class DownloadManager:
    def __init__(self):
        self.jobs = load_jobs()
        self.lock = threading.Lock()

    def progress_hook(self, d, label):
        with self.lock:
            if label not in self.jobs:
                return
            job = self.jobs[label]

            if d["status"] == "downloading":
                job.update(
                    {
                        "state": "downloading",
                        "progress": d.get("_percent_str", "0%").strip(),
                        "eta": str(d.get("eta", "N/A")),
                        "size": d.get("_total_bytes_str")
                        or d.get("_total_bytes_estimate_str", "N/A"),
                    }
                )
            elif d["status"] == "finished":
                filename = d.get("filename")
                job.update(
                    {"state": "finished", "destination": filename, "progress": "100%"}
                )
                if filename and Path(filename).exists():
                    size_bytes = Path(filename).stat().st_size
                    mime, _ = mimetypes.guess_type(filename)
                    job.update(
                        {
                            "size_bytes": size_bytes,
                            "mime": mime or "video/webm",
                            "size": f"{size_bytes / (1024 * 1024):.1f} MiB",
                        }
                    )
            elif d["status"] == "error":
                job["state"] = "error"

            save_jobs(self.jobs)

    def download(
        self,
        url: str,
        output_dir: str,
        format_id: str = "bv*+ba/best",
        label: str = None,
    ):
        if label is None:
            label = get_label(url)

        # Check if file already exists
        output_template = str(Path(output_dir) / "%(title)s.%(ext)s")
        try:
            with yt_dlp.YoutubeDL({"quiet": True, "noplaylist": True}) as ydl:
                info = ydl.extract_info(url, download=False)
                filename = ydl.prepare_filename(info)
                if Path(filename).exists():
                    print(
                        json.dumps(
                            {
                                "status": "already_downloaded",
                                "label": Path(filename).name,
                                "destination": str(filename),
                            },
                            indent=2,
                        )
                    )
                    return
        except:
            pass

        with self.lock:
            self.jobs[label] = {
                "label": label,
                "url": url,
                "format": format_id,
                "output_dir": output_dir,
                "destination": None,
                "progress": "0%",
                "state": "starting",
                "eta": "N/A",
                "size": "N/A",
                "mime": "N/A",
                "size_bytes": 0,
                "started": time.time(),
            }
            save_jobs(self.jobs)

        def run():
            ydl_opts = {
                "format": format_id,
                "outtmpl": output_template,
                "noplaylist": True,
                "continue_dl": True,
                "progress_hooks": [lambda d: self.progress_hook(d, label)],
                "quiet": False,
                "remote_components": ["ejs:github"],
                "extractor_args": {"youtube": {"player_client": ["web", "ios"]}},
                "retries": 10,
            }
            try:
                with yt_dlp.YoutubeDL(ydl_opts) as ydl:
                    ydl.download([url])
            except Exception as e:
                with self.lock:
                    if label in self.jobs:
                        self.jobs[label]["state"] = "error"
                        save_jobs(self.jobs)

        threading.Thread(target=run, daemon=True).start()
        print(json.dumps({"status": "started", "label": label}, indent=2))

    def get_status(self, label=None):
        with self.lock:
            if label:
                job = self.jobs.get(label)
                if not job:
                    return {"error": "Job not found"}
                return {
                    "filename": job["label"],
                    "progress": job.get("progress", "0%"),
                    "destination": job.get("destination"),
                    "state": job.get("state", "unknown"),
                    "eta": job.get("eta", "N/A"),
                    "mime": job.get("mime", "N/A"),
                    "size": job.get("size", "N/A"),
                    "size_bytes": job.get("size_bytes", 0),
                }
            else:
                return [
                    {
                        "filename": j["label"],
                        "progress": j.get("progress", "0%"),
                        "destination": j.get("destination"),
                        "state": j.get("state", "unknown"),
                        "eta": j.get("eta", "N/A"),
                        "mime": j.get("mime", "N/A"),
                        "size": j.get("size", "N/A"),
                        "size_bytes": j.get("size_bytes", 0),
                    }
                    for j in self.jobs.values()
                ]


if __name__ == "__main__":
    manager = DownloadManager()

    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(dest="command", required=True)

    d = subparsers.add_parser("download")
    d.add_argument("url")
    d.add_argument("output_dir")
    d.add_argument("--format", default="bv*+ba/best")
    d.add_argument("--label", default=None)

    s = subparsers.add_parser("status")
    s.add_argument("--label", default=None)

    for name in ["pause", "resume", "cancel", "open"]:
        p = subparsers.add_parser(name)
        p.add_argument("label")

    args = parser.parse_args()

    if args.command == "download":
        manager.download(args.url, args.output_dir, args.format, args.label)
    elif args.command == "status":
        print(
            json.dumps(
                manager.get_status(getattr(args, "label", None)),
                indent=2,
                ensure_ascii=False,
            )
        )
    else:
        print(
            json.dumps(
                {"error": f"Command '{args.command}' not implemented yet"}, indent=2
            )
        )
