pragma Singleton
pragma ComponentBehavior: Bound
import qs.common
import qs.common.functions
import qs.common.widgets
import qs.common.utils
import qs.services
import Quickshell
import Qt.labs.platform
import QtQuick

Singleton {
    id: root

    property var currentGame: null
    readonly property var store: Mem.states.services.games

    readonly property int status_not_installed: 0
    readonly property int status_installed: 1
    readonly property int status_playing: 2
    readonly property int status_completed: 3
    readonly property var statusNames: ["Not Installed", "Installed", "Playing", "Completed"]

    property int selectedIndex: 0
    property var selectedInfo: store.list[selectedIndex]
    property QtObject colors: selectedInfo.coverImage.length > 0 ? colorsgen?.colors ?? Colors : Colors
    property string pendingSelectedGame: ""
    property string pendingSelectedCover: ""
    property alias addDialog: addGamePicker
    property alias addCoverDialog: addCoverPicker
    // for amd "DRI_PRIME=1"
    property var launchConfig: ({
            runner: "wine",
            gamescope: false,
            gamescopeArgs: "-W 1920 -H 1080 -f",
            gamemode: true,
            dxvk: true,
            vkd3d: true,
            mangohud: true,
            extraEnv: ["__NV_PRIME_RENDER_OFFLOAD=1", "__GLX_VENDOR_LIBRARY_NAME=nvidia wine game.exe", "DXVK_ASYNC=1", "DXVK_FRAME_RATE=0", "DXVK_STATE_CACHE=1", "WINEFSYNC=1"],
            wineArgs: []
        })

    Component.onCompleted: {
        resetStatus();
    }

    function resetStatus() {
        store.list.forEach(item => item.status = 1);
    }

    function setGameMode(toggled) {
        !toggled ? NoonUtils.execDetached("hyprctl reload") : NoonUtils.execDetached(Mem.states.services.games.gameModeCommand);
    }

    function addGame(name, executablePath, coverImage, optimization, description) {
        const id = Qt.md5(name);
        const cover = (coverImage && coverImage.length > 0) ? coverImage : GamesMetadataService.getCover(id, name, "");
        const desc = (description && description.length > 0) ? description : GamesMetadataService.getDescription(id, name, "");
        const game = {
            "id": id,
            "name": name,
            "executablePath": executablePath,
            "coverImage": cover,
            "description": desc,
            "status": status_installed,
            "lastPlayed": null,
            "optimization": optimization,
            "playTime": 0,
            "dateAdded": new Date().toISOString()
        };
        store.list.push(game);
    }

    function deleteGame(gameId) {
        const index = store.list.findIndex(game => game.id === gameId);
        if (index >= 0) {
            store.list.splice(index, 1);
            store.list = store.list.slice(0);
        }
    }

    function launchGame(gameId) {
        const game = store.list.find(g => g.id === gameId);
        if (!game)
            return false;

        game.lastPlayed = new Date().toISOString();
        if (game.status === status_installed)
            game.status = status_playing;

        if (game.optimization)
            optimizeSystem();

        currentGame = game;
        gameProcess.running = true;
        return true;
    }

    function _buildLaunchCommand(game) {
        const cfg = root.launchConfig;
        const cmd = ["python3", Directories.scriptsDir + "/games_service.py", "run", game.executablePath];
        if (cfg.runner !== "")
            cmd.push("--runner", cfg.runner);
        if (cfg.gamescope) {
            cmd.push("--gamescope");
            if (cfg.gamescopeArgs !== "")
                cmd.push("--gamescope-args", cfg.gamescopeArgs);
        }
        if (cfg.gamemode)
            cmd.push("--gamemode");
        if (cfg.dxvk)
            cmd.push("--dxvk");
        if (cfg.vkd3d)
            cmd.push("--vkd3d");
        if (cfg.mangohud)
            cmd.push("--mangohud");
        if (cfg.extraEnv && cfg.extraEnv.length > 0)
            cfg.extraEnv.forEach(e => cmd.push("--env", e));
        if (cfg.wineArgs && cfg.wineArgs.length > 0)
            cfg.wineArgs.forEach(a => cmd.push("--wine-args", a));
        return cmd;
    }

    function getRecentlyPlayed(count = 5) {
        return store.list.filter(game => game.lastPlayed).sort((a, b) => new Date(b.lastPlayed) - new Date(a.lastPlayed)).slice(0, count);
    }

    function searchGames(query) {
        const lowerQuery = query.toLowerCase();
        return store.list.filter(game => game.name.toLowerCase().includes(lowerQuery) || game.description.toLowerCase().includes(lowerQuery));
    }

    function optimizeSystem() {
        NoonUtils.execDetached("hyprctl --batch keyword animations:enabled 0; keyword decoration:shadow:enabled 0; keyword decoration:blur:enabled 0; keyword general:gaps_in 0; keyword general:gaps_out 0; keyword general:border_size 1; keyword input:sensitivity 0; keyword decoration:rounding 0; keyword general:allow_tearing 1");
        NoonUtils.callIpc("global deload");
    }

    Process {
        id: gameProcess
        command: root.currentGame ? root._buildLaunchCommand(root.currentGame) : []
        running: false
        environment: {
            let envObj = {};
            const list = Mem.options.services.games.launchEnv || [];
            list.forEach(item => {
                let [key, val] = item.split('=');
                if (key && val)
                    envObj[key] = val;
            });
            return envObj;
        }
        workingDirectory: {
            if (!root.currentGame)
                return "";
            const path = root.currentGame.executablePath;
            return path.substring(0, path.lastIndexOf('/'));
        }
        onStarted: NoonUtils.toast("Game Launched", "stadia_controller")
        onExited: {
            NoonUtils.callIpc("global load");
            NoonUtils.execDetached("hyprctl reload");
        }
    }

    FileDialog {
        id: addGamePicker
        title: "Select Game Executable"
        nameFilters: ["Executable files (*.exe *.AppImage *.sh)", "All files (*)"]
        onAccepted: {
            root.pendingSelectedGame = FileUtils.trimFileProtocol(currentFile);
            NoonUtils.callIpc("sidebar reveal Games");
        }
    }

    FileDialog {
        id: addCoverPicker
        title: "Select Cover Image"
        nameFilters: ["Image files (*.png *.jpg *.jpeg)", "All files (*)"]
        onAccepted: {
            root.pendingSelectedCover = FileUtils.trimFileProtocol(currentFile);
            NoonUtils.callIpc("sidebar reveal Games");
        }
    }

    PaletteGenerator {
        id: colorsgen
        active: Mem.options.services.games.adaptiveTheme
        source: Qt.resolvedUrl(selectedInfo.coverImage)
    }
}
