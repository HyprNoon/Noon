pragma Singleton
pragma ComponentBehavior: Bound
import Quickshell
import qs.common
import qs.common.functions
import qs.common.utils

Singleton {
    id: root

    function createXDPH() {
        const t = path => FileUtils.trimFileProtocol(path);
        FileUtils.createFileWith(t(Directories.standard.config + "/hypr/xdph.conf"), `screencopy {
            custom_picker_binary = ${t(Directories.standard.config)}/noon/scripts/screen_share_watcher
        }`);
    }

    function setupVariables() {
        Mem.options.desktop.shell.mode = "main";
    }

    function setup() {
        if (!Mem.states.desktop.firstRun)
            return;
        Mem.states.desktop.firstRun = false;
        WallpaperService.resetWallpaper();
        createXDPH();
    }
}
