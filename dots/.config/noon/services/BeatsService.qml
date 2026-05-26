pragma Singleton
pragma ComponentBehavior: Bound
import qs.store
import qs.common
import qs.common.utils
import qs.common.widgets
import qs.common.functions
import QtQuick.Dialogs
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import Qt.labs.folderlistmodel
import Noon.Utils

Singleton {
    id: root

    readonly property QtObject colors: palette.colors
    readonly property alias daemonOptions: daemonView.data

    readonly property string tracksDir: Qt.resolvedUrl(getCurrentLibraryPath())
    readonly property alias library: libraryFetcher.data
    readonly property alias queue: queueFetcher.data

    readonly property int defaultPlayerIndex: getCurrentPlayerIndex()
    property int selectedPlayerIndex: defaultPlayerIndex

    readonly property bool filterPlayersEnabled: false
    readonly property list<string> excludedPlayers: Mem.options.mediaPlayer?.excludedPlayers ?? []

    readonly property string artUrl: player ? StringUtils.cleanMusicTitle(player.trackArtUrl) : ""
    readonly property string title: player ? StringUtils.cleanMusicTitle(player.trackTitle) : "No Title"
    readonly property string artist: player ? StringUtils.cleanMusicTitle(player.trackArtist) : "No Artist"

    readonly property var players: Mpris?.players.values ?? []
    readonly property MprisPlayer player: meaningfulPlayers[selectedPlayerIndex] ?? null

    readonly property bool _downloading: dlpHelperProc.running
    readonly property bool _playing: player && player.playbackState === MprisPlaybackState.Playing
    readonly property var baseCmd: ["python3", Directories.scriptsDir + "/beats_daemon.py"]
    readonly property var meaningfulPlayers: {
        const source = root.players;
        if (!source)
            return [];

        const map = new Map();
        for (let i = 0; i < source.length; i++) {
            const p = source[i];
            if (!p || !p.dbusName || p.dbusName === "" || !isRealPlayer(p))
                continue;

            const key = `${p.trackTitle || ""}|${p.trackArtist || ""}`.toLowerCase();
            if (!map.has(key)) {
                map.set(key, p);
            } else {
                const existing = map.get(key);
                if (p.trackArtUrl?.length > 0 && !(existing.trackArtUrl?.length > 0))
                    map.set(key, p);
            }
        }
        return Array.from(map.values());
    }

    onPlayersChanged: handleOverlappingPlayers()
    Component.onCompleted: NoonUtils.execDetached([...baseCmd, "init"])
    function getCurrentPlayerIndex() {
        const players = meaningfulPlayers;
        const currentlyActivePlayer = players.find(player => player.playbackState === MprisPlaybackState.Playing);
        return Math.max(0, players?.indexOf(currentlyActivePlayer)) ?? 0;
    }
    function refreshTracks() {
        NoonUtils.execDetached([...baseCmd, "update-db"]);
        Qt.callLater(() => NoonUtils.execDetached([...baseCmd, "rebuild-covers"]));
    }

    function fetchLibrary() {
        refreshTracks();
        libraryFetcher.running = true;
    }

    function handleOverlappingPlayers() {
        if (!meaningfulPlayers)
            return;
        const players = meaningfulPlayers;
        const currentlyActivePlayers = players.filter(p => p.playbackState === MprisPlaybackState.Playing);

        if (currentlyActivePlayers.length > 1) {
            let activeCount = 0;

            for (let i = players.length - 1; i >= 0; i--) {
                const p = players[i];
                if (p.playbackState === MprisPlaybackState.Playing) {
                    activeCount++;
                    if (activeCount > 1) {
                        p.togglePlayback();
                    }
                }
            }
        }
    }
    function playTrackByFile(file) {
        _daemonCmd(["--player", "main", "play-by-name", "--name", `${file}`]);
    }

    function playCustomPlaylist(...args) {
        _daemonCmd(["--player", "main", "build-playlist", "--list", args.join(",")]);
    }

    function _daemonCmd(args) {
        mainProc.running = false;
        mainProc.command = ["python3", Directories.scriptsDir + "/beats_daemon.py"].concat(args);
        mainProc.running = true;
    }
    function getCurrentLibraryPath() {
        return "/mnt/Data/General_Archive/Music";
    }

    function terminatePlayer() {
        if (root.player)
            NoonUtils.execDetached(["killall", root.player.dbusName]);
    }
    function stopPlayer() {
        root.player.stop();
    }

    function previewURL(url) {
        _daemonCmd(["--player", "preview", "play-url", "--url", url]);
    }

    function killPreview() {
        _daemonCmd(["--player", "preview", "stop"]);
    }

    function currentTrackProgressRatio() {
        const pos = player?.position ?? 0;
        const len = player?.length ?? 0;
        const ratio = len > 0 ? Math.max(0.0, Math.min(1.0, pos / len)) : 0.0;
        if (ratio >= 1) {
            getQueue();
        }
        return ratio;
    }

    function moveQueueItemByMpdIdx(fromMpdIdx, toMpdIdx) {
        _daemonCmd(["--player", "main", "queue-move", "--index", `${fromMpdIdx}`, "--new-index", `${toMpdIdx}`]);
        moveQueueTimer.restart();
    }

    function moveQueueItem(fromUiIndex, toUiIndex) {
        const q = queue;
        if (!q || fromUiIndex < 0 || fromUiIndex >= q.length || toUiIndex < 0 || toUiIndex >= q.length)
            return;
        const fromMpdIdx = q[fromUiIndex]?.index;
        const toMpdIdx = q[toUiIndex]?.index;
        if (fromMpdIdx == null || toMpdIdx == null)
            return;
        moveQueueItemByMpdIdx(fromMpdIdx, toMpdIdx);
    }

    function getQueue() {
        if (queueFetcher.running || !root.player.dbusName.includes("mpd"))
            return;
        queueFetcher.running = true;
    }

    function cycleRepeat() {
        const p = root.player;
        if (!p?.canControl)
            return;
        p.loopState = ({
                [MprisLoopState.None]: MprisLoopState.Playlist,
                [MprisLoopState.Playlist]: MprisLoopState.Track,
                [MprisLoopState.Track]: MprisLoopState.None
            })[p.loopState] ?? MprisLoopState.None;
    }

    function isRealPlayer(player) {
        if (!player || !player.dbusName)
            return false;
        if (!filterPlayersEnabled)
            return true;
        const name = player.dbusName.toLowerCase();
        return !excludedPlayers.some(p => name.includes(p.toLowerCase()));
    }

    function isCurrentPlayer() {
        return player?.desktopEntry?.toLowerCase() === "mpd";
    }

    function downloadCurrentSong() {
        dlpHelperProc.command = ["bash", "-c", `${Directories.scriptsDir}/dlpHelper.sh --download-song "${root.title}" "${root.artist}" "${info.destination}"`];
        dlpHelperProc.running = true;
    }

    function downloadSong(downloadURL) {
        downloadWithDLP({
            parameters: "bestaudio/best|-x --audio-format mp3 --audio-quality 0  --embed-thumbnail --add-metadata",
            destination: FileUtils.trimFileProtocol(root.tracksDir),
            url: downloadURL
        });
    }

    function downloadWithDLP(info) {
        dlpHelperProc.command = ["bash", "-c", `${Directories.scriptsDir}/dlpHelper.sh '${info.parameters}' '${info.url}' '${info.destination}'`];
        dlpHelperProc.running = true;
    }
    function openUrl() {
        Qt.openUrlExternally("http://localhost:" + daemonOptions.players.webClient.port);
    }
    function openWebClient() {
        if (!webClientProc.running) {
            webClientProc.running = true;
        } else {
            openUrl();
        }
    }

    Connections {
        target: player
        enabled: false // root.queue.length === 0 && root.player && root.player.dbusName.includes("mpd")
        function onTrackTitleChanged() {
            root.getQueue();
        }
        function onShuffleChanged() {
            root.getQueue();
        }
    }

    Timer {
        id: positionTimer
        interval: 1000
        repeat: true
        running: root.player && root._playing
        onTriggered: root.player.positionChanged()
    }
    Process {
        id: webClientProc
        command: [...baseCmd, "serve", "--port", daemonOptions.players.webClient.port]
        onStarted: openUrl()
    }
    Process {
        id: mainProc
        command: [...baseCmd, "--player", "main", ""]
    }

    Fetcher {
        id: libraryFetcher
        command: [...baseCmd, "--player", "main", "library"]
    }

    Fetcher {
        id: queueFetcher
        command: [...baseCmd, "queue", "--player", "main"]
    }

    Timer {
        id: moveQueueTimer
        interval: 350
        onTriggered: getQueue()
    }

    Process {
        id: dlpHelperProc
    }

    ConfigFileView {
        id: daemonView
        state: false
        fileName: "beats"
        onContentChanged: _daemonCmd(["refresh-config"])
        BeatsSchema {}
    }

    FileSystemWatcher {
        folder: root.tracksDir
        onContentsChanged: {
            refreshTracks();
        }
    }

    SourceDownloader {
        id: coverFetch
        active: root.artUrl.startsWith("http") || root.artUrl.startsWith("https")
        input: root.artUrl
    }

    PaletteGenerator {
        id: palette
        active: root._playing && Mem.options.mediaPlayer.adaptiveTheme
        source: coverFetch.output || root.artUrl
    }
}
