import argparse
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

# Constants
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

# Scheme variant mapping for kde-material-you-colors
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
        """Load state from JSON file"""
        try:
            data = json.loads(SHELL_STATE_FILE.read_text())
            return data
        except FileNotFoundError:
            return self._get_default_state()
        except json.JSONDecodeError:
            print("WARNING: State file corrupted, using defaults")
            return self._get_default_state()
        except Exception as e:
            print(f"WARNING: Error loading state: {e}")
            return self._get_default_state()

    def _get_default_state(self):
        """Get default state structure"""
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
        """Save state to JSON file with atomic write"""
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
        """Get value from state using dot notation

        Example: _get_state_value("desktop.icons.currentIconTheme", "Tela")
        """
        keys = key_path.split(".")
        value = self.state_data
        try:
            for key in keys:
                value = value[key]
            return value if value != "null" else default
        except (KeyError, TypeError):
            return default

    def get_icon_theme(self):
        """Get icon theme from state"""
        return self._get_state_value("desktop.icons.currentIconTheme", "Tela")

    def get_chroma_multiplier(self):
        """Get chroma multiplier from state"""
        chroma = self._get_state_value("desktop.colors.chroma", 1.0)
        try:
            return float(chroma)
        except (ValueError, TypeError):
            return 1.0

    def get_tone_multiplier(self):
        """Get tone multiplier (brightness) from state"""
        tone = self._get_state_value("desktop.colors.tone", 1.0)
        try:
            return float(tone)
        except (ValueError, TypeError):
            return 1.0

    def get_current_shell_mode(self):
        """Get current shell mode (dark/light)"""
        mode = self.state_data["desktop"]["appearance"]["mode"]
        return mode if mode in ["dark", "light"] else "dark"

    def get_current_scheme(self):
        """Get current color scheme"""
        scheme = self.state_data["desktop"]["appearance"]["scheme"]
        return scheme if scheme else "scheme-tonal-spot"

    def get_auto_shell_mode_enabled(self):
        """Return whether automatic shell mode is enabled"""
        return bool(self._get_state_value("desktop.appearance.autoShellMode", False))

    def get_auto_scheme_selection_enabled(self):
        """Return whether automatic scheme selection is enabled"""
        return bool(
            self._get_state_value(
                "desktop.appearance.autoSchemeSelection",
                False,
            )
        )

    def get_is_bright(self):
        """Get isBright value from state"""
        return bool(self._get_state_value("desktop.appearance.isBright", False))

    def set_shell_mode(self, mode):
        """Set shell mode explicitly"""
        if mode in ("dark", "light"):
            self.state_data["desktop"]["appearance"]["mode"] = mode
            self._save_state()

    def set_is_bright(self, is_bright):
        """Set isBright value in state"""
        self.state_data["desktop"]["appearance"]["isBright"] = bool(is_bright)
        self._save_state()

    def toggle_shell_mode(self):
        """Toggle between dark and light mode"""
        current = self.get_current_shell_mode()
        new_mode = "light" if current == "dark" else "dark"
        self.set_shell_mode(new_mode)
        return new_mode

    def update_appearance(self, mode=None, scheme=None, is_bright=None):
        """Update appearance settings"""
        if mode:
            self.state_data["desktop"]["appearance"]["mode"] = mode
        if scheme:
            self.state_data["desktop"]["appearance"]["scheme"] = scheme
        if is_bright is not None:
            self.state_data["desktop"]["appearance"]["isBright"] = bool(is_bright)
        self._save_state()

    def update_colors(self, chroma=None, tone=None):
        """Update color multipliers"""
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
        """Update icon theme"""
        self.state_data["desktop"]["icons"]["currentIconTheme"] = theme
        self._save_state()

    def update_bg(self, image_path="", video_path="", is_live=False):
        """Update background settings"""
        if image_path:
            self.state_data["desktop"]["bg"]["currentBg"] = f"file://{image_path}"
        if video_path:
            self.state_data["desktop"]["bg"]["currentVideo"] = f"file://{video_path}"
        self.state_data["desktop"]["bg"]["isLive"] = is_live
        self._save_state()

    def shell_run(self, cmd, capture_output=False):
        """Execute shell command with error handling"""
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

    def get_random_image(self, directory, recursive=True):
        """Get a random image or video file from directory"""
        try:
            dir_path = Path(directory).expanduser().resolve()
            if not dir_path.is_dir():
                print(f"ERROR: Directory not found: {dir_path}")
                return None

            # Supported image and video extensions
            image_exts = {".jpg", ".jpeg", ".png", ".gif", ".bmp", ".tiff", ".webp"}
            video_exts = {".mp4", ".mkv", ".avi", ".mov", ".webm", ".mpeg", ".flv"}
            valid_exts = image_exts | video_exts

            # Collect all valid files
            files = []
            if recursive:
                for file_path in dir_path.rglob("*"):
                    if file_path.is_file() and file_path.suffix.lower() in valid_exts:
                        files.append(file_path)
            else:
                for file_path in dir_path.glob("*"):
                    if file_path.is_file() and file_path.suffix.lower() in valid_exts:
                        files.append(file_path)

            if not files:
                print(f"ERROR: No image or video files found in {dir_path}")
                return None

            # Pick a random file
            selected = random.choice(files)
            print(f"Randomly selected: {selected.name}")
            return str(selected)

        except Exception as e:
            print(f"ERROR: Error selecting random file: {e}")
            return None

    def generate_thumbnails(self, directory, size="large", workers=4, recursive=True):
        """Generate thumbnails for wallpaper directory"""
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
                "-i",  # Only images
            ]

            if recursive:
                cmd.append("-r")

            result = subprocess.run(cmd, cwd=SCRIPT_DIR)

            if result.returncode == 0:
                print(f"Thumbnails generated successfully\n")
                return True
            else:
                print(
                    f"WARNING: Thumbnail generation had issues (code: {result.returncode})\n"
                )
                return False

        except Exception as e:
            print(f"ERROR: Thumbnail generation error: {e}\n")
            return False

    def kill_mpvpaper(self):
        """Kill running mpvpaper instances"""
        try:
            self.shell_run("pkill -9 mpvpaper 2>/dev/null")
        except Exception as e:
            print(f"ERROR: Failed to kill mpvpaper: {e}")

    def play_video_wallpaper(self, video_path):
        """Play video as wallpaper using mpvpaper"""
        try:
            self.kill_mpvpaper()
            time.sleep(0.2)
            cmd = (
                "nohup mpvpaper '*' "
                f"{shlex.quote(str(video_path))} "
                "-o 'no-audio loop-file=inf' >/dev/null 2>&1 &"
            )
            if self.shell_run(cmd):
                print(f"Playing video wallpaper: {Path(video_path).name}")
            else:
                print(f"ERROR: Failed to play video: {video_path}")
        except Exception as e:
            print(f"ERROR: Video wallpaper error: {e}")

    def is_video(self, file_path):
        """Check if file is a video"""
        try:
            if not file_path.is_file():
                return False
            filetype = self.shell_run(
                f"file {shlex.quote(str(file_path))}",
                capture_output=True,
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
        """Check if file is an image"""
        try:
            if not file_path.is_file():
                return False
            filetype = self.shell_run(
                f"file {shlex.quote(str(file_path))}", capture_output=True
            )
            image_formats = ["JPEG", "PNG", "GIF", "BMP", "TIFF", "WebP", "image"]
            return any(fmt in filetype for fmt in image_formats)
        except Exception as e:
            print(f"ERROR: Error checking image format: {e}")
            return False

    def detect_shell_mode_from_image(self, image_path):
        """Detect brightness and return both mode and isBright value.

        Returns tuple: (mode_string, is_bright_bool)
        """
        path = Path(image_path)
        if not path.is_file():
            return "dark", False

        # Try using Pillow if installed
        try:
            from PIL import Image  # type: ignore

            with Image.open(path) as im:
                im = im.convert("L")  # grayscale
                im = im.resize((64, 64))
                pixels = list(im.get_flattened_data())
                mean = sum(pixels) / len(pixels)
                is_bright = mean >= 127
                mode = "light" if is_bright else "dark"
                return mode, is_bright
        except Exception:
            pass

        # Fallback: try ImageMagick convert if available
        try:
            if shutil.which("convert"):
                cmd = (
                    f"convert {shlex.quote(str(path))} -colorspace Gray "
                    "-format '%[fx:int(mean*255)]' info:"
                )
                out = self.shell_run(cmd, capture_output=True)
                if out:
                    try:
                        mean = float(out)
                        is_bright = mean >= 127
                        mode = "light" if is_bright else "dark"
                        return mode, is_bright
                    except ValueError:
                        pass
        except Exception:
            pass

        return "dark", False

    def analyze_image_color_properties(self, image_path):
        """
        Analyze image to select a Matugen scheme automatically.

        Uses saturation, hue diversity, and variance to map to:
        - scheme-monochrome
        - scheme-neutral
        - scheme-vibrant
        - scheme-rainbow
        - scheme-expressive
        - scheme-content
        - scheme-tonal-spot (fallback)
        """
        path = Path(image_path)
        if not path.is_file():
            return "scheme-tonal-spot"

        try:
            import colorsys

            from PIL import Image, ImageStat  # type: ignore

            with Image.open(path) as im:
                im_small = im.convert("RGB").resize((100, 100))
                pixels = list(im_small.get_flattened_data())

                saturations = []
                hues = []
                for r, g, b in pixels:
                    h, s, v = colorsys.rgb_to_hsv(
                        r / 255.0,
                        g / 255.0,
                        b / 255.0,
                    )
                    saturations.append(s)
                    hues.append(h)

                if not saturations:
                    return "scheme-tonal-spot"

                avg_saturation = sum(saturations) / len(saturations)
                unique_hues = len(set(int(h * 360) for h in hues))

                stat = ImageStat.Stat(im_small)
                variance = sum(stat.var) / len(stat.var)

                if variance < 50:
                    return "scheme-monochrome"
                if avg_saturation < 0.15:
                    return "scheme-neutral"
                if avg_saturation > 0.6 and unique_hues > 180:
                    return "scheme-vibrant"
                if unique_hues > 260:
                    return "scheme-rainbow"
                if avg_saturation > 0.45 and unique_hues > 80:
                    return "scheme-expressive"
                if unique_hues < 60:
                    return "scheme-content"

                return "scheme-tonal-spot"

        except ImportError:
            print("WARNING: Pillow not available, auto scheme selection disabled")
            return "scheme-tonal-spot"
        except Exception as e:
            print(f"WARNING: Error analyzing image for scheme: {e}")
            return "scheme-tonal-spot"

    def get_effective_shell_mode(
        self, requested_mode=None, color_source_path=None, force_cli=False
    ):
        """
        Decide which shell mode to use, respecting autoShellMode.
        Also sets isBright in state based on detection.

        requested_mode: explicit mode from CLI (--mode)
        color_source_path: image path used for colors (wallpaper or extracted frame)
        force_cli: if True, CLI args override auto settings

        Returns: mode string
        """
        # Explicit CLI mode with -f flag always wins
        if force_cli and requested_mode in ("dark", "light"):
            # Even with forced mode, still detect brightness for isBright
            if color_source_path:
                _, is_bright = self.detect_shell_mode_from_image(color_source_path)
                self.set_is_bright(is_bright)
            return requested_mode

        # Explicit CLI mode always wins
        if requested_mode in ("dark", "light"):
            # Still detect brightness for isBright
            if color_source_path:
                _, is_bright = self.detect_shell_mode_from_image(color_source_path)
                self.set_is_bright(is_bright)
            return requested_mode

        if not self.get_auto_shell_mode_enabled():
            # Auto mode disabled: use stored mode
            # But still update isBright if we have an image
            if color_source_path:
                _, is_bright = self.detect_shell_mode_from_image(color_source_path)
                self.set_is_bright(is_bright)
            return self.get_current_shell_mode()

        # Auto mode enabled: try to infer from image
        if color_source_path:
            detected_mode, is_bright = self.detect_shell_mode_from_image(
                color_source_path
            )
            self.set_shell_mode(detected_mode)
            self.set_is_bright(is_bright)
            return detected_mode

        # No color_source_path provided, try current wallpaper
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
        """
        Decide which scheme to use, respecting autoSchemeSelection.

        When autoSchemeSelection is enabled, the detected scheme from the image
        will override any explicit --scheme argument unless force_cli is True.

        force_cli: if True, CLI args override auto settings
        """
        # Force CLI argument to override auto detection
        if force_cli and requested_scheme:
            return requested_scheme

        auto_enabled = self.get_auto_scheme_selection_enabled()

        if auto_enabled and not force_cli:
            # Need an image to analyze. If none is given, try current wallpaper.
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

            # If auto enabled but cannot analyze, fallback to stored or default
            return self.get_current_scheme()

        # Auto disabled: explicit CLI scheme wins, else stored scheme
        if requested_scheme:
            return requested_scheme
        return self.get_current_scheme()

    def extract_video_frame(self, video_path):
        """Extract a frame from video for color generation"""
        try:
            TEMP_FRAME.parent.mkdir(parents=True, exist_ok=True)

            if not shutil.which("ffmpeg"):
                print("ERROR: ffmpeg not found")
                return False

            if not shutil.which("ffprobe"):
                print("ERROR: ffprobe not found")
                return False

            # Get video duration
            duration = self.shell_run(
                f"ffprobe -v quiet -show_entries format=duration -of csv=p=0 {shlex.quote(str(video_path))}",
                capture_output=True,
            )
            frame_time = 10.0
            if duration:
                try:
                    total_sec = float(duration)
                    frame_time = max(1.0, min(total_sec * 0.5, 10.0))
                except ValueError:
                    pass

            # Try extracting at calculated time
            cmd = (
                f"ffmpeg -ss {frame_time} -i {shlex.quote(str(video_path))} "
                f"-vframes 1 -q:v 2 {shlex.quote(str(TEMP_FRAME))} -y 2>/dev/null"
            )
            if (
                self.shell_run(cmd)
                and TEMP_FRAME.is_file()
                and TEMP_FRAME.stat().st_size > 1000
            ):
                print(f"Extracted frame at {frame_time:.1f}s")
                return True

            # Fallback: extract from start
            cmd = (
                f"ffmpeg -ss 0.1 -i {shlex.quote(str(video_path))} "
                f"-vframes 1 -q:v 2 {shlex.quote(str(TEMP_FRAME))} -y 2>/dev/null"
            )
            if (
                self.shell_run(cmd)
                and TEMP_FRAME.is_file()
                and TEMP_FRAME.stat().st_size > 1000
            ):
                print("Extracted frame at 0.1s (fallback)")
                return True

            print("ERROR: Failed to extract video frame")
            return False
        except Exception as e:
            print(f"ERROR: Error extracting video frame: {e}")
            return False

    def generate_colors(self, source_path, mode=None, scheme=None):
        """Generate colors from image or hex color using matugen"""
        if not shutil.which("matugen"):
            print("ERROR: matugen not found")
            return False

        try:
            shell_mode = mode or self.get_current_shell_mode()
            current_scheme = scheme or self.get_current_scheme()
            source_str = str(source_path)

            # Build matugen command
            if source_str.startswith("color hex"):
                color_val = source_str.split()[-1]
                cmd = f"matugen color hex {color_val} --mode {shell_mode}"
                print(f"Generating from color: #{color_val}")
            else:
                cmd = f"matugen image --source-color-index 0 --mode {shell_mode} {shlex.quote(source_str)}"
                print(f"Generating from: {Path(source_str).name}")

            # Add type (scheme) if available
            if current_scheme and current_scheme != "scheme-tonal-spot":
                cmd += f" --type {current_scheme}"

            cmd += " 2>/dev/null"
            if self.shell_run(cmd):
                print(
                    f"Colors generated (mode: {shell_mode}, scheme: {current_scheme})"
                )
                return True
            else:
                print("ERROR: Color generation failed")
                return False
        except Exception as e:
            print(f"ERROR: Error generating colors: {e}")
            return False

    def needs_icon_update(self, target_mode):
        """Check if icons need updating for current mode"""
        current_mode = self.get_current_shell_mode()
        if current_mode == target_mode:
            return False

        # Check if we have icon tools available
        return any(
            shutil.which(tool)
            for tool in ["lookandfeeltool", "kicontool", "gtk-update-icon-cache"]
        )

    def update_icons_if_needed(self, mode):
        """Update icons ONLY when mode changes and tools available"""
        if not self.needs_icon_update(mode):
            return

        print(f"Updating icons for {mode} mode")
        current_theme = self.get_icon_theme()

        # KDE Plasma
        if shutil.which("lookandfeeltool"):
            icon_cmd = f"lookandfeeltool -i {current_theme}"
            self.shell_run(icon_cmd)

        # GTK fallback
        elif shutil.which("gtk-update-icon-cache"):
            self.shell_run(f"gtk-update-icon-cache -f /usr/share/icons/{current_theme}")

    def apply_kde_colors(self, source_path=None, color=None, scheme=None):
        """Apply colors to KDE using kde-material-you-colors"""
        try:
            if not shutil.which("kde-material-you-colors"):
                print("WARNING: kde-material-you-colors not found")
                return False

            self.shell_run("killall kde-material-you-colors 2>/dev/null")
            time.sleep(0.1)

            current_scheme = scheme or self.get_current_scheme()
            current_mode = self.get_current_shell_mode()
            icon_theme = self.get_icon_theme()
            chroma = self.get_chroma_multiplier()
            tone = self.get_tone_multiplier()
            sv_num = SCHEME_VARIANT_MAP.get(current_scheme, 5)
            mode_flag = "-d" if current_mode == "dark" else "-l"

            cmd_list = [
                "kde-material-you-colors",
                mode_flag,
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

            if color:
                cmd_list.extend(["--color", color])
            elif source_path and Path(source_path).is_file():
                cmd_list.extend(["--file", str(source_path)])
            else:
                print("ERROR: No valid color source for KDE")
                return False

            with open(os.devnull, "w") as devnull:
                subprocess.Popen(
                    cmd_list, stdout=devnull, stderr=devnull, start_new_session=True
                )

            print(f"KDE theme applied (chroma: {chroma}, tone: {tone})")
            return True
        except Exception as e:
            print(f"WARNING: Error applying KDE colors: {e}")
            return True

    def setup_gnome_theme(self, mode=None):
        """Setup GNOME/GTK theme based on mode"""
        try:
            if not mode:
                return

            cache_dir = Path(XDG_CACHE_HOME) / "quickshell" / "user" / "generated"
            cache_dir.mkdir(parents=True, exist_ok=True)

            if mode == "dark":
                if self.shell_run(
                    "gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null"
                ):
                    print("GNOME theme set to dark")
                else:
                    print("WARNING: Could not set GNOME theme")
            elif mode == "light":
                if self.shell_run(
                    "gsettings set org.gnome.desktop.interface color-scheme 'prefer-light' 2>/dev/null"
                ):
                    print("GNOME theme set to light")
                else:
                    print("WARNING: Could not set GNOME theme")
        except Exception as e:
            print(f"WARNING: GNOME theme setup error: {e}")

    def restore_live(self):
        """Restore last live video wallpaper"""
        try:
            video = self.state_data["desktop"]["bg"]["currentVideo"]
            is_live = self.state_data["desktop"]["bg"]["isLive"]

            if video and is_live and video.startswith("file://"):
                video_path = Path(video.replace("file://", ""))
                if video_path.is_file():
                    print(f"Restoring live: {video_path.name}")
                    self.play_video_wallpaper(video_path)
                    return True
                else:
                    print(f"ERROR: Video file not found: {video_path}")
            else:
                print("INFO: No live video in state")

            return False
        except Exception as e:
            print(f"ERROR: Error restoring live video: {e}")
            return False

    def pick_color(self):
        """Open color picker"""
        try:
            color_pickers = [
                ("hyprpicker", "hyprpicker --no-fancy"),
                ("kdialog", "kdialog --getcolor 'Pick color'"),
                ("zenity", "zenity --color-selection"),
            ]

            for name, picker in color_pickers:
                if shutil.which(name):
                    result = self.shell_run(picker, capture_output=True)
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
        """Open file picker for wallpaper selection"""
        try:
            pictures = Path.home() / "Pictures"

            for subdir in ["Wallpapers/showcase", "Wallpapers", ""]:
                candidate = pictures / subdir
                if candidate.exists():
                    pictures = candidate
                    break

            file_pickers = [
                (
                    "kdialog",
                    f'kdialog --getopenfilename "{pictures}" --title "Choose wallpaper"',
                ),
                ("zenity", f'zenity --file-selection --filename="{pictures}"'),
            ]

            for name, picker in file_pickers:
                if shutil.which(name):
                    result = self.shell_run(picker, capture_output=True)
                    if result and Path(result).is_file():
                        print(f"File selected: {Path(result).name}")
                        return result

            user_input = input(f"Wallpaper path (default: {pictures}): ").strip()
            return user_input if user_input else str(pictures)
        except Exception as e:
            print(f"ERROR: File picker error: {e}")
            return None

    def switch(self, imgpath, mode=None, scheme=None, color=None, force_cli=False):
        """Switch wallpaper and colors

        force_cli: if True, CLI arguments override automatic settings
        """
        try:
            # COLOR MODE
            if color:
                print("\n--- Color Mode ---")
                # Decide mode for color mode (no image)
                current_mode = self.get_effective_shell_mode(
                    requested_mode=mode,
                    color_source_path=None,
                    force_cli=force_cli,
                )

                # For color mode, scheme comes from autoSchemeSelection if enabled,
                # otherwise use explicit or stored scheme.
                current_scheme = self.get_effective_color_scheme(
                    requested_scheme=scheme,
                    color_source_path=None,
                    force_cli=force_cli,
                )

                # Set isBright to False for color mode (no wallpaper to analyze)
                self.set_is_bright(False)

                print(f"Color: #{color}")
                print(f"Mode: {current_mode} | Scheme: {current_scheme}")
                self.generate_colors(
                    f"color hex {color}",
                    current_mode,
                    current_scheme,
                )
                self.update_appearance(current_mode, current_scheme, is_bright=False)
                time.sleep(0.3)
                self.apply_kde_colors(color=color, scheme=current_scheme)
                self.setup_gnome_theme(current_mode)
                self.update_icons_if_needed(current_mode)
                print("Color mode complete\n")
                return

            # WALLPAPER MODE
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

                if not self.extract_video_frame(imgpath):
                    print("WARNING: Skipping color generation (no frame)")
                    return

                color_source = TEMP_FRAME
            else:
                print("\n--- Image Wallpaper ---")
                print(f"File: {imgpath.name}")
                self.kill_mpvpaper()
                self.update_bg(image_path=str(imgpath), is_live=False)
                color_source = imgpath

            # Get effective mode and scheme (this also sets isBright)
            current_mode = self.get_effective_shell_mode(
                requested_mode=mode,
                color_source_path=color_source,
                force_cli=force_cli,
            )
            current_scheme = self.get_effective_color_scheme(
                requested_scheme=scheme,
                color_source_path=color_source,
                force_cli=force_cli,
            )

            is_bright = self.get_is_bright()
            print(
                f"Mode: {current_mode} | Scheme: {current_scheme} | Bright: {is_bright}"
            )

            if not self.is_image(color_source):
                print(f"ERROR: Invalid image: {color_source}")
                return

            self.generate_colors(color_source, current_mode, current_scheme)
            self.update_appearance(current_mode, current_scheme, is_bright=is_bright)
            self.apply_kde_colors(
                source_path=str(color_source),
                scheme=current_scheme,
            )
            self.setup_gnome_theme(current_mode)
            self.update_icons_if_needed(current_mode)
            print("Wallpaper switch complete\n")
        except Exception as e:
            print(f"ERROR: Error during switch: {e}\n")


def main():
    parser = argparse.ArgumentParser(
        description="Wallpaper switcher with color generation"
    )
    parser.add_argument(
        "--mode",
        help="Shell mode (dark/light/toggle). Use 'toggle' to switch modes",
    )
    parser.add_argument(
        "--scheme",
        help="Color scheme (matugen scheme name)",
    )
    parser.add_argument(
        "-f",
        "--force",
        action="store_true",
        help="Force CLI arguments to override automatic mode/scheme detection",
    )
    parser.add_argument("--pick", "-p", action="store_true", help="Open color picker")
    parser.add_argument("--color", "-c", help="Hex color (#RRGGBB or RRGGBB)")
    parser.add_argument("--image", "-i", help="Image path")
    parser.add_argument(
        "--random",
        "-R",
        metavar="DIR",
        help="Pick a random image/video from directory",
    )
    parser.add_argument(
        "--random-no-recursive",
        action="store_true",
        help="Don't recursively search subdirectories for random selection",
    )
    parser.add_argument(
        "--noswitch",
        action="store_true",
        help="Use current wallpaper from state",
    )
    parser.add_argument(
        "--restore-live",
        "-r",
        action="store_true",
        help="Restore last live video",
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
        help="Number of CPU workers for thumbnail generation (default: 4)",
    )
    parser.add_argument(
        "--thumb-no-recursive",
        action="store_true",
        help="Don't recursively scan subdirectories for thumbnails",
    )

    args, remaining = parser.parse_known_args()

    switcher = WallpaperSwitcher()

    print("\nNoon Appearance Cli")
    auto_mode = "enabled" if switcher.get_auto_shell_mode_enabled() else "disabled"
    auto_scheme = (
        "enabled" if switcher.get_auto_scheme_selection_enabled() else "disabled"
    )
    print(f"Current mode:           {switcher.get_current_shell_mode()}")
    print(f"Current scheme:         {switcher.get_current_scheme()}")
    print(f"Current isBright:       {switcher.get_is_bright()}")
    print(f"Auto shell mode:        {auto_mode}")
    print(f"Auto scheme selection:  {auto_scheme}")
    if args.force:
        print(f"Force CLI args:         enabled")
    print()

    try:
        # Handle mode toggle
        if args.mode and args.mode.lower() == "toggle":
            new_mode = switcher.toggle_shell_mode()
            print(f"Mode toggled to: {new_mode}")

            # Apply the toggled mode to current wallpaper
            imgpath = switcher.state_data["desktop"]["bg"]["currentBg"].replace(
                "file://", ""
            )
            if imgpath and Path(imgpath).is_file():
                print(f"Applying to current wallpaper: {Path(imgpath).name}\n")
                switcher.switch(imgpath, mode=new_mode, force_cli=True)
            else:
                print("No current wallpaper to apply mode to\n")
            sys.exit(0)

        # Generate thumbnails mode
        if args.gen_thumbnails:
            switcher.generate_thumbnails(
                args.gen_thumbnails,
                size=args.thumb_size,
                workers=args.thumb_workers,
                recursive=not args.thumb_no_recursive,
            )
            sys.exit(0)

        # Restore live video
        if args.restore_live:
            switcher.restore_live()
            sys.exit(0)

        # Validate mode if provided
        mode_arg = None
        if args.mode:
            if args.mode.lower() in ["dark", "light"]:
                mode_arg = args.mode.lower()
            else:
                print(
                    f"ERROR: Invalid mode '{args.mode}'. Use 'dark', 'light', or 'toggle'"
                )
                sys.exit(1)

        # Handle random selection
        if args.random:
            imgpath = switcher.get_random_image(
                args.random, recursive=not args.random_no_recursive
            )
            if not imgpath:
                sys.exit(1)
        else:
            # Determine image path
            imgpath = args.image or (remaining[0] if remaining else "")

            if args.noswitch:
                imgpath = switcher.state_data["desktop"]["bg"]["currentBg"].replace(
                    "file://",
                    "",
                )
                if imgpath:
                    print(f"INFO: Using current wallpaper: {Path(imgpath).name}\n")

        # Color picker mode
        if args.pick or args.color:
            color = args.color
            if color:
                if re.match(r"^#?[A-Fa-f0-9]{6}$", color):
                    color = color.lstrip("#")
                else:
                    print("ERROR: Invalid color format (use #RRGGBB or RRGGBB)")
                    sys.exit(1)
            else:
                color = switcher.pick_color()
                if not color:
                    sys.exit(1)

            switcher.switch(
                "", mode_arg, args.scheme, color=color, force_cli=args.force
            )
            sys.exit(0)

        # File picker mode
        if not imgpath:
            imgpath = switcher.pick_file()
            if not imgpath or not Path(imgpath).is_file():
                print("ERROR: No file selected")
                sys.exit(1)

        # Do not pre-set GNOME theme here; switch() will handle it with auto mode
        switcher.switch(imgpath, mode_arg, args.scheme, force_cli=args.force)
        sys.exit(0)

    except KeyboardInterrupt:
        print("\nInterrupted by user")
        sys.exit(130)
    except Exception as e:
        print(f"ERROR: Fatal error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
