import argparse
import colorsys
import json
import os
import random
import re
import shlex
import shutil
import subprocess
import sys
import tempfile
import time
from pathlib import Path

XDG_CONFIG_HOME = os.environ.get("XDG_CONFIG_HOME", os.path.expanduser("~/.config"))
XDG_CACHE_HOME = os.environ.get("XDG_CACHE_HOME", os.path.expanduser("~/.cache"))
XDG_STATE_HOME = os.environ.get("XDG_STATE_HOME", os.path.expanduser("~/.local/state"))

SHELL_STATE_FILE = Path(XDG_STATE_HOME) / "noon" / "states.json"
SCRIPT_DIR = Path(__file__).parent
TEMP_FRAME = (
    Path(XDG_STATE_HOME) / "quickshell" / "user" / "generated" / "video_frame.jpg"
)
COLOR_CACHE = Path(XDG_STATE_HOME) / "quickshell" / "user" / "generated" / "color.txt"
THUMBNAIL_SCRIPT = SCRIPT_DIR / "thumbnails_service.py"

SCHEME_VARIANT_MAP = {
    "scheme-content": 0,
    "scheme-expressive": 1,
    "scheme-fidelity": 2,
    "scheme-monochrome": 3,
    "scheme-neutral": 4,
    "scheme-tonal-spot": 5,
    "scheme-vibrant": 6,
    "scheme-rainbow": 7,
    "scheme-fruit-salad": 8,
}


