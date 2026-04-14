pragma Singleton
import QtQuick
import Quickshell
import qs.common
import qs.common.utils
import qs.common.functions

Singleton {
    id: root

    enum Regions {
        Full,
        Part,
        Window
    }

    readonly property string mainDir: Directories.services.screenshots
    readonly property string tempPath: "/tmp/noon/temp_screen_shot.png"
    readonly property bool isBusy: proc.running
    property bool isSelecting: false
    property real regionX: 0
    property real regionY: 0
    property real regionW: 0
    property real regionH: 0
    readonly property bool hasRegion: regionW > 0 && regionH > 0

    signal screenshotCompleted(string path)

    onScreenshotCompleted: {
        NoonUtils.toast("Screen Shot Saved", "camera", "success");
    }
    function delete_temp(): void {
        NoonUtils.execDetached("rm -rf " + tempPath);
    }
    function startRegionSelect(): void {
        isSelecting = true;
    }

    function setRegion(x, y, w, h): void {
        regionX = x;
        regionY = y;
        regionW = w;
        regionH = h;
        isSelecting = false;
    }

    function clearRegion(): void {
        regionX = 0;
        regionY = 0;
        regionW = 0;
        regionH = 0;
    }

    function request(obj): void {
        if (!obj || isBusy)
            return;

        var shellCmd;
        const temp = obj.temp ?? false;
        const mode = obj.region ?? ScreenShotService.Regions.Full;
        const outPath = temp ? root.tempPath : root.mainDir + "/screenshot-" + new Date().toISOString().replace(/[:.]/g, "-") + ".png";
        delete_temp();
        if (mode === ScreenShotService.Regions.Window) {
            NoonUtils.execDetached(Directories.scriptsDir + "/screenshot_helper.sh " + outPath);
            return;
        } else if (mode === ScreenShotService.Regions.Part) {
            if (!root.hasRegion) {
                shellCmd = `grim "${outPath}"`;
            } else {
                const r = n => Math.round(n);
                shellCmd = `grim -g "${r(root.regionX)},${r(root.regionY)} ${r(root.regionW)}x${r(root.regionH)}" "${outPath}"`;
            }
        } else
            shellCmd = `grim "${outPath}"`;

        proc.outPath = outPath;
        proc.command = ["bash", "-c", shellCmd];
        proc.running = true;
    }
    Process {
        id: proc
        property string outPath: ""

        environment: ({
                XDG_SCREENSHOTS_DIR: Directories.services.screenshots
            })

        onExited: exitCode => {
            if (exitCode === 0)
                root.screenshotCompleted(outPath);
        }
    }
}
