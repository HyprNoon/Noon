#!/usr/bin/env python3
"""
Wine Manager - ProtonUp-Qt clone for Noon
Manages Wine-GE, Proton-GE, UMU-Proton versions, per-app configs, and app detection.
"""

import argparse
import json
import os
import re
import shutil
import stat
import subprocess
import sys
import tarfile
import tempfile
import time
import urllib.request
import urllib.error
from dataclasses import dataclass, field, asdict
from pathlib import Path
from typing import Optional

STATE_DIR = Path.home() / ".local" / "state" / "noon"
STATE_FILE = STATE_DIR / "wine_manager.json"
COMPAT_DIRS = [
    Path.home() / ".local" / "share" / "Steam" / "compatibilitytools.d",
    Path.home() / ".local" / "share" / "umu" / "compatibilitytools",
]
LUTRIS_RUNNERS = Path.home() / ".local" / "share" / "lutris" / "runners" / "wine"
WINE_PREFIXES = Path.home() / ".local" / "share" / "wineprefixes"
USER_SCRIPTS = Path.home() / ".local" / "bin"

GITHUB_API = "https://api.github.com"
SOURCES = {
    "wine-ge": {
        "repo": "GloriousEggroll/wine-ge-custom",
        "type": "wine",
        "label": "Wine-GE",
        "compat_dir": False,
    },
    "proton-ge": {
        "repo": "GloriousEggroll/proton-ge-custom",
        "type": "proton",
        "label": "Proton-GE",
        "compat_dir": True,
    },
    "umu-proton": {
        "repo": "Open-Wine-Components/umu-proton",
        "type": "proton",
        "label": "UMU-Proton",
        "compat_dir": True,
    },
    "proton": {
        "repo": "ValveSoftware/Proton",
        "type": "proton",
        "label": "Valve Proton",
        "compat_dir": True,
    },
}


@dataclass
class AppConfig:
    app_path: str
    runner: str = ""
    env: dict = field(default_factory=dict)
    dxvk: bool = False
    vkd3d: bool = False
    gamemode: bool = False
    mangohud: bool = False
    gamescope: bool = False
    gamescope_args: str = ""
    wine_args: list = field(default_factory=list)
    notes: str = ""


@dataclass
class State:
    installed: dict = field(default_factory=dict)
    apps: dict = field(default_factory=dict)
    default_runner: str = ""

    def save(self):
        STATE_DIR.mkdir(parents=True, exist_ok=True)
        STATE_FILE.write_text(json.dumps(asdict(self), indent=2))

    @staticmethod
    def load() -> "State":
        if STATE_FILE.exists():
            try:
                data = json.loads(STATE_FILE.read_text())
                return State(**data)
            except Exception:
                pass
        return State()


def api_request(url: str) -> Optional[dict | list]:
    req = urllib.request.Request(url)
    req.add_header("Accept", "application/vnd.github+json")
    req.add_header("User-Agent", "noon-wine-manager")
    try:
        with urllib.request.urlopen(req, timeout=15) as resp:
            return json.loads(resp.read())
    except (urllib.error.HTTPError, urllib.error.URLError, OSError) as e:
        print(f"API request failed: {e}", file=sys.stderr)
        return None


def fetch_releases(source_key: str, max_pages: int = 2) -> list[dict]:
    info = SOURCES.get(source_key)
    if not info:
        return []
    releases = []
    page = 1
    while page <= max_pages:
        url = f"{GITHUB_API}/repos/{info['repo']}/releases?per_page=30&page={page}"
        data = api_request(url)
        if not data or not isinstance(data, list):
            break
        releases.extend(data)
        if len(data) < 30:
            break
        page += 1
    return releases


def parse_version(tag_name: str) -> tuple:
    nums = re.findall(r"(\d+(?:\.\d+)*)", tag_name)
    return tuple(int(x) for x in nums[0].split(".")) if nums else (0,)


def get_asset_url(release: dict, ext=(".tar.gz", ".tar.xz")) -> Optional[str]:
    for asset in release.get("assets", []):
        name = asset.get("name", "")
        if name.endswith(ext) and "sha" not in name and "sum" not in name:
            return asset["browser_download_url"]
    return None


def get_checksum_url(release: dict) -> Optional[str]:
    for asset in release.get("assets", []):
        name = asset.get("name", "")
        if "sha256" in name or "sha512" in name or "sum" in name:
            return asset["browser_download_url"]
    return None


