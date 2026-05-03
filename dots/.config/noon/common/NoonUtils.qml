pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import qs.services
import qs.common
import qs.common.utils
import qs.common.functions
import qs.common.widgets
import Noon.Utils.Dialogs
import QtMultimedia

/* Bundled Custom QS Functions For Noon */

Singleton {
    id: root
    readonly property var avilableSystemCommands: Mem.store.misc.systemCommands
    readonly property var avilableIpcCommands: Mem.store.misc.ipcCommands

    property bool ipcReady: false
    property bool commandsReady: false

    function requestDialog(dialog: string, data) {
        if (!dialog)
            return;
        if (data)
            GlobalStates.main.sysDialogs.pendingData = data;
        GlobalStates.main.sysDialogs.mode = dialog;
    }

    function deleteFile(path: string) {
        const f = FileUtils.trimFileProtocol(path);
        execDetached(["gio", "trash", `"${f}"`]);
    }

    function openFile(path: string) {
        const f = FileUtils.trimFileProtocol(path);
        execDetached(["gio", "open", `"${f}"`]);
    }

    function iconPath(icon: string, fallback = "image-missing-symbolic"): string {
        const noon_icon = `noon-${Mem.states.desktop.appearance.mode}.png`;
        const subs = ({
                "org.quickshell": noon_icon,
                "dev.zed.zed": "zed"
            });
        const lookup = subs[icon] ?? DesktopEntries.heuristics(icon)?.icon ?? icon;
        return Quickshell.iconPath(lookup, fallback);
    }

    function sudoExec(content: var) {
        execDetached(["pkexec", content]);
    }

    function playSound(name, pack, repeat) {
        if (Mem.ready && Mem.options.desktop.behavior.sounds.enabled && !Mem.options.services.notifications.silent) {
            let baseDir = Directories.sounds.endsWith("/") ? Directories.sounds : Directories.sounds + "/";
            let packName = pack ? pack + "/" : "ui/";
            let path = "file://" + baseDir + packName + name + ".ogg";

            if (player.playbackState === MediaPlayer.PlayingState)
                player.stop();

            player.remainingRepeats = repeat || 1;
            player.source = path;

            player.play();
        }
    }

    function wake(name: string) {
        let path = Directories.sounds + "ui/alarm.ogg";
        let volume = 1.0 * 65536;
        let cmd = `while true; do paplay --client-name "HyprNoon-Alarm" --volume ${volume} ${path}; done`;
        execDetached([cmd]);

        let icon = Directories.assets + "/icons/noon-symbolic.svg";
        let notifyCmd = `notify-send -i ${icon} -a "HyprNoon" -u critical -A "stop=Got it" "Wake Up !" "${name}" && pkill -f "paplay.*HyprNoon-Alarm"`;
        execDetached([notifyCmd]);
    }

    function toast(obj) {
        const info = {
            id: obj?.id ?? -1,
            title: obj?.header ?? "Noon",
            message: obj?.content ?? "",
            icon: obj?.materialIcon ?? "check",
            status: obj?.state ?? ""
        };

        let currentData = [...GlobalStates.toasts.data];
        const itemId = currentData.findIndex((item) => item.id === info.id);

        if (itemId !== -1) {
            currentData[itemId] = info;
        } else {
            if (currentData.length >= 5) {
                currentData.shift();
            }
            currentData.push(info);
        }

        GlobalStates.toasts.data = currentData;
    }

    function notify(content: string, title: string) {
        let icon = Directories.assets + "/icons/noon-symbolic.svg";
        let titleStr = title ?? "HyprNoon";
        execDetached(["notify-send", "-i", icon, "-a", titleStr, content]);
    }
    function notifyPhone(content: string) {
        KdeConnectService.pingSelectedDevice(content);
    }
    function callIpc(request: string) {
        const cmd = `qs -c ~/.config/noon ipc call ${request}`;
        execDetached([cmd]);
    }

    function execDetached(command, log = false) {
        if (log) {
            console.log(command);
        }

        let effectiveCommand = "";
        if (Array.isArray(command))
            effectiveCommand = command.join(" ").toString();
        else
            effectiveCommand = command;

        Quickshell.execDetached(["bash", "-c", effectiveCommand]);
    }

    // Atomic Changes
    function setHyprKey(key: string, value) {
        Mem.hypr[key] = value;
    }

    function runInTerminal(command: string) {
        const terminal = Mem.options.apps.terminal || "kitty";
        execDetached(["kitty", "-e", "fish", "-c", command]);
    }
    function installPkg(app: string) {
        runInTerminal("yay -S --noconfirm  " + app);
    }

    function setSidebarUrl(url) {
        if (!url.startsWith("http"))
            return;
        GlobalState.web_session.url = url;
    }

    function checkIfDlp(url) {
        const avList = ["youtube.com", "youtu.be", "facebook.com", "twitter.com", "x.com", "instagram.com", "tiktok.com", "twitch.tv", "reddit.com", "soundcloud.com", "spotify.com", "archive.org", "pornhub.com", "crunchyroll.com", "plex.tv", "imgur.com", "streamable.com", "udemy.com", "coursera.org", "khan academy.org"];

        return avList.some(domain => url.toLowerCase().includes(domain));
    }

    function isOnline(url) {
        return url.startsWith("http") || url.startsWith("https" || url.contains("www"));
    }

    function runDownloader(url) {
        if (isOnline(url)) {
            if (checkIfDlp(url)) {
                GlobalStates.main.sysDialogs.pendingData = url;
                GlobalStates.main.sysDialogs.mode = "dlp";
            }
        }
    }

    function edit(filePath) {
        if (!filePath)
            return;
        callIpc(`apps noon_edit ${filePath}`);
    }

    function fetchCommands() {
        if (!commandsReady)
            commandLoader.running = true;
    }

    function fetchIpcCommands() {
        if (!ipcReady)
            ipcCommands.running = true;
    }
    function pickGlobalFont() {
        fontDialog.open();
    }

    function changeGlobalFont(fontVar) {
        if (typeof fontVar === "string") {
            execDetached([Directories.scriptsDir + "/sync_sys_fonts.sh", "--family", fontVar, "--size", Fonts.sizes.small]);
            setHyprKey("font_main", fontVar);
            Mem.options.appearance.fonts.main = fontVar;
        } else {
            Quickshell.execDetached([Directories.scriptsDir + "/sync_sys_fonts.sh", "--family", fontVar.family, "--size", fontVar.size]);
            setHyprKey("font_main", fontVar.family);
            Mem.options.appearance.fonts.main = fontVar.family;
            Mem.options.appearance.fonts.scale = fontVar.size / 10;
        }
    }

    Process {
        id: ipcCommands
        running: false
        command: ["bash", "-c", `qs -c ${FileUtils.trimFileProtocol(Directories.standard.config)}/noon  ipc  show`]
        stdout: StdioCollector {
            onStreamFinished: {
                const out = text.trim();
                const parsed = [];
                const blocks = out.split("target ").map(b => b.trim()).filter(b => b.length > 0);
                for (let i = 0; i < blocks.length; ++i) {
                    const block = blocks[i];
                    const targetMatch = block.match(/^([^\s,]+)/);
                    if (!targetMatch)
                        continue;
                    const target = targetMatch[1];
                    const funcRegex = /function\s+([^\(]+)\(/g;
                    let m;
                    while ((m = funcRegex.exec(block)) !== null) {
                        const fn = m[1].trim();
                        parsed.push(target + " " + fn);
                    }
                }

                Mem.store.misc.ipcCommands = parsed;
                root.commandsReady = true;
                console.log("[Noon] fetched IPC commands");
            }
        }
    }

    MediaPlayer {
        id: player
        audioOutput: AudioOutput {
            id: audioOutput
            volume: 0.15
        }

        property int remainingRepeats: 0

        onPlaybackStateChanged: if (playbackState === MediaPlayer.StoppedState && remainingRepeats > 1) {
            remainingRepeats--;
            player.play();
        }
    }

    Process {
        id: commandLoader
        running: false
        command: ["bash", "-c", "compgen -c | sort -u "]
        stdout: StdioCollector {
            onStreamFinished: {
                const out = text.trim();
                if (out.length === 0) {
                    Mem.store.misc.systemCommands = [];
                    root.commandsReady = true;
                    return;
                }
                Mem.store.misc.systemCommands = out.split("\n");
                root.commandsReady = true;
                console.log("[Noon] fetched Bash commands");
            }
        }
    }

    FontDialog {
        id: fontDialog
        onSelectedFontChanged: NoonUtils.changeGlobalFont(fontDialog.selectedFont)
    }

    Connections {
        target: Quickshell
        function onReloadFailed(error) {
            let lines = error.split('\n');
            let lastLine = lines[lines.length - 1];
            root.toast({
                id: 0,
                content: lastLine,
                status: "error",
                title: "Quickshell"
            });
        }
    }
}
