pragma Singleton
pragma ComponentBehavior: Bound
import qs.common
import qs.common.widgets
import qs.common.utils
import Quickshell
import Qt.labs.platform
import QtQuick

Singleton {
    id: root

    property var currentGame: null
    property var gamesList: []

    readonly property int status_not_installed: 0
    readonly property int status_installed: 1
    readonly property int status_playing: 2
    readonly property int status_completed: 3
    readonly property var statusNames: ["Not Installed", "Installed", "Playing", "Completed"]
    property int selectedIndex: 0
    property var selectedInfo: gamesList[selectedIndex]
    property alias colors: colorsgen.colors

    Component.onCompleted: {
        NoonUtils.execDetached(`touch ${gameFileView.path}`);
        reload();
    }

    function addGame(name, executablePath, coverImage = "", optimization, description = "") {
        const game = {
            "id": Date.now() + Math.random(),
            "name": name,
            "executablePath": executablePath,
            "coverImage": coverImage,
            "description": description,
            "status": status_installed,
            "lastPlayed": null,
            "optimization": optimization,
            "playTime": 0,
            "dateAdded": new Date().toISOString()
        };

        gamesList.push(game);
        root.gamesList = gamesList.slice(0);
        saveGames();
    }
    function deleteGame(gameId) {
        const index = gamesList.findIndex(game => game.id === gameId);
        if (index >= 0) {
            gamesList.splice(index, 1);
            root.gamesList = gamesList.slice(0);
            saveGames();
        }
    }
    function updateGameStatus(gameId, newStatus) {
        const game = gamesList.find(g => g.id === gameId);
        if (game && newStatus >= status_not_installed && newStatus <= status_completed) {
            game.status = newStatus;
            root.gamesList = gamesList.slice(0);
            saveGames();
        }
    }
    function launchGame(gameId) {
        const game = gamesList.find(g => g.id === gameId);
        if (!game)
            return false;

        game.lastPlayed = new Date().toISOString();
        if (game.status === status_installed) {
            game.status = status_playing;
        }
        root.gamesList = gamesList.slice(0);
        saveGames();
        if (game.optimization)
            optimizeSystem();
        currentGame = game;
        gameProcess.running = true;
        return true;
    }
    function saveGames() {
        gameFileView.setText(JSON.stringify(root.gamesList, null, 2));
    }
    function reload() {
        gameFileView.reload();
    }
    function getGamesByStatus(status) {
        return gamesList.filter(game => game.status === status);
    }
    function getGameCount() {
        return gamesList.length;
    }
    function getRecentlyPlayed(count = 5) {
        return gamesList.filter(game => game.lastPlayed).sort((a, b) => new Date(b.lastPlayed) - new Date(a.lastPlayed)).slice(0, count);
    }
    function searchGames(query) {
        const lowerQuery = query.toLowerCase();
        return gamesList.filter(game => game.name.toLowerCase().includes(lowerQuery) || game.description.toLowerCase().includes(lowerQuery));
    }
    function optimizeSystem() {
        NoonUtils.execDetached("hyprctl --batch keyword animations:enabled 0; keyword decoration:shadow:enabled 0; keyword decoration:blur:enabled 0; keyword general:gaps_in 0; keyword general:gaps_out 0; keyword general:border_size 1; keyword input:sensitivity 0; keyword decoration:rounding 0; keyword general:allow_tearing 1");
    }
    Process {
        id: gameProcess
        command: currentGame ? ["gamemoderun", root.currentGame.executablePath] : []
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
        onStarted: NoonUtils.notify("Game Launched")
        onExited: NoonUtils.execDetached("hyprctl reload")
    }

    FileView {
        id: gameFileView
        // Todo: Urgent
        // path: Directories.standard.config + "/heroic/sideload_apps/library.json"

        onLoaded: {
            try {
                const fileContents = gameFileView.text();
                let parsedList = JSON.parse(fileContents);
                root.gamesList = parsedList || [];
            } catch (error) {
                root.gamesList = [];
            }
        }

        onLoadFailed: error => {
            if (error == FileViewError.FileNotFound) {
                root.gamesList = [];
                saveGames();
            }
        }
    }

    PaletteGenerator {
        id: colorsgen
        active: Mem.options.services.games.adaptiveTheme
        source: (root.selectedInfo && root.selectedInfo.coverImage) ? root.selectedInfo.coverImage : ""
    }
}
