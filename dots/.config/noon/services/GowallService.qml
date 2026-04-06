pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import qs.common
import qs.common.functions
import qs.common.utils
import qs.store

Singleton {
    id: root

    property bool isBusy: proc.running
    property string inputPath: FileUtils.trimFileProtocol(Mem.states.desktop.bg.currentBg)
    property string current_processed_wall: Directories.wallpapers.gowallDir + Qt.md5(inputPath) + ".png"
    property string upscale_output: FileUtils.trimFileExt(inputPath) + "_upscaled.png"
    property string _pendingOutput: ""

    function upscaleCurrentWallpaper(): void {
        root._pendingOutput = upscale_output;
        proc.command = ["gowall", "upscale", inputPath, "--output", upscale_output];
        proc.running = true;
    }

    function convertTheme(themeName): void {
        root._pendingOutput = current_processed_wall;
        proc.command = ["gowall", "convert", "-t", themeName, inputPath, "--output", current_processed_wall];
        proc.running = true;
    }

    function removeBackground(input: string): void {
        const inputPath = FileUtils.trimFileProtocol(WallpaperService.currentWallpaper);
        depthProc.command = ["bash", "-c", `[ -f '${WallpaperService.currentFgPath}' ] || gowall bg --output '${WallpaperService.currentFgPath}' '${inputPath}'`];
        depthProc.running = true;
    }
    Process {
        id: depthProc
    }
    Process {
        id: proc
        onStarted: console.log("[Gowall Service] Started With Command: ", command.join(","))
        onExited: exitCode => {
            if (exitCode === 0)
                WallpaperService.applyWallpaper(Qt.resolvedUrl(root._pendingOutput));
        }
    }
}
