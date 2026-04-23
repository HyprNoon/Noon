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
        GlobalStates.main.sysDialogs.pendingData = data;
        GlobalStates.main.sysDialogs.mode = dialog;
    }

    function openFile(path: string) {
        Quickshell.execDetached(["xdg-open", path]);
    }

    function iconPath(icon: string): string {
        const noon_icon = `noon-${Mem.states.desktop.appearance.mode}.png`;
        const fallback = "image-missing-symbolic";
        const subs = ({
                "org.quickshell": noon_icon,
                "dev.zed.zed": "zed"
            });
        if (subs[icon] !== undefined) {
            return Quickshell.iconPath(subs[icon.toLowerCase()], fallback);
        } else
            return Quickshell.iconPath(icon, fallback);
    }

    function sudoExec(content: var) {
        Quickshell.execDetached(["pkexec", content]);
    }
    function playSound(name: string, pack, volumeLevel, repeat: int) {
        if (Mem.ready && Mem.options.desktop.behavior.sounds.enabled && !Mem.options.services.notifications.silent) {
            let packName = pack + "/" || "ui/";
            let path = Directories.sounds + packName + name + ".ogg";
            let volume = (volumeLevel || Mem.options.desktop.behavior.sounds.level) * 65536;
            let repeats = repeat || 1;

            // Loop with paplay for repeat > 1, single play otherwise
            let cmd = repeats > 1 ? `for i in {1..${repeats}}; do paplay --client-name "HyprNoon" --volume ${volume} ${path}; done` : `paplay --client-name "HyprNoon" --volume ${volume} ${path}`;
            Quickshell.execDetached(["bash", "-c", cmd]);
        }
    }
    function wake(name: string) {
        // Start alarm sound (infinite loop until stopped)
        let path = Directories.sounds + "ui/alarm.ogg";
        let volume = 1.0 * 65536;
        let cmd = `while true; do paplay --client-name "HyprNoon-Alarm" --volume ${volume} ${path}; done`;
        Quickshell.execDetached(["bash", "-c", cmd]);

        // Send notification with "Got it" button that stops the sound
        let icon = Directories.assets + "/icons/noon-symbolic.svg";
        let notifyCmd = `notify-send -i ${icon} -a "HyprNoon" -u critical -A "stop=Got it" "Wake Up !" "${name}" && pkill -f "paplay.*HyprNoon-Alarm"`;

        Quickshell.execDetached(["bash", "-c", notifyCmd]);
    }
    function toast(content, materialIcon = "check", state = "", header = "Noon") {
        GlobalStates.toasts.data.append({
            title: header,
            message: content,
            icon: materialIcon,
            status: state
        });
        while (GlobalStates.toasts.data.length > 5) {
            GlobalStates.toasts.data.remove(0);
        }
    }

    function notify(content: string, title: string) {
        let icon = Directories.assets + "/icons/noon-symbolic.svg";
        let titleStr = title ?? "HyprNoon";
        Quickshell.execDetached(["notify-send", "-i", icon, "-a", titleStr, content]);
    }
    function notifyPhone(content: string) {
        KdeConnectService.pingSelectedDevice(content);
    }
    function callIpc(request: string) {
        const cmd = `qs -c ~/.config/noon ipc call ${request}`;
        Quickshell.execDetached(["bash", "-c", cmd]);
    }

    function execDetached(command, log = false) {
        if (log) {
            console.log(command);
        }

        let effectiveCommand = "";
        if (Array.isArray(command)) {
            effectiveCommand = command.join(" ").toString();
        } else {
            effectiveCommand = command;
        }
        Quickshell.execDetached(["bash", "-c", effectiveCommand]);
    }

    // Atomic Changes
    function setHyprKey(key: string, value) {
        HyprlandParserService.variables[key] = value;
    }

    function installPkg(app: string) {
        const terminal = Mem.options.apps.terminal || "kitty";
        Quickshell.execDetached(["kitty", "-e", "fish", "-c", ` yay -S --noconfirm  ${app}`]);
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
    // property Component filePicker: FilePicker {}
    // function pickFiles(wTitle = "Noon Picker", multiple = true, namefilters = "ALL") {
    //     let picker = filePicker.createObject(GlobalStates.main.sidebar, {
    //         "title": wTitle,
    //         "multipleSelection": multiple,
    //         "filter": namefilters,
    //         "visible": true,
    //         "anchors.fill": root
    //     });

    //     picker.fileSelected.connect(files => {
    //         let fileList = Array.isArray(files) ? files : [files];
    //     // picker.destroy();
    //     });
    // }

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
    function changeSystemFont() {
        const font = Fonts.family.main;
        setHyprKey("font_main", font);
        execDetached(`gsettings set org.gnome.desktop.interface font-name '${font} ${Fonts.sizes.verysmall}'`);
        execDetached(`kwriteconfig6 --file kdeglobals --group General --key font '${font},${Fonts.sizes.verysmall},-1,5,50,0,0,0,0,0'`);
        if (!Fonts.family.isMainMono)
            execDetached(`kwriteconfig6 --file kdeglobals --group General --key fixed '${Fonts.family.monospace},${Fonts.sizes.verysmall},-1,5,50,0,0,0,0,0'`);
    }

    Connections {
        target: Fonts.family
        function onMainChanged() {
            fontTimer.restart();
        }
        property Timer fontTimer: Timer {
            id: fontTimer
            interval: 1000
            onTriggered: NoonUtils.changeSystemFont()
        }
    }
    Connections {
        target: Mem.options.apps
        property QtObject conf: Mem.options.apps

        function onBrowserChanged() {
            NoonUtils.setHyprKey("browser", conf.browser);
        }
        function onBrowserAltChanged() {
            NoonUtils.setHyprKey("browser_alt", conf.browserAlt);
        }
        function onTerminalChanged() {
            NoonUtils.setHyprKey("terminal", conf.terminal);
        }
        function onTerminalAltChanged() {
            NoonUtils.setHyprKey("terminal_alt", conf.terminalAlt);
        }
        function onFileManagerChanged() {
            NoonUtils.setHyprKey("file_manager", conf.fileManager);
        }
        function onEditorChanged() {
            NoonUtils.setHyprKey("editor", conf.editor);
        }
    }

    Connections {
        target: Mem.options.desktop.hyprland
        readonly property QtObject conf: Mem.options.desktop.hyprland

        function onApplicationsOpacityChanged() {
            NoonUtils.setHyprKey("applications_opacity", conf.applicationsOpacity);
        }
        function onUnBlurAppsChanged() {
            NoonUtils.setHyprKey("unblur_apps", conf.unBlurApps);
        }
        function onExternalMonitorProfileChanged() {
            NoonUtils.setHyprKey("external_monitor_mode", conf.externalMonitorProfile);
        }
        function onCursorThemeChanged() {
            NoonUtils.setHyprKey("cursor_theme", conf.cursorTheme);
        }
        function onShadowsPowerChanged() {
            NoonUtils.setHyprKey("shadows_power", conf.shadowsPower);
        }
        function onShadowsRangeChanged() {
            NoonUtils.setHyprKey("shadows_range", conf.shadowsRange);
        }
        function onGapsInChanged() {
            NoonUtils.setHyprKey("gaps_in", conf.gapsIn);
        }
        function onGapsOutChanged() {
            NoonUtils.setHyprKey("gaps_out", conf.gapsOut);
        }
        function onLayerAlphaChanged() {
            NoonUtils.setHyprKey("layer_alpha", conf.layerAlpha);
        }
        function onShadowsChanged() {
            NoonUtils.setHyprKey("shadows", conf.shadows);
        }
        function onBordersChanged() {
            NoonUtils.setHyprKey("borders", conf.borders);
        }
        function onBlurPassesChanged() {
            NoonUtils.setHyprKey("blur_passes", conf.blurPasses);
        }
        function onTilingLayoutChanged() {
            NoonUtils.setHyprKey("layout", conf.tilingLayout);
            NoonUtils.execDetached("hyprctl dispatch submap " + conf.tilingLayout);
        }
    }

    Connections {
        target: Quickshell
        function onReloadFailed(error) {
            let lines = error.split('\n');
            let lastLine = lines[lines.length - 1];
            root.toast(lastLine, "close", "error", "Quickshell");
        }
    }
}