def download_file(url: str, dest: Path, label: str = "") -> bool:
    print(f"Downloading {label or url}...", file=sys.stderr)
    try:
        req = urllib.request.Request(url)
        req.add_header("User-Agent", "noon-wine-manager")
        with urllib.request.urlopen(req, timeout=120) as resp:
            total = int(resp.headers.get("Content-Length", 0))
            downloaded = 0
            chunk_size = 8192
            with open(dest, "wb") as f:
                while chunk := resp.read(chunk_size):
                    f.write(chunk)
                    downloaded += len(chunk)
                    if total:
                        pct = downloaded * 100 // total
                        print(f"\r  {label}: {pct}% ({downloaded // 1024 // 1024}MB / {total // 1024 // 1024}MB)", file=sys.stderr, end="")
            if total:
                print(file=sys.stderr)
        return True
    except Exception as e:
        print(f"Download failed: {e}", file=sys.stderr)
        dest.unlink(missing_ok=True)
        return False


def extract_tarball(path: Path, dest: Path, strip_components: int = 0) -> Optional[Path]:
    print(f"Extracting {path.name}...", file=sys.stderr)
    dest.mkdir(parents=True, exist_ok=True)
    extract_dir = tempfile.mkdtemp(dir=str(dest))
    try:
        with tarfile.open(path) as tar:
            tar.extractall(extract_dir)
        items = sorted(Path(extract_dir).iterdir())
        if not items:
            return None
        root = items[0] if len(items) == 1 else Path(extract_dir)
        version_dir = dest / root.name
        if version_dir.exists():
            shutil.rmtree(version_dir)
        shutil.move(str(root), str(version_dir))
        _chmod_recursive(version_dir)
        path.unlink()
        return version_dir
    except Exception as e:
        print(f"Extraction failed: {e}", file=sys.stderr)
        shutil.rmtree(extract_dir, ignore_errors=True)
        return None


def _chmod_recursive(path: Path):
    for root, dirs, files in os.walk(path):
        for d in dirs:
            os.chmod(os.path.join(root, d), os.stat(os.path.join(root, d)).st_mode | stat.S_IRWXU | stat.S_IRWXG)
        for f in files:
            fp = os.path.join(root, f)
            st = os.stat(fp)
            os.chmod(fp, st.st_mode | stat.S_IRUSR | stat.S_IWUSR | stat.S_IRGRP | stat.S_IROTH)
            if os.access(fp, os.X_OK) or f in ("wine", "wine64", "wine-preloader"):
                os.chmod(fp, st.st_mode | stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH)


def find_installed_compat_tools() -> dict[str, Path]:
    tools = {}
    for compat_dir in COMPAT_DIRS:
        if not compat_dir.exists():
            continue
        for entry in compat_dir.iterdir():
            if entry.is_dir():
                wine_bin = entry / "files" / "bin" / "wine"
                proton_bin = entry / "proton"
                if wine_bin.exists() or proton_bin.exists():
                    tools[entry.name] = entry
    if LUTRIS_RUNNERS.exists():
        for entry in LUTRIS_RUNNERS.iterdir():
            if entry.is_dir():
                wine_bin = entry / "bin" / "wine"
                if wine_bin.exists():
                    tools[f"lutris-{entry.name}"] = entry
    return tools


def detect_installed_wine_bottles() -> list[dict]:
    bottles = []
    prefixes_dir = WINE_PREFIXES
    if prefixes_dir.exists():
        for entry in prefixes_dir.iterdir():
            if entry.is_dir() and (entry / "drive_c").exists():
                bottles.append({
                    "name": entry.name,
                    "path": str(entry),
                    "size_mb": _dir_size_mb(entry),
                })
    steam_compat = Path.home() / ".steam" / "steam" / "compatibilitytools.d"
    if steam_compat.exists():
        for entry in steam_compat.iterdir():
            if entry.is_dir() and (entry / "dist").exists():
                bottles.append({
                    "name": f"steam-{entry.name}",
                    "path": str(entry),
                    "size_mb": _dir_size_mb(entry),
                })
    return bottles


def _dir_size_mb(path: Path) -> int:
    total = 0
    for f in path.rglob("*"):
        if f.is_file():
            try:
                total += f.stat().st_size
            except OSError:
                pass
    return total // (1024 * 1024)