class WallpaperSwitcher:
    def __init__(self):
        self.state_data = self._load_state()

    def _load_state(self):
        try:
            return json.loads(SHELL_STATE_FILE.read_text())
        except FileNotFoundError:
            return self._get_default_state()
        except json.JSONDecodeError:
            print("WARNING: State file corrupted, using defaults")
            return self._get_default_state()
        except Exception as e:
            print(f"WARNING: Error loading state: {e}")
            return self._get_default_state()

    def _get_default_state(self):
        return {
            "desktop": {
                "appearance": {
                    "mode": "dark",
                    "scheme": "scheme-tonal-spot",
                    "autoShellMode": False,
                    "autoSchemeSelection": False,
                    "isBright": False,
                },
                "bg": {"currentBg": "", "currentVideo": "", "isLive": False},
                "icons": {"currentIconTheme": "Tela"},
                "colors": {"chroma": 1.0, "tone": 1.0},
            }
        }

    def _save_state(self):
        try:
            SHELL_STATE_FILE.parent.mkdir(parents=True, exist_ok=True)
            with tempfile.NamedTemporaryFile(
                mode="w", delete=False, suffix=".json", dir=SHELL_STATE_FILE.parent
            ) as tmp:
                json.dump(self.state_data, tmp, indent=2)
                tmp_path = Path(tmp.name)
            shutil.move(tmp_path, SHELL_STATE_FILE)
        except Exception as e:
            print(f"ERROR: Failed to save state: {e}")

    def _get_state_value(self, key_path, default=None):
        keys = key_path.split(".")
        value = self.state_data
        try:
            for key in keys:
                value = value[key]
            return value if value != "null" else default
        except (KeyError, TypeError):
            return default

    def get_icon_theme(self):
        return self._get_state_value("desktop.icons.currentIconTheme", "Tela")

    def get_chroma_multiplier(self):
        try:
            return float(self._get_state_value("desktop.colors.chroma", 1.0))
        except (ValueError, TypeError):
            return 1.0

    def get_tone_multiplier(self):
        try:
            return float(self._get_state_value("desktop.colors.tone", 1.0))
        except (ValueError, TypeError):
            return 1.0

    def get_current_shell_mode(self):
        mode = self.state_data["desktop"]["appearance"]["mode"]
        return mode if mode in ("dark", "light") else "dark"

    def get_current_scheme(self):
        scheme = self.state_data["desktop"]["appearance"]["scheme"]
        return scheme or "scheme-tonal-spot"

    def get_auto_shell_mode_enabled(self):
        return bool(self._get_state_value("desktop.appearance.autoShellMode", False))

    def get_auto_scheme_selection_enabled(self):
        return bool(
            self._get_state_value("desktop.appearance.autoSchemeSelection", False)
        )

    def get_is_bright(self):
        return bool(self._get_state_value("desktop.appearance.isBright", False))

    def set_shell_mode(self, mode):
        if mode in ("dark", "light"):
            self.state_data["desktop"]["appearance"]["mode"] = mode
            self._save_state()

    def set_is_bright(self, is_bright):
        self.state_data["desktop"]["appearance"]["isBright"] = bool(is_bright)
        self._save_state()

    def toggle_shell_mode(self):
        new_mode = "light" if self.get_current_shell_mode() == "dark" else "dark"
        self.set_shell_mode(new_mode)
        return new_mode

    def update_appearance(self, mode=None, scheme=None, is_bright=None):
        if mode:
            self.state_data["desktop"]["appearance"]["mode"] = mode
        if scheme:
            self.state_data["desktop"]["appearance"]["scheme"] = scheme
        if is_bright is not None:
            self.state_data["desktop"]["appearance"]["isBright"] = bool(is_bright)
        self._save_state()

    def update_colors(self, chroma=None, tone=None):
        if chroma is not None:
            try:
                self.state_data["desktop"]["colors"]["chroma"] = float(chroma)
            except (ValueError, TypeError):
                print(f"ERROR: Invalid chroma value: {chroma}")
                return
        if tone is not None:
            try:
                self.state_data["desktop"]["colors"]["tone"] = float(tone)
            except (ValueError, TypeError):
                print(f"ERROR: Invalid tone value: {tone}")
                return
        self._save_state()

    def update_icon_theme(self, theme):
        self.state_data["desktop"]["icons"]["currentIconTheme"] = theme
        self._save_state()

    def update_bg(self, image_path="", video_path="", is_live=False):
        if image_path:
            self.state_data["desktop"]["bg"]["currentBg"] = f"file://{image_path}"
        if video_path:
            self.state_data["desktop"]["bg"]["currentVideo"] = f"file://{video_path}"
        self.state_data["desktop"]["bg"]["isLive"] = is_live
        self._save_state()

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

    def is_video(self, file_path):
        try:
            if not file_path.is_file():
                return False
            filetype = self.shell_run(
                f"file {shlex.quote(str(file_path))}", capture_output=True
            )
            video_indicators = [
                "mp4",
                "mkv",
                "avi",
                "mov",
                "webm",
                "mpeg",
                "flv",
                "matroska",
            ]
            return ("ISO Media" in filetype and "MP4" in filetype) or any(
                ext in filetype.lower() for ext in video_indicators
            )
        except Exception as e:
            print(f"ERROR: Error checking video format: {e}")
            return False

    def is_image(self, file_path):
        try:
            if not file_path.is_file():
                return False
            filetype = self.shell_run(
                f"file {shlex.quote(str(file_path))}", capture_output=True
            )
            return any(
                fmt in filetype
                for fmt in ["JPEG", "PNG", "GIF", "BMP", "TIFF", "WebP", "image"]
            )
        except Exception as e:
            print(f"ERROR: Error checking image format: {e}")
            return False

    def get_random_image(self, directory, recursive=True):
        try:
            dir_path = Path(directory).expanduser().resolve()
            if not dir_path.is_dir():
                print(f"ERROR: Directory not found: {dir_path}")
                return None

            image_exts = {".jpg", ".jpeg", ".png", ".gif", ".bmp", ".tiff", ".webp"}
            video_exts = {".mp4", ".mkv", ".avi", ".mov", ".webm", ".mpeg", ".flv"}
            valid_exts = image_exts | video_exts

            glob = dir_path.rglob("*") if recursive else dir_path.glob("*")
            files = [f for f in glob if f.is_file() and f.suffix.lower() in valid_exts]

            if not files:
                print(f"ERROR: No image or video files found in {dir_path}")
                return None

            selected = random.choice(files)
            print(f"Randomly selected: {selected.name}")
            return str(selected)
        except Exception as e:
            print(f"ERROR: Error selecting random file: {e}")
            return None

    def extract_accent_color(self, image_path):
        try:
            from PIL import Image

            with Image.open(image_path) as im:
                im = im.convert("RGB").resize((200, 200))
                quantized = im.quantize(colors=8, method=Image.Quantize.MEDIANCUT)
                palette = quantized.getpalette()

            best_color = None
            best_score = -1

            for i in range(8):
                r, g, b = palette[i * 3], palette[i * 3 + 1], palette[i * 3 + 2]
                _, s, v = colorsys.rgb_to_hsv(r / 255.0, g / 255.0, b / 255.0)
                score = s * v
                if score > best_score:
                    best_score = score
                    best_color = (r, g, b)

            if best_color:
                hex_color = "{:02X}{:02X}{:02X}".format(*best_color)
                print(f"Extracted accent: #{hex_color}")
                return hex_color

        except ImportError:
            print("WARNING: Pillow not available for color extraction")
        except Exception as e:
            print(f"WARNING: Color extraction failed: {e}")

        return None

    def apply_colors(self, source_path=None, color=None, mode=None, scheme=None):
        shell_mode = mode or self.get_current_shell_mode()
        curr_scheme = scheme or self.get_current_scheme()

        hex_color = color
        if not hex_color and source_path:
            hex_color = self.extract_accent_color(source_path)

        if not hex_color:
            print("ERROR: No color source available")
            return False

        print(f"Applying #{hex_color} | mode: {shell_mode} | scheme: {curr_scheme}")

        if shutil.which("matugen"):
            cmd = f"matugen color hex {hex_color} --mode {shell_mode}"
            if curr_scheme != "scheme-tonal-spot":
                cmd += f" --type {curr_scheme}"
            cmd += " 2>/dev/null"
            if not self.shell_run(cmd):
                print("WARNING: matugen color generation failed")
        else:
            print("WARNING: matugen not found")

        time.sleep(0.2)

        if shutil.which("kde-material-you-colors"):
            self.shell_run("killall kde-material-you-colors 2>/dev/null")
            time.sleep(0.1)

            sv_num = SCHEME_VARIANT_MAP.get(curr_scheme, 5)
            mode_flag = "-d" if shell_mode == "dark" else "-l"
            icon_theme = self.get_icon_theme()
            chroma = self.get_chroma_multiplier()
            tone = self.get_tone_multiplier()

            cmd_list = [
                "kde-material-you-colors",
                mode_flag,
                "--color",
                f"#{hex_color}",  # needs # prefix
                "--manual-fetch",  # skip plasmashell DBus wallpaper read
                "--scheme-variant",
                str(sv_num),
                "--iconslight",
                icon_theme,
                "--iconsdark",
                icon_theme,
                "--chroma-multiplier",
                str(chroma),
                "--tone-multiplier",
                str(tone),
            ]

            with open(os.devnull, "w") as devnull:
                subprocess.Popen(
                    cmd_list, stdout=devnull, stderr=devnull, start_new_session=True
                )

            print(f"KDE theme applied (chroma: {chroma}, tone: {tone})")
        else:
            print("WARNING: kde-material-you-colors not found")

        return True

    def detect_shell_mode_from_image(self, image_path):
        path = Path(image_path)
        if not path.is_file():
            return "dark", False

        try:
            from PIL import Image

            with Image.open(path) as im:
                im = im.convert("L").resize((64, 64))
                pixels = list(im.getdata())
                mean = sum(pixels) / len(pixels)
                is_bright = mean >= 127
                return ("light" if is_bright else "dark"), is_bright
        except Exception:
            pass

        try:
            if shutil.which("convert"):
                cmd = (
                    f"convert {shlex.quote(str(path))} -colorspace Gray "
                    "-format '%[fx:int(mean*255)]' info:"
                )
                out = self.shell_run(cmd, capture_output=True)
                if out:
                    mean = float(out)
                    is_bright = mean >= 127
                    return ("light" if is_bright else "dark"), is_bright
        except Exception:
            pass

        return "dark", False

    def analyze_image_color_properties(self, image_path):
        path = Path(image_path)
        if not path.is_file():
            return "scheme-tonal-spot"

        try:
            from PIL import Image, ImageStat

            with Image.open(path) as im:
                im_small = im.convert("RGB").resize((100, 100))
                pixels = list(im_small.getdata())

                saturations, hues = [], []
                for r, g, b in pixels:
                    h, s, _ = colorsys.rgb_to_hsv(r / 255.0, g / 255.0, b / 255.0)
                    saturations.append(s)
                    hues.append(h)

                if not saturations:
                    return "scheme-tonal-spot"

                avg_sat = sum(saturations) / len(saturations)
                unique_hues = len({int(h * 360) for h in hues})
                variance = sum(ImageStat.Stat(im_small).var) / 3

                if variance < 50:
                    return "scheme-monochrome"
                if avg_sat < 0.15:
                    return "scheme-neutral"
                if avg_sat > 0.6 and unique_hues > 180:
                    return "scheme-vibrant"
                if unique_hues > 260:
                    return "scheme-rainbow"
                if avg_sat > 0.45 and unique_hues > 80:
                    return "scheme-expressive"
                if unique_hues < 60:
                    return "scheme-content"
                return "scheme-tonal-spot"

        except ImportError:
            print("WARNING: Pillow not available, auto scheme selection disabled")
            return "scheme-tonal-spot"
        except Exception as e:
            print(f"WARNING: Error analysing image for scheme: {e}")
            return "scheme-tonal-spot"

    def get_effective_shell_mode(
        self, requested_mode=None, color_source_path=None, force_cli=False
    ):
        def _detect_and_store(img):
            _, is_bright = self.detect_shell_mode_from_image(img)
            self.set_is_bright(is_bright)
            return is_bright

        if force_cli and requested_mode in ("dark", "light"):
            if color_source_path:
                _detect_and_store(color_source_path)
            return requested_mode

        if requested_mode in ("dark", "light"):
            if color_source_path:
                _detect_and_store(color_source_path)
            return requested_mode

        if not self.get_auto_shell_mode_enabled():
            if color_source_path:
                _detect_and_store(color_source_path)
            return self.get_current_shell_mode()

        if color_source_path:
            detected_mode, is_bright = self.detect_shell_mode_from_image(
                color_source_path
            )
            self.set_shell_mode(detected_mode)
            self.set_is_bright(is_bright)
            return detected_mode

        try:
            current_bg = self.state_data["desktop"]["bg"]["currentBg"]
            if current_bg and current_bg.startswith("file://"):
                bg_path = Path(current_bg.replace("file://", ""))
                if bg_path.is_file() and self.is_image(bg_path):
                    detected_mode, is_bright = self.detect_shell_mode_from_image(
                        bg_path
                    )
                    self.set_shell_mode(detected_mode)
                    self.set_is_bright(is_bright)
                    return detected_mode
        except Exception:
            pass

        return "dark"

    def get_effective_color_scheme(
        self, requested_scheme=None, color_source_path=None, force_cli=False
    ):
        if force_cli and requested_scheme:
            return requested_scheme

        if self.get_auto_scheme_selection_enabled() and not force_cli:
            if color_source_path and Path(color_source_path).is_file():
                detected = self.analyze_image_color_properties(color_source_path)
                self.update_appearance(scheme=detected)
                return detected

            try:
                current_bg = self.state_data["desktop"]["bg"]["currentBg"]
                if current_bg and current_bg.startswith("file://"):
                    bg_path = Path(current_bg.replace("file://", ""))
                    if bg_path.is_file() and self.is_image(bg_path):
                        detected = self.analyze_image_color_properties(bg_path)
                        self.update_appearance(scheme=detected)
                        return detected
            except Exception:
                pass

            return self.get_current_scheme()

        return requested_scheme or self.get_current_scheme()

    def needs_icon_update(self, target_mode):
        if self.get_current_shell_mode() == target_mode:
            return False
        return any(
            shutil.which(t)
            for t in ["lookandfeeltool", "kicontool", "gtk-update-icon-cache"]
        )

    def update_icons_if_needed(self, mode):
        if not self.needs_icon_update(mode):
            return
        print(f"Updating icons for {mode} mode")
        current_theme = self.get_icon_theme()
        if shutil.which("lookandfeeltool"):
            self.shell_run(f"lookandfeeltool -i {current_theme}")
        elif shutil.which("gtk-update-icon-cache"):
            self.shell_run(f"gtk-update-icon-cache -f /usr/share/icons/{current_theme}")

    def setup_gnome_theme(self, mode=None):
        if not mode:
            return
        try:
            scheme_val = "prefer-dark" if mode == "dark" else "prefer-light"
            ok = self.shell_run(
                f"gsettings set org.gnome.desktop.interface color-scheme '{scheme_val}' 2>/dev/null"
            )
            print(
                f"GNOME theme set to {mode}"
                if ok
                else "WARNING: Could not set GNOME theme"
            )
        except Exception as e:
            print(f"WARNING: GNOME theme setup error: {e}")

    def kill_mpvpaper(self):
        try:
            self.shell_run("pkill -9 mpvpaper 2>/dev/null")
        except Exception as e:
            print(f"ERROR: Failed to kill mpvpaper: {e}")

    def play_video_wallpaper(self, video_path):
        try:
            self.kill_mpvpaper()
            time.sleep(0.2)
            cmd = (
                f"nohup mpvpaper '*' {shlex.quote(str(video_path))} "
                "-o 'no-audio loop-file=inf' >/dev/null 2>&1 &"
            )
            if self.shell_run(cmd):
                print(f"Playing video wallpaper: {Path(video_path).name}")
            else:
                print(f"ERROR: Failed to play video: {video_path}")
        except Exception as e:
            print(f"ERROR: Video wallpaper error: {e}")

    def extract_video_frame(self, video_path):
        try:
            TEMP_FRAME.parent.mkdir(parents=True, exist_ok=True)

            if not shutil.which("ffmpeg"):
                print("ERROR: ffmpeg not found")
                return False
            if not shutil.which("ffprobe"):
                print("ERROR: ffprobe not found")
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
                    print(f"Extracted frame at {label}")
                    return True

            print("ERROR: Failed to extract video frame")
            return False
        except Exception as e:
            print(f"ERROR: Error extracting video frame: {e}")
            return False

    def restore_live(self):
        try:
            video = self.state_data["desktop"]["bg"]["currentVideo"]
            is_live = self.state_data["desktop"]["bg"]["isLive"]

            if video and is_live and video.startswith("file://"):
                video_path = Path(video.replace("file://", ""))
                if video_path.is_file():
                    print(f"Restoring live: {video_path.name}")
                    self.play_video_wallpaper(video_path)
                    return True
                print(f"ERROR: Video file not found: {video_path}")
            else:
                print("INFO: No live video in state")
            return False
        except Exception as e:
            print(f"ERROR: Error restoring live video: {e}")
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
                        print(f"Color picked: #{color}")
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
                        print(f"File selected: {Path(result).name}")
                        return result

            user_input = input(f"Wallpaper path (default: {pictures}): ").strip()
            return user_input if user_input else str(pictures)
        except Exception as e:
            print(f"ERROR: File picker error: {e}")
            return None

    def generate_thumbnails(self, directory, size="large", workers=4, recursive=True):
        try:
            if not THUMBNAIL_SCRIPT.is_file():
                print(f"ERROR: Thumbnail script not found at {THUMBNAIL_SCRIPT}")
                return False

            dir_path = Path(directory).expanduser().resolve()
            if not dir_path.is_dir():
                print(f"ERROR: Directory not found: {dir_path}")
                return False

            print(f"\n--- Generating Thumbnails ---")
            print(f"Directory: {dir_path}")
            print(f"Size: {size} | Workers: {workers} | Recursive: {recursive}")

            cmd = [
                sys.executable,
                str(THUMBNAIL_SCRIPT),
                "-d",
                str(dir_path),
                "-s",
                size,
                "-w",
                str(workers),
                "-i",
            ]
            if recursive:
                cmd.append("-r")

            result = subprocess.run(cmd, cwd=SCRIPT_DIR)
            if result.returncode == 0:
                print("Thumbnails generated successfully\n")
                return True
            print(
                f"WARNING: Thumbnail generation had issues (code: {result.returncode})\n"
            )
            return False
        except Exception as e:
            print(f"ERROR: Thumbnail generation error: {e}\n")
            return False

    def switch(
        self,
        imgpath,
        mode=None,
        scheme=None,
        color=None,
        force_cli=False,
        color_source_override=None,
    ):
        try:
            if color:
                print("\n--- Color Mode ---")
                if color_source_override:
                    print("INFO: --extract-col-from is ignored in color mode")

                current_mode = self.get_effective_shell_mode(
                    requested_mode=mode, force_cli=force_cli
                )
                current_scheme = self.get_effective_color_scheme(
                    requested_scheme=scheme, force_cli=force_cli
                )
                self.set_is_bright(False)

                print(
                    f"Color: #{color} | Mode: {current_mode} | Scheme: {current_scheme}"
                )
                self.apply_colors(color=color, mode=current_mode, scheme=current_scheme)
                self.update_appearance(current_mode, current_scheme, is_bright=False)
                self.setup_gnome_theme(current_mode)
                self.update_icons_if_needed(current_mode)
                print("Color mode complete\n")
                return

            if not imgpath or not Path(imgpath).is_file():
                print(f"ERROR: Invalid file path: {imgpath}")
                return

            imgpath = Path(imgpath)
            is_vid = self.is_video(imgpath)

            if is_vid:
                print("\n--- Video Wallpaper ---")
                print(f"File: {imgpath.name}")
                self.update_bg(video_path=str(imgpath), is_live=True)
                self.play_video_wallpaper(imgpath)

                if color_source_override:
                    override = Path(color_source_override)
                    if override.is_file():
                        color_source = override
                        print(
                            f"Color source: {color_source.name} (override — skipping ffmpeg)"
                        )
                    else:
                        print(
                            "WARNING: --extract-col-from path not found, falling back to frame extraction"
                        )
                        if not self.extract_video_frame(imgpath):
                            print("WARNING: Skipping colour generation (no frame)")
                            return
                        color_source = TEMP_FRAME
                else:
                    if not self.extract_video_frame(imgpath):
                        print("WARNING: Skipping colour generation (no frame)")
                        return
                    color_source = TEMP_FRAME

            else:
                print("\n--- Image Wallpaper ---")
                print(f"File: {imgpath.name}")
                self.kill_mpvpaper()
                self.update_bg(image_path=str(imgpath), is_live=False)

                if color_source_override:
                    override = Path(color_source_override)
                    if override.is_file():
                        color_source = override
                        print(f"Color source: {color_source.name} (override)")
                    else:
                        print(
                            "WARNING: --extract-col-from path not found, falling back to wallpaper"
                        )
                        color_source = imgpath
                else:
                    color_source = imgpath

            current_mode = self.get_effective_shell_mode(
                requested_mode=mode,
                color_source_path=str(color_source),
                force_cli=force_cli,
            )
            current_scheme = self.get_effective_color_scheme(
                requested_scheme=scheme,
                color_source_path=str(color_source),
                force_cli=force_cli,
            )
            is_bright = self.get_is_bright()

            print(
                f"Mode: {current_mode} | Scheme: {current_scheme} | Bright: {is_bright}"
            )

            if not self.is_image(color_source):
                print(f"ERROR: Colour source is not a valid image: {color_source}")
                return

            self.apply_colors(
                source_path=str(color_source),
                mode=current_mode,
                scheme=current_scheme,
            )
            self.update_appearance(current_mode, current_scheme, is_bright=is_bright)
            self.setup_gnome_theme(current_mode)
            self.update_icons_if_needed(current_mode)
            print("Wallpaper switch complete\n")

        except Exception as e:
            print(f"ERROR: Error during switch: {e}\n")


