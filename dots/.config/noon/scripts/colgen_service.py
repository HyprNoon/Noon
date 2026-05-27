import argparse
import colorsys
import json
import os
import re
import shlex
import shutil
import subprocess
import sys
import tempfile
import time
from pathlib import Path

XDG_STATE_HOME = os.path.expanduser("~/.local/state")

CONFIG_FILE = Path(XDG_STATE_HOME) / "noon" / "looks.json"
TEMP_FRAME = (
    Path(XDG_STATE_HOME) / "quickshell" / "user" / "generated" / "video_frame.jpg"
)


class WallpaperSwitcher:
    _looks_default = {
        "mode": "dark",
        "scheme": "scheme-tonal-spot",
        "autoShellMode": False,
        "autoSchemeSelection": False,
        "isBright": False,
        "isLive": False,
        "extractedColor": "",
    }

    def __init__(self):
        self.looks = self._load_looks()

    def _load_looks(self):
        try:
            return json.loads(CONFIG_FILE.read_text())
        except (FileNotFoundError, json.JSONDecodeError):
            return dict(self._looks_default)
        except Exception as e:
            print(f"WARNING: Error loading looks: {e}")
            return dict(self._looks_default)

    def _save_looks(self):
        try:
            CONFIG_FILE.parent.mkdir(parents=True, exist_ok=True)
            with tempfile.NamedTemporaryFile(
                mode="w", delete=False, suffix=".json", dir=CONFIG_FILE.parent
            ) as tmp:
                json.dump(self.looks, tmp, indent=4)
                tmp_path = Path(tmp.name)
            shutil.move(tmp_path, CONFIG_FILE)
        except Exception as e:
            print(f"ERROR: Failed to save looks: {e}")

    def get_current_shell_mode(self):
        mode = self.looks.get("mode", "dark")
        return mode if mode in ("dark", "light") else "dark"

    def get_current_scheme(self):
        return self.looks.get("scheme", "scheme-tonal-spot") or "scheme-tonal-spot"

    def get_auto_shell_mode_enabled(self):
        return bool(self.looks.get("autoShellMode", False))

    def get_auto_scheme_selection_enabled(self):
        return bool(self.looks.get("autoSchemeSelection", False))

    def get_is_bright(self):
        return bool(self.looks.get("isBright", False))

    def get_is_live(self):
        return bool(self.looks.get("isLive", False))

    def set_shell_mode(self, mode):
        if mode in ("dark", "light"):
            self.looks["mode"] = mode
            self._save_looks()

    def set_is_bright(self, is_bright):
        self.looks["isBright"] = bool(is_bright)
        self._save_looks()

    def set_is_live(self, is_live):
        self.looks["isLive"] = bool(is_live)
        self._save_looks()

    def toggle_shell_mode(self):
        new_mode = "light" if self.get_current_shell_mode() == "dark" else "dark"
        self.set_shell_mode(new_mode)
        return new_mode

    def update_appearance(self, mode=None, scheme=None, is_bright=None, is_live=None):
        if mode:
            self.looks["mode"] = mode
        if scheme:
            self.looks["scheme"] = scheme
        if is_bright is not None:
            self.looks["isBright"] = bool(is_bright)
        if is_live is not None:
            self.looks["isLive"] = bool(is_live)
        self._save_looks()

    def shell_run(self, cmd, capture_output=False):
        try:
            result = subprocess.run(
                cmd, shell=True, capture_output=capture_output, text=True, check=False
            )
            if capture_output:
                return result.stdout.strip()
            return result.returncode == 0
        except Exception as e:
            print(f"ERROR: Shell command failed: {e}")
            return "" if capture_output else False

    VIDEO_EXTS = {".mp4", ".mkv", ".avi", ".mov", ".webm", ".mpeg", ".mpg", ".flv"}
    IMAGE_EXTS = {".jpg", ".jpeg", ".png", ".gif", ".bmp", ".tiff", ".tif", ".webp"}

    def is_video(self, file_path):
        return file_path.suffix.lower() in self.VIDEO_EXTS

    def is_image(self, file_path):
        return file_path.suffix.lower() in self.IMAGE_EXTS

    def apply_colors(self, color, mode=None, scheme=None):
        shell_mode = mode or self.get_current_shell_mode()
        curr_scheme = scheme or self.get_current_scheme()

        if not color:
            print("ERROR: No color source available")
            return False

        self.looks["extractedColor"] = color
        self._save_looks()

        if shutil.which("matugen"):
            cmd = f"matugen color hex {color} --mode {shell_mode}"
            if curr_scheme != "scheme-tonal-spot":
                cmd += f" --type {curr_scheme}"
            cmd += " >/dev/null 2>&1"
            self.shell_run(cmd)

        time.sleep(0.2)
        return True

    def extract_image_info(self, image_path):
        from PIL import Image, ImageStat

        im = Image.open(image_path).convert("RGB")

        quantized = im.resize((200, 200)).quantize(
            colors=8, method=Image.Quantize.MEDIANCUT
        )
        palette = quantized.getpalette()
        best_color = None
        best_score = -1
        for i in range(8):
            r, g, b = palette[i * 3], palette[i * 3 + 1], palette[i * 3 + 2]
            _, s, v = colorsys.rgb_to_hsv(r / 255.0, g / 255.0, b / 255.0)
            if s * v > best_score:
                best_score = s * v
                best_color = "{:02X}{:02X}{:02X}".format(r, g, b)
        hex_color = best_color

        gray = im.convert("L").resize((64, 64))
        pixels = list(gray.getdata())
        mean = sum(pixels) / len(pixels)
        is_bright = mean >= 127
        suggested_mode = "light" if is_bright else "dark"

        small = im.resize((100, 100))
        sp = list(small.getdata())
        saturations, hues = [], []
        for r, g, b in sp:
            h, s, _ = colorsys.rgb_to_hsv(r / 255.0, g / 255.0, b / 255.0)
            saturations.append(s)
            hues.append(h)
        avg_sat = sum(saturations) / len(saturations) if saturations else 0
        unique_hues = len({int(h * 360) for h in hues})
        variance = sum(ImageStat.Stat(small).var) / 3

        if variance < 50:
            suggested_scheme = "scheme-monochrome"
        elif avg_sat < 0.15:
            suggested_scheme = "scheme-neutral"
        elif avg_sat > 0.6 and unique_hues > 180:
            suggested_scheme = "scheme-vibrant"
        elif unique_hues > 260:
            suggested_scheme = "scheme-rainbow"
        elif avg_sat > 0.45 and unique_hues > 80:
            suggested_scheme = "scheme-expressive"
        elif unique_hues < 60:
            suggested_scheme = "scheme-content"
        else:
            suggested_scheme = "scheme-tonal-spot"

        return hex_color, suggested_mode, is_bright, suggested_scheme

    def get_effective_shell_mode(self, requested_mode=None):
        if requested_mode in ("dark", "light"):
            return requested_mode
        return self.get_current_shell_mode()

    def get_effective_color_scheme(self, requested_scheme=None):
        return requested_scheme or self.get_current_scheme()

    def setup_gnome_theme(self, mode=None):
        if not mode:
            return
        try:
            scheme_val = "prefer-dark" if mode == "dark" else "prefer-light"
            self.shell_run(
                f"gsettings set org.gnome.desktop.interface color-scheme '{scheme_val}' 2>/dev/null"
            )
        except Exception as e:
            print(f"WARNING: GNOME theme setup error: {e}")

    def extract_video_frame(self, video_path):
        try:
            TEMP_FRAME.parent.mkdir(parents=True, exist_ok=True)

            if not shutil.which("ffmpeg") or not shutil.which("ffprobe"):
                print("ERROR: ffmpeg/ffprobe not found")
                return False

            duration = self.shell_run(
                f"ffprobe -v quiet -show_entries format=duration "
                f"-of csv=p=0 {shlex.quote(str(video_path))}",
                capture_output=True,
            )
            frame_time = 10.0
            if duration:
                try:
                    frame_time = max(1.0, min(float(duration) * 0.5, 10.0))
                except ValueError:
                    pass

            for ts, label in [
                (frame_time, f"{frame_time:.1f}s"),
                (0.1, "0.1s (fallback)"),
            ]:
                cmd = (
                    f"ffmpeg -ss {ts} -i {shlex.quote(str(video_path))} "
                    f"-vframes 1 -q:v 2 {shlex.quote(str(TEMP_FRAME))} -y 2>/dev/null"
                )
                if (
                    self.shell_run(cmd)
                    and TEMP_FRAME.is_file()
                    and TEMP_FRAME.stat().st_size > 1000
                ):
                    return True

            print("ERROR: Failed to extract video frame")
            return False
        except Exception as e:
            print(f"ERROR: Error extracting video frame: {e}")
            return False

    def pick_color(self):
        try:
            pickers = [
                ("hyprpicker", "hyprpicker --no-fancy"),
                ("kdialog", "kdialog --getcolor 'Pick color'"),
                ("zenity", "zenity --color-selection"),
            ]
            for name, cmd in pickers:
                if shutil.which(name):
                    result = self.shell_run(cmd, capture_output=True)
                    if result:
                        color = result.strip().lstrip("#")
                        return color
            print("ERROR: No color picker available")
            return None
        except Exception as e:
            print(f"ERROR: Color picker error: {e}")
            return None

    def pick_file(self):
        try:
            pictures = Path.home() / "Pictures"
            for subdir in ["Wallpapers/showcase", "Wallpapers", ""]:
                candidate = pictures / subdir
                if candidate.exists():
                    pictures = candidate
                    break

            pickers = [
                (
                    "kdialog",
                    f'kdialog --getopenfilename "{pictures}" --title "Choose wallpaper"',
                ),
                ("zenity", f'zenity --file-selection --filename="{pictures}"'),
            ]
            for name, cmd in pickers:
                if shutil.which(name):
                    result = self.shell_run(cmd, capture_output=True)
                    if result and Path(result).is_file():
                        return result

            user_input = input(f"Wallpaper path (default: {pictures}): ").strip()
            return user_input if user_input else str(pictures)
        except Exception as e:
            print(f"ERROR: File picker error: {e}")
            return None

    def handle_set(self, file_path, mode=None, scheme=None):
        path = Path(file_path)
        if not path.is_file():
            print(f"ERROR: File not found: {path}")
            return False

        is_vid = self.is_video(path)
        color_source = path

        if is_vid:
            if not self.extract_video_frame(path):
                print("WARNING: Could not extract video frame")
            else:
                color_source = TEMP_FRAME

        if not self.is_image(color_source):
            print(f"ERROR: Color source is not a valid image: {color_source}")
            return False

        hex_color, suggested_mode, is_bright, suggested_scheme = (
            self.extract_image_info(str(color_source))
        )
        if not hex_color:
            print("ERROR: Could not extract color from image")
            return False

        if mode in ("dark", "light"):
            current_mode = mode
        elif self.get_auto_shell_mode_enabled():
            current_mode = suggested_mode
        else:
            current_mode = self.get_current_shell_mode()

        if self.get_auto_shell_mode_enabled():
            self.set_shell_mode(current_mode)
        self.set_is_bright(is_bright)
        self.set_is_live(is_vid)

        if scheme:
            current_scheme = scheme
        elif self.get_auto_scheme_selection_enabled():
            current_scheme = suggested_scheme
            self.update_appearance(scheme=current_scheme)
        else:
            current_scheme = self.get_current_scheme()

        self.apply_colors(hex_color, mode=current_mode, scheme=current_scheme)
        self.update_appearance(
            current_mode, current_scheme, is_bright=is_bright, is_live=is_vid
        )
        self.setup_gnome_theme(current_mode)
        return True

    def handle_color(self, hex_color, mode=None, scheme=None):
        hex_color = hex_color.lstrip("#")
        if not re.match(r"^[A-Fa-f0-9]{6}$", hex_color):
            print("ERROR: Invalid colour format (use #RRGGBB or RRGGBB)")
            return False

        current_mode = self.get_effective_shell_mode(requested_mode=mode)
        current_scheme = self.get_effective_color_scheme(requested_scheme=scheme)
        self.set_is_bright(False)
        self.set_is_live(False)

        self.apply_colors(color=hex_color, mode=current_mode, scheme=current_scheme)
        self.update_appearance(
            current_mode, current_scheme, is_bright=False, is_live=False
        )
        self.setup_gnome_theme(current_mode)
        return True

    def handle_mode(self, mode):
        if mode == "toggle":
            self.toggle_shell_mode()
        elif mode in ("dark", "light"):
            self.set_shell_mode(mode)
        else:
            print(f"ERROR: Invalid mode '{mode}'. Use dark, light, or toggle")
            return False

        new_mode = self.get_current_shell_mode()
        color = self.looks.get("extractedColor", "")
        if color:
            self.apply_colors(color=color, mode=new_mode)
        self.setup_gnome_theme(new_mode)
        return True

    def handle_choose(self, mode=None, scheme=None):
        file_path = self.pick_file()
        if not file_path or not Path(file_path).is_file():
            print("ERROR: No file selected")
            return False
        return self.handle_set(file_path, mode=mode, scheme=scheme)

    def handle_pick(self):
        color = self.pick_color()
        if not color:
            return False
        return self.handle_color(color)