def list_exe_apps(search_dirs: list[Path] = None) -> list[dict]:
    if search_dirs is None:
        search_dirs = [
            Path.home() / ".local" / "share" / "applications",
            Path.home() / ".local" / "share" / "Steam" / "steamapps" / "common",
        ]
    apps = []
    for d in search_dirs:
        if not d.exists():
            continue
        for f in d.rglob("*.exe"):
            if "uninstall" in f.stem.lower() or "setup" in f.stem.lower():
                continue
            apps.append({
                "name": f.stem,
                "path": str(f),
                "dir": str(f.parent),
                "size_kb": f.stat().st_size // 1024,
            })
    return apps


def detect_wine_apps() -> list[dict]:
    apps = []
    steam_dir = Path.home() / ".steam" / "steam" / "steamapps" / "common"
    if steam_dir.exists():
        for game_dir in steam_dir.iterdir():
            if not game_dir.is_dir():
                continue
            exes = list(game_dir.rglob("*.exe"))
            if exes:
                apps.append({
                    "name": game_dir.name,
                    "path": str(exes[0]),
                    "dir": str(game_dir),
                    "source": "steam",
                    "exes": [str(e) for e in exes[:5]],
                })
    lutris_dir = Path.home() / ".local" / "share" / "lutris" / "games"
    if lutris_dir.exists():
        for f in lutris_dir.iterdir():
            if f.suffix == ".yml":
                apps.append({
                    "name": f.stem,
                    "path": str(f),
                    "source": "lutris",
                })
    prefixes_dir = WINE_PREFIXES
    if prefixes_dir.exists():
        for prefix in prefixes_dir.iterdir():
            drive_c = prefix / "drive_c"
            if not drive_c.exists():
                continue
            exes = list(drive_c.rglob("*.exe"))
            if exes:
                abs_exes = sorted(
                    (e for e in exes if "windows" not in str(e).lower() and "system32" not in str(e).lower()),
                    key=lambda x: x.stat().st_size,
                    reverse=True,
                )[:5]
                apps.append({
                    "name": prefix.name,
                    "path": str(abs_exes[0]) if abs_exes else str(prefix),
                    "dir": str(prefix),
                    "source": "wineprefix",
                    "exes": [str(e) for e in abs_exes],
                })
    return apps


# --- commands ---

def cmd_list_remote(args):
    releases = fetch_releases(args.source)
    if not releases:
        print(json.dumps({"error": "Failed to fetch releases", "source": args.source}))
        return
    versions = []
    for r in releases:
        tag = r.get("tag_name", "")
        asset = get_asset_url(r)
        if asset:
            versions.append({
                "tag": tag,
                "name": r.get("name", tag),
                "url": asset,
                "published": r.get("published_at", ""),
                "prerelease": r.get("prerelease", False),
                "size": _asset_size(r),
            })
    print(json.dumps({"source": args.source, "versions": versions, "label": SOURCES[args.source]["label"]}))


def _asset_size(release: dict) -> int:
    for asset in release.get("assets", []):
        name = asset.get("name", "")
        if any(name.endswith(e) for e in (".tar.gz", ".tar.xz")):
            return asset.get("size", 0)
    return 0


def cmd_list_installed(_args):
    tools = find_installed_compat_tools()
    installed = []
    for name, path in tools.items():
        size_mb = _dir_size_mb(path)
        wine_bin = path / "files" / "bin" / "wine"
        version = _detect_version(path, name)
        installed.append({
            "name": name,
            "path": str(path),
            "size_mb": size_mb,
            "version": version,
            "type": "proton" if (path / "proton").exists() else "wine",
        })
    print(json.dumps(installed))


def _detect_version(path: Path, fallback: str) -> str:
    version_file = path / "version"
    if version_file.exists():
        return version_file.read_text().strip()
    compat = path / "compatibilitytool.vdf"
    if compat.exists():
        try:
            import vdf
            data = vdf.loads(compat.read_text())
            return data.get("compatibilitytools", {}).get("compat_tools", {}).get(fallback, {}).get("install_path", fallback)
        except Exception:
            pass
    wine_bin = path / "files" / "bin" / "wine64"
    if not wine_bin.exists():
        wine_bin = path / "files" / "bin" / "wine"
    if wine_bin.exists():
        try:
            result = subprocess.run([str(wine_bin), "--version"], capture_output=True, text=True, timeout=10)
            if result.returncode == 0:
                return result.stdout.strip()
        except Exception:
            pass
    return fallback


