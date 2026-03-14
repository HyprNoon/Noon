import QtQuick
import Noon.Services
import Quickshell
import Quickshell.Services.Mpris
import qs.common
import qs.common.utils
import qs.modules.main.view
import qs.common.functions
import qs.common.widgets
import qs.services
import qs.store

Scope {
    IpcHandler {
        target: "global"

        function thawb(link: string) {
            if (link)
                NoonUtils.getThawb(link);
        }
        function toast(content: string, state: string) {
            NoonUtils.toast(content, "check", state);
        }
        function inc_brightness() {
            BrightnessService.increaseBrightness();
        }
        function setup_rembg() {
            RemBgService.setup();
        }
        function dec_brightness() {
            BrightnessService.decreaseBrightness();
        }
        function clear_clipboard() {
            ClipboardService.wipe();
        }
        function refresh_appearance() {
            WallpaperService.refreshTheme();
        }
        function toggleLightMode() {
            WallpaperService.toggleShellMode();
        }
        function pick_accent() {
            WallpaperService.pickAccentColor();
            NoonUtils.toast("Color Changed", "palette");
        }
        function pick_random_wall() {
            WallpaperService.applyRandomWallpaper();
        }
        function set_wall(path: string) {
            WallpaperService.applyWallpaper(path);
            NoonUtils.toast("Wallpaper Changed", "image");
        }
        function todoist_key(key: string) {
            const trimmed = key.trim();
            KeyringStorage.setNestedField(["todoistApiKey"], trimmed);
            TodoService.todoistApiToken = trimmed;
            console.log("API token set (trimmed):", TodoService.todoistApiToken);
        }

        function add_alarm(time: string, name: string) {
            AlarmService.addTimer(time, name);
        }
        function wake(message: string) {
            NoonUtils.wake(message, "alarm");
        }

        function edit_json() {
            NoonUtils.edit(Quickshell.env('SHELL_CONFIG_PATH'));
        }

        function lock() {
            GlobalStates.main.locked = true;
            IdleService.idleMonitor.reset();
        }

        function pause_all_players(): void {
            for (const player of Mpris.players.values) {
                if (player.canPause)
                    player.pause();
            }
        }

        function dmenu_create(list: string, callback: string, icon: string): void {
            const items = list.split('|').filter(item => item.trim() !== '');

            const preparedItems = items.map(item => {
                return {
                    title: item.trim(),
                    subtitle: "",
                    icon: icon,
                    action: callback
                };
            });

            GlobalStates.main.dmenu.items = preparedItems;
            GlobalStates.main.dmenu.action = callback;
            NoonUtils.callIpc("sidebar reveal DMenu");
        }

        function toggle_playing(): void {
            MprisController.togglePlaying();
        }
        function previous_track(): void {
            MprisController.previous();
        }
        function next_track(): void {
            MprisController.next();
        }
        function medical_key(key: string) {
            MedicalDictionaryService.setApiKey(key);
        }
    }
}
