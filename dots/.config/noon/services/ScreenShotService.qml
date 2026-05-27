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
    readonly property string tempPath: "/tmp/temp_screen_shot.png"
    readonly property bool isBusy: mainProc.running
    readonly property bool hasRegion: regionW > 0 && regionH > 0
    readonly property Process sattyProc: Process {}
    property bool isSelecting: false
    property real regionX: 0
    property real regionY: 0
    property real regionW: 0
    property real regionH: 0

    signal screenshotCompleted(string path)

    function delete_temp(): void {
        NoonUtils.execDetached(["rm", "-rf", tempPath]);
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

    function execute(out: string, args: list<string>): void {
        mainProc.running = false;
        mainProc.outPath = out;
        mainProc.command = args;
        mainProc.running = true;
    }

    Process {
        id: mainProc
        property string outPath: ""
        onStarted: console.log("started", mainProc.command.join(" "))
        environment: ({
                "XDG_SCREENSHOTS_DIR": FileUtils.trimFileProtocol(mainDir)
            })
        onExited: code => {
            if (code === 0) {
                root.screenshotCompleted(outPath);
                mainProc.outPath = "";
            }
        }
    }

    function takeWindowScreenshot(path: string): void {
        if (!path)
            return;
        execute(path, ["grimblast", "save", "area", path]);
    }

    function takeFullScreenshot(path: string): void {
        if (!path)
            return;
        execute(path, ["grim", path]);
    }

    function takeRegionScreenshot(path: string): void {
        if (!path)
            return;
        const r = n => Math.round(n);
        execute(path, ["grim", "-g", `${r(root.regionX)},${r(root.regionY)} ${r(root.regionW)}x${r(root.regionH)}`, path]);
    }

    function request(obj): void {
        if (!obj)
            return;

        GlobalStates.main.showScreenshot = false;

        const outPath = obj.temp ? root.tempPath : root.mainDir + "/screenshot-" + new Date().toISOString().replace(/[:.]/g, "-") + ".png";
        const actions = {
            [ScreenShotService.Regions.Full]: () => root.takeFullScreenshot(outPath),
            [ScreenShotService.Regions.Window]: () => root.takeWindowScreenshot(outPath),
            [ScreenShotService.Regions.Part]: () => root.takeRegionScreenshot(outPath)
        };

        NoonUtils.singleshot(() => {
            actions[obj.region]();
        }, 50);

        if (!obj.temp)
            root.screenshotCompleted.connect(path => {
                sattyProc.running = false;
                sattyProc.command = ["satty", "--filename", path];
                sattyProc.running = true;
            });
    }
}