def cmd_install(args):
    releases = fetch_releases(args.source)
    if not releases:
        print(json.dumps({"success": False, "error": "Failed to fetch releases"}))
        return

    target_tag = args.version
    target_release = None
    for r in releases:
        if r.get("tag_name") == target_tag:
            target_release = r
            break
    if not target_release:
        for r in releases:
            if target_tag in r.get("tag_name", ""):
                target_release = r
                break
    if not target_release and target_tag == "latest":
        target_release = releases[0]
    if not target_release:
        print(json.dumps({"success": False, "error": f"Version '{target_tag}' not found"}))
        return

    asset_url = get_asset_url(target_release)
    if not asset_url:
        print(json.dumps({"success": False, "error": "No downloadable asset found"}))
        return

    tag = target_release.get("tag_name", "unknown")
    info = SOURCES.get(args.source, {})
    dest_dir = COMPAT_DIRS[0] if info.get("compat_dir") else COMPAT_DIRS[1]
    dest_dir.mkdir(parents=True, exist_ok=True)

    tmp_file = STATE_DIR / f"download_{tag}.tar.gz"
    print(json.dumps({"status": "downloading", "tag": tag, "url": asset_url}))
    sys.stdout.flush()

    if not download_file(asset_url, tmp_file, label=tag):
        print(json.dumps({"success": False, "error": "Download failed"}))
        return

    extracted = extract_tarball(tmp_file, dest_dir)
    if not extracted:
        print(json.dumps({"success": False, "error": "Extraction failed"}))
        return

    state = State.load()
    state.installed[extracted.name] = {
        "path": str(extracted),
        "tag": tag,
        "source": args.source,
        "type": info.get("type", "wine"),
    }
    state.save()

    print(json.dumps({"success": True, "name": extracted.name, "path": str(extracted), "tag": tag}))


def cmd_uninstall(args):
    tools = find_installed_compat_tools()
    name = args.name
    if name not in tools:
        print(json.dumps({"success": False, "error": f"'{name}' not found"}))
        return
    shutil.rmtree(tools[name], ignore_errors=True)
    state = State.load()
    state.installed.pop(name, None)
    state.save()
    print(json.dumps({"success": True, "name": name}))


def cmd_update(args):
    for source_key in SOURCES:
        releases = fetch_releases(source_key, max_pages=1)
        if not releases:
            continue
        latest = releases[0]
        tag = latest.get("tag_name", "")
        tools = find_installed_compat_tools()
        installed = {k: v for k, v in tools.items() if source_key.replace("-", "").lower() in k.lower().replace("-", "")}
        if installed:
            for name, path in installed.items():
                if tag not in name:
                    print(json.dumps({"updatable": True, "name": name, "current": name, "latest": tag, "source": source_key}))
    print(json.dumps({"updatable": False}))


def cmd_list_apps(_args):
    apps = detect_wine_apps()
    print(json.dumps(apps))


def cmd_list_prefixes(_args):
    bottles = detect_installed_wine_bottles()
    print(json.dumps(bottles))


def cmd_list_exes(args):
    dirs = [Path(d) for d in args.dirs] if args.dirs else None
    apps = list_exe_apps(dirs)
    print(json.dumps(apps))


def cmd_set_default(args):
    state = State.load()
    state.default_runner = args.runner
    state.save()
    print(json.dumps({"success": True, "default": args.runner}))


def cmd_get_default(_args):
    state = State.load()
    print(json.dumps({"default": state.default_runner}))


def cmd_per_app_set(args):
    state = State.load()
    if args.app not in state.apps:
        state.apps[args.app] = asdict(AppConfig(app_path=args.app))
    config = state.apps[args.app]
    if args.runner is not None:
        config["runner"] = args.runner
    if args.dxvk is not None:
        config["dxvk"] = args.dxvk
    if args.vkd3d is not None:
        config["vkd3d"] = args.vkd3d
    if args.gamemode is not None:
        config["gamemode"] = args.gamemode
    if args.mangohud is not None:
        config["mangohud"] = args.mangohud
    if args.gamescope is not None:
        config["gamescope"] = args.gamescope
    if args.gamescope_args is not None:
        config["gamescope_args"] = args.gamescope_args
    if args.env:
        for pair in args.env:
            k, _, v = pair.partition("=")
            config["env"][k] = v
    if args.wine_args:
        config["wine_args"] = args.wine_args
    state.apps[args.app] = config
    state.save()
    print(json.dumps({"success": True, "app": args.app, "config": config}))


def cmd_per_app_get(args):
    state = State.load()
    config = state.apps.get(args.app)
    if config:
        print(json.dumps(config))
    else:
        print(json.dumps({"app_path": args.app}))


def cmd_per_app_list(_args):
    state = State.load()
    print(json.dumps(state.apps))


