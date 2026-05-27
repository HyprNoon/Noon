pragma Singleton
pragma ComponentBehavior: Bound
import qs.store
import qs.common
import qs.common.utils
import qs.common.widgets
import qs.services
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property string scriptPath: Directories.scriptsDir + "/wine_manager.py"
    readonly property var baseCmd: ["python3", scriptPath]

    property var installedTools: ({})
    property var detectedApps: ([])
    property var remoteVersions: ([])
    property var appConfigs: ({})
    property string defaultRunner: ""
    property bool loading: false
    property bool downloading: false
    property string downloadProgress: ""
    property string downloadStatus: ""
    property string lastError: ""
    property bool updateAvailable: false

    signal toolsRefreshed()
    signal remoteRefreshed()
    signal downloadComplete(bool success, string name, string tag)
    signal errorOccurred(string message)

    function refreshTools() {
        loading = true;
        run(["list-installed"], function(out) {
            try {
                var data = JSON.parse(out);
                if (Array.isArray(data)) {
                    var map = {};
                    data.forEach(function(t) { map[t.name] = t; });
                    installedTools = map;
                    toolsRefreshed();
                }
            } catch (e) {
                console.error("wine_manager: parse error", e);
            }
            loading = false;
        });
    }

    function detectAll() {
        loading = true;
        run(["detect"], function(out) {
            try {
                detectedApps = JSON.parse(out).apps || [];
            } catch (e) {}
            loading = false;
        });
    }

    function fetchRemoteVersions(source) {
        loading = true;
        downloadProgress = "";
        run(["list-remote", source], function(out) {
            try {
                var data = JSON.parse(out);
                if (data.versions) {
                    remoteVersions = data.versions;
                    remoteRefreshed();
                } else if (data.error) {
                    lastError = data.error;
                    errorOccurred(data.error);
                }
            } catch (e) {}
            loading = false;
        });
    }

    function installVersion(source, version) {
        downloading = true;
        downloadStatus = "downloading";
        downloadProgress = "";
        lastError = "";
        installProcess.command = baseCmd.concat(["install", source, version]);
        installProcess.running = true;
    }

    function uninstallVersion(name) {
        loading = true;
        run(["uninstall", name], function(out) {
            try {
                if (JSON.parse(out).success) refreshTools();
            } catch (e) {}
            loading = false;
        });
    }

    function setDefaultRunner(runner) {
        run(["set-default", runner], function() { defaultRunner = runner; });
    }

    function getDefaultRunner() {
        run(["get-default"], function(out) {
            try { defaultRunner = JSON.parse(out).default || ""; } catch (e) {}
        });
    }

    function refreshAppConfigs() {
        run(["app-list"], function(out) {
            try { appConfigs = JSON.parse(out); } catch (e) { appConfigs = ({}); }
        });
    }

    function setAppConfig(appId, config) {
        var args = ["app-set", appId];
        if (config.runner) { args.push("--runner", config.runner); }
        if (config.dxvk !== undefined) args.push(config.dxvk ? "--dxvk" : "--no-dxvk");
        if (config.vkd3d !== undefined) args.push(config.vkd3d ? "--vkd3d" : "--no-vkd3d");
        if (config.gamemode !== undefined) args.push(config.gamemode ? "--gamemode" : "--no-gamemode");
        if (config.mangohud !== undefined) args.push(config.mangohud ? "--mangohud" : "--no-mangohud");
        if (config.gamescope !== undefined) args.push(config.gamescope ? "--gamescope" : "--no-gamescope");
        if (config.gamescopeArgs) args.push("--gamescope-args", config.gamescopeArgs);
        if (config.env) config.env.forEach(function(e) { args.push("--env", e); });
        if (config.wineArgs) config.wineArgs.forEach(function(a) { args.push("--wine-args", a); });
        run(args, function() { refreshAppConfigs(); });
    }

    function installApp(exe, name, runner, dxvk, vkd3d, gamemode) {
        var args = ["app-install", exe];
        if (name) args.push("--name", name);
        if (runner) args.push("--runner", runner);
        if (dxvk) args.push("--dxvk");
        if (vkd3d) args.push("--vkd3d");
        if (gamemode) args.push("--gamemode");
        run(args, function(out) {
            try {
                var data = JSON.parse(out);
                if (data.success) {
                    refreshAppConfigs();
                    NoonUtils.toast({id: 0, content: "Registered: " + data.app_id, icon: "check"});
                }
            } catch (e) {}
        });
    }

    function uninstallApp(appId) {
        run(["app-uninstall", appId], function(out) {
            try { if (JSON.parse(out).success) refreshAppConfigs(); } catch (e) {}
        });
    }

    function runApp(appId) {
        run(["app-run", appId], function(out) {
            try {
                var data = JSON.parse(out);
                if (data.pid)
                    NoonUtils.toast({id: 0, content: "Launched: " + appId, icon: "stadia_controller"});
                else if (data.error) errorOccurred(data.error);
            } catch (e) {}
        });
    }

    function checkUpdates() {
        run(["update"], function(out) {
            try {
                var lines = out.trim().split("\n");
                for (var i = 0; i < lines.length; i++) {
                    if (JSON.parse(lines[i]).updatable) { updateAvailable = true; return; }
                }
                updateAvailable = false;
            } catch (e) { updateAvailable = false; }
        });
    }

    function run(args, cb) {
        var p = _worker.createObject(root, {cmd: baseCmd.concat(args), callback: cb || function() {}});
        p.running = true;
    }

    Component {
        id: _worker
        Process {
            id: _p
            property var cmd: []
            property var callback: null
            command: cmd
            running: false
            stdout: StdioCollector {
                onStreamFinished: {
                    if (_p.callback) _p.callback(text.trim());
                    _p.destroy();
                }
            }
            stderr: StdioCollector {
                onStreamFinished: {
                    if (text.trim()) console.warn("wine_manager:", text.trim());
                }
            }
            onExited: function(code) {
                if (code !== 0 && !_p.callback) console.warn("wine_manager exited:", code);
            }
        }
    }

    Process {
        id: installProcess
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var data = JSON.parse(text.trim());
                    if (data.status === "downloading")
                        downloadProgress = "Downloading " + data.tag + "...";
                    else if (data.success) {
                        downloadStatus = "complete";
                        downloadProgress = "Installed " + (data.name || data.tag);
                        downloadComplete(true, data.name || data.tag, data.tag);
                        refreshTools();
                    } else if (data.error) {
                        lastError = data.error;
                        downloadStatus = "error";
                        errorOccurred(data.error);
                        downloadComplete(false, "", "");
                    }
                } catch (e) {}
            }
        }
        stderr: StdioCollector {
            onStreamFinished: {
                var t = text.trim();
                if (t) downloadProgress = t.replace(/\n/g, " ").trim();
            }
        }
        onExited: function(code) {
            downloading = false;
            if (code !== 0 && downloadStatus !== "complete" && downloadStatus !== "error") {
                downloadStatus = "error";
                lastError = "Process exited with code " + code;
                errorOccurred(lastError);
            }
        }
    }

    Component.onCompleted: {
        refreshTools();
        getDefaultRunner();
    }
}