def main():
    parser = argparse.ArgumentParser(
        description="Wallpaper switcher with unified colour generation"
    )

    parser.add_argument("--mode", help="Shell mode (dark / light / toggle)")
    parser.add_argument("--scheme", help="Colour scheme (matugen scheme name)")
    parser.add_argument(
        "-f",
        "--force",
        action="store_true",
        help="Force CLI arguments to override automatic mode / scheme detection",
    )

    parser.add_argument("--image", "-i", help="Image or video path")
    parser.add_argument("--color", "-c", help="Hex colour (#RRGGBB or RRGGBB)")
    parser.add_argument("--pick", "-p", action="store_true", help="Open colour picker")
    parser.add_argument(
        "--random", "-R", metavar="DIR", help="Pick a random image/video from directory"
    )
    parser.add_argument(
        "--random-no-recursive",
        action="store_true",
        help="Don't recurse subdirectories for random selection",
    )
    parser.add_argument(
        "--noswitch",
        action="store_true",
        help="Use current wallpaper from state (reapply colours only)",
    )
    parser.add_argument(
        "--extract-col-from",
        metavar="FILE",
        help="Small image used exclusively for accent colour extraction",
    )

    parser.add_argument(
        "--restore-live",
        "-r",
        action="store_true",
        help="Restore last live video wallpaper",
    )
    parser.add_argument(
        "--gen-thumbnails",
        "-g",
        metavar="DIR",
        help="Generate thumbnails for directory",
    )
    parser.add_argument(
        "--thumb-size",
        default="large",
        choices=["normal", "large", "x-large", "xx-large"],
        help="Thumbnail size (default: large)",
    )
    parser.add_argument(
        "--thumb-workers",
        type=int,
        default=4,
        help="CPU workers for thumbnail generation (default: 4)",
    )
    parser.add_argument(
        "--thumb-no-recursive",
        action="store_true",
        help="Don't recurse subdirectories for thumbnails",
    )

    args, remaining = parser.parse_known_args()
    switcher = WallpaperSwitcher()

    print("\nNoon Appearance CLI")
    print(f"Current mode:           {switcher.get_current_shell_mode()}")
    print(f"Current scheme:         {switcher.get_current_scheme()}")
    print(f"Current isBright:       {switcher.get_is_bright()}")
    print(
        f"Auto shell mode:        {'enabled' if switcher.get_auto_shell_mode_enabled() else 'disabled'}"
    )
    print(
        f"Auto scheme selection:  {'enabled' if switcher.get_auto_scheme_selection_enabled() else 'disabled'}"
    )
    if args.force:
        print("Force CLI args:         enabled")
    print()

    try:
        if args.mode and args.mode.lower() == "toggle":
            new_mode = switcher.toggle_shell_mode()
            print(f"Mode toggled to: {new_mode}")
            imgpath = switcher.state_data["desktop"]["bg"]["currentBg"].replace(
                "file://", ""
            )
            if imgpath and Path(imgpath).is_file():
                print(f"Applying to current wallpaper: {Path(imgpath).name}\n")
                switcher.switch(
                    imgpath,
                    mode=new_mode,
                    force_cli=True,
                    color_source_override=args.extract_col_from,
                )
            else:
                print("No current wallpaper to apply mode to\n")
            sys.exit(0)

        if args.gen_thumbnails:
            switcher.generate_thumbnails(
                args.gen_thumbnails,
                size=args.thumb_size,
                workers=args.thumb_workers,
                recursive=not args.thumb_no_recursive,
            )
            sys.exit(0)

        if args.restore_live:
            switcher.restore_live()
            sys.exit(0)

        mode_arg = None
        if args.mode:
            if args.mode.lower() in ("dark", "light"):
                mode_arg = args.mode.lower()
            else:
                print(f"ERROR: Invalid mode '{args.mode}'. Use dark, light, or toggle")
                sys.exit(1)

        if args.random:
            imgpath = switcher.get_random_image(
                args.random, recursive=not args.random_no_recursive
            )
            if not imgpath:
                sys.exit(1)
        else:
            imgpath = args.image or (remaining[0] if remaining else "")
            if args.noswitch:
                imgpath = switcher.state_data["desktop"]["bg"]["currentBg"].replace(
                    "file://", ""
                )
                if imgpath:
                    print(f"INFO: Using current wallpaper: {Path(imgpath).name}\n")

        if args.pick or args.color:
            if args.extract_col_from:
                print("INFO: --extract-col-from is ignored in colour/picker mode")
            color = args.color
            if color:
                if re.match(r"^#?[A-Fa-f0-9]{6}$", color):
                    color = color.lstrip("#")
                else:
                    print("ERROR: Invalid colour format (use #RRGGBB or RRGGBB)")
                    sys.exit(1)
            else:
                color = switcher.pick_color()
                if not color:
                    sys.exit(1)
            switcher.switch(
                "", mode_arg, args.scheme, color=color, force_cli=args.force
            )
            sys.exit(0)

        if not imgpath:
            imgpath = switcher.pick_file()
            if not imgpath or not Path(imgpath).is_file():
                print("ERROR: No file selected")
                sys.exit(1)

        switcher.switch(
            imgpath,
            mode_arg,
            args.scheme,
            force_cli=args.force,
            color_source_override=args.extract_col_from,
        )
        sys.exit(0)

    except KeyboardInterrupt:
        print("\nInterrupted by user")
        sys.exit(130)
    except Exception as e:
        print(f"ERROR: Fatal error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