def cmd_per_app_remove(args):
    state = State.load()
    removed = state.apps.pop(args.app, None)
    state.save()
    print(json.dumps({"success": removed is not None, "app": args.app}))


def cmd_detect(_args):
    result = {
        "tools": list(find_installed_compat_tools().keys()),
        "apps": detect_wine_apps(),
        "prefixes": detect_installed_wine_bottles(),
    }
    print(json.dumps(result))


def cmd_install_app(args):
    exe_path = Path(args.exe)
    if not exe_path.exists():
        print(json.dumps({"success": False, "error": f"File not found: {args.exe}"}))
        return
    state = State.load()
    app_id = args.name or exe_path.stem
    state.apps[app_id] = asdict(AppConfig(
        app_path=str(exe_path),
        runner=args.runner or state.default_runner,
        dxvk=args.dxvk or False,
        vkd3d=args.vkd3d or False,
        gamemode=args.gamemode or False,
    ))
    state.save()
    script_path = USER_SCRIPTS / f"{app_id}.sh"
    USER_SCRIPTS.mkdir(parents=True, exist_ok=True)
    runner = args.runner or state.default_runner or "wine"
    script_content = f"""#!/bin/bash
export WINEPREFIX="$HOME/.local/share/wineprefixes/{app_id}"
{runner} "{exe_path}" "$@"
"""
    script_path.write_text(script_content)
    script_path.chmod(0o755)
    print(json.dumps({"success": True, "app_id": app_id, "script": str(script_path)}))


def cmd_uninstall_app(args):
    state = State.load()
    removed = state.apps.pop(args.app, None)
    if removed:
        state.save()
    script_path = USER_SCRIPTS / f"{args.app}.sh"
    if script_path.exists():
        script_path.unlink()
    print(json.dumps({"success": removed is not None, "app": args.app}))


def cmd_run_app(args):
    state = State.load()
    config = state.apps.get(args.app)
    if not config:
        state.apps[args.app] = asdict(AppConfig(app_path=args.app))
        config = state.apps[args.app]
        state.save()
    runner = config.get("runner") or state.default_runner or "wine"
    tools = find_installed_compat_tools()
    runner_path = tools.get(runner, Path(runner)) if runner in tools else Path(runner)
    if not runner_path.exists():
        runner_path = Path(shutil.which(runner) or runner)
    exe_path = Path(config["app_path"])
    if not exe_path.exists():
        print(json.dumps({"success": False, "error": f"Executable not found: {config['app_path']}"}))
        return
    cmd = [str(runner_path)] if runner_path.is_dir() else [str(runner_path)]
    if (runner_path / "proton").exists():
        cmd = [str(runner_path / "proton"), "run"]
    elif (runner_path / "files" / "bin" / "wine").exists():
        cmd = [str(runner_path / "files" / "bin" / "wine")]
    elif (runner_path / "bin" / "wine").exists():
        cmd = [str(runner_path / "bin" / "wine")]
    cmd += config.get("wine_args", [])
    cmd.append(str(exe_path))
    env = os.environ.copy()
    env.update(config.get("env", {}))
    env["WINEPREFIX"] = str(WINE_PREFIXES / args.app)
    WINE_PREFIXES.mkdir(parents=True, exist_ok=True)
    print(json.dumps({"success": True, "command": cmd, "cwd": str(exe_path.parent)}))
    if not args.dry_run:
        proc = subprocess.Popen(cmd, env=env, cwd=str(exe_path.parent))
        print(json.dumps({"success": True, "pid": proc.pid}))
        proc.wait()
        print(json.dumps({"success": True, "exit_code": proc.returncode}))


def cmd_status(_args):
    tools = find_installed_compat_tools()
    state = State.load()
    update_available = False
    for source_key in SOURCES:
        releases = fetch_releases(source_key, max_pages=1)
        if releases:
            latest_tag = releases[0].get("tag_name", "")
            for installed_name in tools:
                if latest_tag and latest_tag not in installed_name:
                    update_available = True
    result = {
        "compat_tools": {k: {"path": str(v), "version": _detect_version(v, k)} for k, v in tools.items()},
        "configured_apps": len(state.apps),
        "default_runner": state.default_runner,
        "update_available": update_available,
    }
    print(json.dumps(result))


# --- main ---

