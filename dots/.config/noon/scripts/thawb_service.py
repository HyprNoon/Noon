#!/usr/bin/env python3
"""
thawb — ocs:// install handler for noon shell
usage: thawb.py "ocs://install?url=...&type=themes&filename=Foo.tar.gz"
"""

import os
import ssl
import subprocess
import sys
import tarfile
import tempfile
import urllib.parse
import urllib.request
import zipfile

# ── directories ──────────────────────────────────────────────────────────────

HOME = os.path.expanduser("~")

CATEGORY_DIR_MAP = {
    "themes": os.path.join(HOME, ".themes"),
    "icons": os.path.join(HOME, ".icons"),
    "cursors": os.path.join(HOME, ".icons"),
    "wallpapers": os.path.join(HOME, "Pictures", "Wallpapers"),
    "fonts": os.path.join(HOME, ".local", "share", "fonts"),
    "plasma5-look-and-feel": os.path.join(
        HOME, ".local", "share", "plasma", "look-and-feel"
    ),
    "plasma5-desktopthemes": os.path.join(
        HOME, ".local", "share", "plasma", "desktoptheme"
    ),
    "plasma5-plasmoids": os.path.join(HOME, ".local", "share", "plasma", "plasmoids"),
    "aurorae-themes": os.path.join(HOME, ".local", "share", "aurorae", "themes"),
}

PLASMAPKG_TYPE_MAP = {
    "plasma5-look-and-feel": "look-and-feel",
    "plasma5-desktopthemes": "theme",
    "plasma5-plasmoids": "plasmoid",
    "aurorae-themes": "aurorae",
}

FALLBACK_DIR = os.path.join(HOME, ".local", "share", "thawb")


# ── parse ─────────────────────────────────────────────────────────────────────


def parse_ocs_url(raw: str) -> dict:
    # strip scheme — ocs:// or xdg://
    if "?" not in raw:
        raise ValueError(f"No query string in URL: {raw}")

    query = raw[raw.index("?") + 1 :]
    params = urllib.parse.parse_qs(query, keep_blank_values=True)

    # parse_qs returns lists, grab first value
    def get(key):
        return params.get(key, [None])[0]

    download_url = get("url")
    if not download_url:
        raise ValueError("Missing 'url' param in OCS link")

    filename = get("filename") or download_url.split("/")[-1]
    pkg_type = (get("type") or "").lower()
    name = get("name") or filename

    return {
        "url": download_url,
        "filename": filename,
        "type": pkg_type,
        "name": name,
    }


# ── download ──────────────────────────────────────────────────────────────────


def download(url: str, dest_path: str):
    print(f"[thawb] downloading {url}")
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE
    with urllib.request.urlopen(url, context=ctx) as resp, open(dest_path, "wb") as f:
        f.write(resp.read())
    print(f"[thawb] saved to {dest_path}")


# ── extract ───────────────────────────────────────────────────────────────────


def extract(archive_path: str, target_dir: str):
    print(f"[thawb] extracting {archive_path} → {target_dir}")
    name = archive_path.lower()

    if tarfile.is_tarfile(archive_path):
        with tarfile.open(archive_path) as t:
            t.extractall(target_dir)

    elif name.endswith(".zip"):
        with zipfile.ZipFile(archive_path) as z:
            z.extractall(target_dir)

    else:
        print(f"[thawb] not an archive, leaving file in place")
        return

    os.remove(archive_path)
    print(f"[thawb] extraction complete")


# ── plasmapkg2 ────────────────────────────────────────────────────────────────


def install_plasma_pkg(archive_path: str, pkg_type: str):
    print(f"[thawb] plasmapkg2 -t {pkg_type} -i {archive_path}")
    result = subprocess.run(
        ["plasmapkg2", "-t", pkg_type, "-i", archive_path],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        raise RuntimeError(f"plasmapkg2 failed:\n{result.stderr}")
    print(f"[thawb] plasmapkg2 done")
    os.remove(archive_path)


# ── main ──────────────────────────────────────────────────────────────────────


def install(raw_url: str):
    info = parse_ocs_url(raw_url)
    pkg_type = info["type"]
    target_dir = CATEGORY_DIR_MAP.get(pkg_type, FALLBACK_DIR)

    os.makedirs(target_dir, exist_ok=True)

    archive_path = os.path.join(target_dir, info["filename"])

    download(info["url"], archive_path)

    if pkg_type in PLASMAPKG_TYPE_MAP:
        install_plasma_pkg(archive_path, PLASMAPKG_TYPE_MAP[pkg_type])
    else:
        extract(archive_path, target_dir)

    print(f"[thawb] installed: {info['name']}")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("usage: thawb.py <ocs://url>", file=sys.stderr)
        sys.exit(1)

    try:
        install(sys.argv[1])
    except Exception as e:
        print(f"[thawb] error: {e}", file=sys.stderr)
        sys.exit(1)