def main():
    parser = argparse.ArgumentParser(description="Noon color generation service")

    sub = parser.add_subparsers(dest="command", required=True)

    set_p = sub.add_parser("set", help="Extract and apply colors from a wallpaper")
    set_p.add_argument("file", help="Image or video path")
    set_p.add_argument("--mode", choices=["dark", "light"], help="Force shell mode")
    set_p.add_argument("--scheme", help="Force color scheme")

    color_p = sub.add_parser("color", help="Apply hex color directly")
    color_p.add_argument("hex", help="Hex colour (#RRGGBB or RRGGBB)")
    color_p.add_argument("--mode", choices=["dark", "light"], help="Force shell mode")
    color_p.add_argument("--scheme", help="Force color scheme")

    mode_p = sub.add_parser("mode", help="Set or toggle shell mode")
    mode_p.add_argument("mode", choices=["dark", "light", "toggle"])

    choose_p = sub.add_parser("choose", help="Open file picker to choose wallpaper")
    choose_p.add_argument("--mode", choices=["dark", "light"], help="Force shell mode")
    choose_p.add_argument("--scheme", help="Force color scheme")

    sub.add_parser("pick", help="Open color picker")

    args = parser.parse_args()
    switcher = WallpaperSwitcher()

    try:
        if args.command == "set":
            switcher.handle_set(args.file, mode=args.mode, scheme=args.scheme)
        elif args.command == "color":
            switcher.handle_color(args.hex, mode=args.mode, scheme=args.scheme)
        elif args.command == "mode":
            switcher.handle_mode(args.mode)
        elif args.command == "choose":
            switcher.handle_choose(mode=args.mode, scheme=args.scheme)
        elif args.command == "pick":
            switcher.handle_pick()
    except KeyboardInterrupt:
        print("\nInterrupted by user")
        sys.exit(130)
    except Exception as e:
        print(f"ERROR: Fatal error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
