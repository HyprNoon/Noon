#!/usr/bin/env python3

import fcntl
import hashlib
import os
import subprocess
import sys
import tempfile
from multiprocessing import Pool
from pathlib import Path
from typing import List

import click
from loguru import logger
from PIL import Image
from PIL.PngImagePlugin import PngInfo
from tqdm import tqdm

VIDEO_EXTENSIONS = {".mp4", ".webm", ".mkv", ".mov", ".avi", ".m4v"}

THUMBNAIL_CACHE = Path.home() / ".cache" / "thumbnails"

thumbnail_size_map = {
    "normal": 128,
    "large": 256,
    "x-large": 512,
    "xx-large": 1024,
}

thumbnail_size = None
logger.remove()
logger.add(sys.stdout, level="INFO")
logger.add("/tmp/thumbnails_service.log", level="DEBUG", rotation="100 MB")

LOCK_FILE = "/tmp/thumbnails_service.lock"
_lock_fh = None


def acquire_lock() -> None:
    global _lock_fh
    _lock_fh = open(LOCK_FILE, "w")
    try:
        fcntl.flock(_lock_fh, fcntl.LOCK_EX | fcntl.LOCK_NB)
    except BlockingIOError:
        logger.error("Another instance is already running. Exiting.")
        sys.exit(1)


def release_lock() -> None:
    if _lock_fh:
        fcntl.flock(_lock_fh, fcntl.LOCK_UN)
        _lock_fh.close()


def init_worker(size: str) -> None:
    global thumbnail_size
    thumbnail_size = size


def get_thumbnail_dir(size: str) -> Path:
    return THUMBNAIL_CACHE / size


def get_thumbnail_path(uri: str, size: str) -> Path:
    md5 = hashlib.md5(uri.encode()).hexdigest()
    return get_thumbnail_dir(size) / f"{md5}.png"


def ensure_cache_dirs() -> None:
    for size in thumbnail_size_map:
        get_thumbnail_dir(size).mkdir(parents=True, exist_ok=True)


def is_fresh(uri: str, mtime: float) -> bool:
    thumb_path = get_thumbnail_path(uri, thumbnail_size)
    if not thumb_path.exists():
        return False
    try:
        img = Image.open(thumb_path)
        return img.info.get("Thumb::MTime") == str(int(mtime))
    except Exception:
        return False


def make_video_thumbnail(fpath: str) -> bool:
    mtime = os.path.getmtime(fpath)
    uri = Path(fpath).resolve().as_uri()

    if is_fresh(uri, mtime):
        logger.debug("FRESH       {}".format(uri))
        return False

    fd, tmppath = tempfile.mkstemp(suffix=".png")
    os.close(fd)
    try:
        subprocess.run(
            ["ffmpeg", "-y", "-i", fpath, "-vframes", "1", "-an", tmppath],
            capture_output=True,
            timeout=30,
            check=True,
        )
        img = Image.open(tmppath)
        img.thumbnail(
            (thumbnail_size_map[thumbnail_size], thumbnail_size_map[thumbnail_size]),
            Image.LANCZOS,
        )

        metadata = PngInfo()
        metadata.add_text("Thumb::URI", uri)
        metadata.add_text("Thumb::MTime", str(int(mtime)))
        metadata.add_text("Software", "Noon Thumbnails")

        save_path = get_thumbnail_path(uri, thumbnail_size)
        save_path.parent.mkdir(parents=True, exist_ok=True)
        img.save(str(save_path), format="PNG", pnginfo=metadata)

        logger.debug("OK          {}".format(uri))
        return True
    except Exception:
        logger.debug("ERROR       {}".format(uri))
        return False
    finally:
        if os.path.exists(tmppath):
            os.unlink(tmppath)