def build_parser():
    parser = argparse.ArgumentParser(prog="wine_manager", description="Wine/Proton Manager for Noon")
    sub = parser.add_subparsers(dest="command", required=True)

    sub.add_parser("list-remote", help="List available versions for a source").add_argument("source", choices=list(SOURCES.keys()), help="Source to list")

    sub.add_parser("list-installed", help="List installed compatibility tools")

    install_p = sub.add_parser("install", help="Download and install a version")
    install_p.add_argument("source", choices=list(SOURCES.keys()))
    install_p.add_argument("version", help="Tag name or 'latest'")

    uninstall_p = sub.add_parser("uninstall", help="Remove an installed version")
    uninstall_p.add_argument("name", help="Name of installed tool")

    sub.add_parser("update", help="Check for updates")

    sub.add_parser("detect", help="Detect all tools, apps, and prefixes")

    sub.add_parser("list-apps", help="Detect Wine-dependent apps")
    sub.add_parser("list-prefixes", help="List Wine prefixes")
    list_exes = sub.add_parser("list-exes", help="Find .exe files")
    list_exes.add_argument("--dirs", nargs="*", help="Additional directories to search")

    set_def = sub.add_parser("set-default", help="Set default Wine runner")
    set_def.add_argument("runner", help="Runner name or path")
    sub.add_parser("get-default", help="Get default runner")

    app_set = sub.add_parser("app-set", help="Configure per-app settings")
    app_set.add_argument("app", help="App identifier or exe path")
    app_set.add_argument("--runner", help="Runner for this app")
    app_set.add_argument("--dxvk", action="store_true", default=None)
    app_set.add_argument("--no-dxvk", dest="dxvk", action="store_false", default=None)
    app_set.add_argument("--vkd3d", action="store_true", default=None)
    app_set.add_argument("--no-vkd3d", dest="vkd3d", action="store_false", default=None)
    app_set.add_argument("--gamemode", action="store_true", default=None)
    app_set.add_argument("--no-gamemode", dest="gamemode", action="store_false", default=None)
    app_set.add_argument("--mangohud", action="store_true", default=None)
    app_set.add_argument("--no-mangohud", dest="mangohud", action="store_false", default=None)
    app_set.add_argument("--gamescope", action="store_true", default=None)
    app_set.add_argument("--no-gamescope", dest="gamescope", action="store_false", default=None)
    app_set.add_argument("--gamescope-args", help="Gamescope arguments")
    app_set.add_argument("--env", nargs="*", help="Extra env KEY=VALUE")
    app_set.add_argument("--wine-args", nargs="*", help="Extra wine arguments")

    app_get = sub.add_parser("app-get", help="Get per-app settings")
    app_get.add_argument("app", help="App identifier")

    sub.add_parser("app-list", help="List all configured apps")

    app_rm = sub.add_parser("app-remove", help="Remove app config")
    app_rm.add_argument("app", help="App identifier")

    install_app = sub.add_parser("app-install", help="Register and install a Wine app")
    install_app.add_argument("exe", help="Path to .exe")
    install_app.add_argument("--name", help="App name (defaults to exe filename)")
    install_app.add_argument("--runner", help="Runner to use")
    install_app.add_argument("--dxvk", action="store_true")
    install_app.add_argument("--vkd3d", action="store_true")
    install_app.add_argument("--gamemode", action="store_true")

    uninstall_app = sub.add_parser("app-uninstall", help="Remove app config and script")
    uninstall_app.add_argument("app", help="App identifier")

    run_app = sub.add_parser("app-run", help="Run a configured app")
    run_app.add_argument("app", help="App identifier")
    run_app.add_argument("--dry-run", action="store_true", help="Print command without running")

    sub.add_parser("status", help="Show overall status")

    return parser


if __name__ == "__main__":
    parser = build_parser()
    args = parser.parse_args()

    commands = {
        "list-remote": cmd_list_remote,
        "list-installed": cmd_list_installed,
        "install": cmd_install,
        "uninstall": cmd_uninstall,
        "update": cmd_update,
        "detect": cmd_detect,
        "list-apps": cmd_list_apps,
        "list-prefixes": cmd_list_prefixes,
        "list-exes": cmd_list_exes,
        "set-default": cmd_set_default,
        "get-default": cmd_get_default,
        "app-set": cmd_per_app_set,
        "app-get": cmd_per_app_get,
        "app-list": cmd_per_app_list,
        "app-remove": cmd_per_app_remove,
        "app-install": cmd_install_app,
        "app-uninstall": cmd_uninstall_app,
        "app-run": cmd_run_app,
        "status": cmd_status,
    }

    handler = commands.get(args.command)
    if handler:
        handler(args)
