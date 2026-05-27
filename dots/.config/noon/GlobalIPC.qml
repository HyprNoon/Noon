import QtQuick
import Quickshell
import Quickshell.Services.Mpris
import qs.common
import qs.common.utils
import qs.common.functions
import qs.common.widgets
import qs.services
import qs.store

Scope {
    IpcHandler {
        target: "global"

        function build_shaders(): void {
            Shaders.rebuild();
        }
        function open_note(fileName: string): void {
            NotesService.openNote(fileName);
        }

        function note(content: string): void {
            NotesService.note(content);
        }

        function toggle_screenshot(): void {
            GlobalStates.main.showScreenshot = !GlobalStates.main.showScreenshot;
        }

        function trigger_autostart_apps(): void {
            const apps = Mem.options.services.autoExecAppsList;
            apps.forEach(app => {
                NoonUtils.execDetached([app]);
            });
        }

        function preview_url(url: string): void {
            console.log(url);
            BeatsService.previewURL(url);
        }

        function say(text: string): void {
            if (!text)
                return;
            SpeechService.say(text);
        }

        function thawb(link: string) {
            if (link)
                NoonUtils.requestDialog("thawb", link);
        }
        function toggle_dormant_sphere() {
            GlobalStates.showDormantShere = !GlobalStates.showDormantShere;
        }
        function toggle_dormant_state() {
            Mem.states.desktop.shell.deload = !Mem.states.desktop.shell.deload;
        }
        function load() {
            Mem.states.desktop.shell.deload = false;
        }
        function deload() {
            Mem.states.desktop.shell.deload = true;
        }
        function toast(info: string, state: string) {
            NoonUtils.toast({
                id: 0,
                content: info,
                status: state ?? ""
            });
        }
        function inc_brightness() {
            BrightnessService.increaseBrightness();
        }
        function dec_brightness() {
            BrightnessService.decreaseBrightness();
        }
        function clear_clipboard() {
            ClipboardService.manager.wipe();
        }
        function refresh_appearance() {
            WallpaperService.refreshTheme();
        }
        function toggleLightMode() {
            WallpaperService.toggleShellMode();
        }
        function pick_accent() {
            WallpaperService.pickAccentColor();
            NoonUtils.toast({
                id: 1,
                content: "Color Changed",
                icon: "palette"
            });
        }
        function pick_random_wall() {
            WallpaperService.applyRandomWallpaper();
        }
        function set_wall(path: string) {
            WallpaperService.applyWallpaper(path);
            NoonUtils.toast({
                id: 2,
                content: "Wallpaper Changed",
                icon: "image"
            });
        }

        function add_alarm(time: string, name: string) {
            TimerService.wake(time, name);
        }

        function wake(message: string) {
            NoonUtils.wake(message);
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

        function volume_down(): void {
            AudioService.sink.audio.volume -= 0.1;
        }

        function volume_up(): void {
            AudioService.sink.audio.volume += 0.1;
        }
    }

    IpcHandler {
        target: "mirsal"

        function feedBookmarks(content: string) {
            var data;
            try {
                data = JSON.parse(JSON.parse(content));
            } catch (e) {
                console.error("Failed to parse bookmarks: ", e);
                return;
            }
            Mem.states.services.bookmarks.firefoxBookmarks = data;
        }
    }
}