def make_image_thumbnail(fpath: str) -> bool:
    mtime = os.path.getmtime(fpath)
    uri = Path(fpath).resolve().as_uri()

    if is_fresh(uri, mtime):
        logger.debug("FRESH       {}".format(uri))
        return False

    try:
        img = Image.open(fpath)
        img.thumbnail(
            (thumbnail_size_map[thumbnail_size], thumbnail_size_map[thumbnail_size]),
            Image.LANCZOS,
        )

        metadata = PngInfo()
        metadata.add_text("Thumb::URI", uri)
        metadata.add_text("Thumb::MTime", str(int(mtime)))
        metadata.add_text("Software", "Noon Thumbnails")

        save_path = get_thumbnail_path(uri, thumbnail_size)
        save_path.parent.mkdir(parents=True, exist_ok=True)
        img.save(str(save_path), format="PNG", pnginfo=metadata)

        logger.debug("OK          {}".format(uri))
        return True
    except Exception:
        logger.debug("ERROR       {}".format(uri))
        return False


def make_thumbnail(fpath: str) -> bool:
    if Path(fpath).suffix.lower() in VIDEO_EXTENSIONS:
        return make_video_thumbnail(fpath)
    return make_image_thumbnail(fpath)


@logger.catch()
def thumbnail_folder(
    *,
    dir_path: Path,
    workers: int,
    only_images: bool,
    recursive: bool,
    size: str,
    machine_progress: bool = False,
) -> None:
    all_files = get_all_files(dir_path=dir_path, recursive=recursive)
    if only_images:
        all_files = get_all_images(all_files=all_files)
    all_files = [str(fpath) for fpath in all_files]
    if machine_progress:
        completed = 0
        total = len(all_files)
        with Pool(processes=workers, initializer=init_worker, initargs=(size,)) as p:
            for result in p.imap(make_thumbnail, all_files):
                completed += 1
                print(f"PROGRESS {completed}/{total} FILE {all_files[completed - 1]}")
                sys.stdout.flush()
    else:
        with Pool(processes=workers, initializer=init_worker, initargs=(size,)) as p:
            list(tqdm(p.imap(make_thumbnail, all_files), total=len(all_files)))


def get_all_images(*, all_files: List[Path]) -> List[Path]:
    img_suffixes = [".jpg", ".jpeg", ".png", ".gif"]
    all_images = [fpath for fpath in all_files if fpath.suffix in img_suffixes]
    print("Found {} images".format(len(all_images)))
    return all_images


def get_all_files(*, dir_path: Path, recursive: bool) -> List[Path]:
    if not (dir_path.exists() and dir_path.is_dir()):
        raise ValueError(
            "{} doesn't exist or isn't a valid directory!".format(dir_path.resolve())
        )
    if recursive:
        all_files = dir_path.rglob("*")
    else:
        all_files = dir_path.glob("*")
    all_files = [fpath for fpath in all_files if fpath.is_file()]
    print(
        "Found {} files in the directory: {}".format(len(all_files), dir_path.resolve())
    )
    return all_files


@click.command()
@click.option(
    "-d",
    "--img_dirs",
    required=True,
    help='directories to generate thumbnails seperated by space, eg: "dir1/dir2 dir3"',
)
@click.option(
    "-s",
    "--size",
    default="normal",
    type=click.Choice(["normal", "large", "x-large", "xx-large"]),
    help="Thumbnail size: normal, large, x-large, xx-large",
)
@click.option(
    "-w",
    "--workers",
    default=None,
    type=int,
    help="no of cpus to use for processing (default: all available cores)",
)
@click.option(
    "-i",
    "--only_images",
    is_flag=True,
    default=False,
    help="Whether to only look for images to be thumbnailed",
)
@click.option(
    "-r",
    "--recursive",
    is_flag=True,
    default=False,
    help="Whether to recursively look for files",
)
@click.option(
    "--machine_progress",
    is_flag=True,
    default=False,
    help="Print machine-readable progress lines instead of a progress bar",
)
def main(
    img_dirs: str,
    size: str,
    workers: int,
    only_images: bool,
    recursive: bool,
    machine_progress: bool,
) -> None:
    acquire_lock()
    ensure_cache_dirs()
    try:
        img_dirs = [Path(img_dir) for img_dir in img_dirs.split()]
        for img_dir in img_dirs:
            thumbnail_folder(
                dir_path=img_dir,
                workers=workers,
                only_images=only_images,
                recursive=recursive,
                size=size,
                machine_progress=machine_progress,
            )
        print("Thumbnail Generation Completed!")
    finally:
        release_lock()


if __name__ == "__main__":
    main()
