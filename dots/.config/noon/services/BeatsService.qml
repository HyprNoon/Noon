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

Singleton {
    id: root
    readonly property alias socket: vlcSocket

    property int selectedPlayerIndex: 0
    property string currentTrackPath: ""
    property var tracksMetadata: ({})

    readonly property list<string> excludedPlayers: Mem.options.mediaPlayer?.excludedPlayers ?? []
    readonly property QtObject colors: palette.colors
    readonly property bool filterPlayersEnabled: false
    readonly property bool _connected: vlcSocket.connected
    readonly property bool _playing: player && player.playbackState === MprisPlaybackState.Playing
    readonly property string artUrl: player ? StringUtils.cleanMusicTitle(player.trackArtUrl) : ""
    readonly property string title: player ? StringUtils.cleanMusicTitle(player.trackTitle) : "No Title"
    readonly property string artist: player ? StringUtils.cleanMusicTitle(player.trackArtist) : "No Artist"
    readonly property string _tracksDir: Qt.resolvedUrl(Mem.states.mediaPlayer?.currentTrackPath ?? Directories.beats.tracks)
    readonly property string _metadataPath: _tracksDir + "/.metadata"
    readonly property string _playlistPath: _tracksDir + "/.playlist.m3u"
    readonly property var tracksInfo: {
        const map = {};
        for (const key in root.tracksMetadata) {
            const entry = root.tracksMetadata[key];
            if (entry?.filename)
                map[entry.filename] = entry;
        }
        return map;
    }

    readonly property var tracksList: Object.values(root.tracksMetadata)

    readonly property var currentTrackMeta: {
        if (!root.currentTrackPath)
            return null;
        const fileName = root.currentTrackPath.split("/").pop();
        return root.tracksInfo[fileName] ?? null;
    }

    readonly property MprisPlayer player: {
        const list = meaningfulPlayers;
        if (!list || list.length === 0)
            return null;
        return list[Math.max(0, Math.min(selectedPlayerIndex, list.length - 1))] || null;
    }

    readonly property var meaningfulPlayers: {
        const source = Mpris.players.values;
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

    function rebuildMetadata() {
        rebuildMetaProc.running = false;
        rebuildMetaProc.running = true;
    }

    function getTrackMeta(fileName) {
        return root.tracksInfo[fileName] ?? null;
    }

    function coverArtUrl(entry) {
        if (!entry?.cover_art)
            return "";
        return "file://" + root._tracksDir + "/" + entry.cover_art.replace(/^\.\//, "");
    }

    function startConnection() {
        if (vlcSocket.connected)
            return;
        Quickshell.execDetached(["vlc", "--intf", "oldrc", "--rc-unix", vlcSocket.path, "--rc-fake-tty", "--one-instance", "--no-video", FileUtils.trimFileProtocol(root._playlistPath)]);
        vlcSocket.reconnect();
    }

    function playTrack(index) {
        if (vlcSocket.connected) {
            vlcSocket.add("goto " + index);
        } else {
            vlcSocket.reconnect();
        }
    }

    function currentTrackProgressRatio() {
        const pos = player?.position ?? 0;
        const len = player?.length ?? 0;
        return len > 0 ? Math.max(0.0, Math.min(1.0, pos / len)) : 0.0;
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
        return player?.desktopEntry?.toLowerCase() === "vlc";
    }

    function stopPlayer() {
        NoonUtils.execDetached("killall " + player?.desktopEntry?.toLowerCase());
    }

    // function downloadCurrentSong() {
    //     downloadSong(root.title + " " + root.artist);
    // }

    Timer {
        id: positionTimer
        interval: 100
        repeat: true
        running: root.player && root._playing
        onTriggered: root.player.positionChanged()
    }

    Process {
        id: rebuildMetaProc
        command: ["python3", Directories.scriptsDir + "/build_metadata.py", FileUtils.trimFileProtocol(_tracksDir)]
    }

    function downloadWithDLP(info) {
        dlpHelperProc.command = ["bash", "-c", `${Directories.scriptsDir}/dlpHelper.sh '${info.parameters}' '${info.url}' '${info.destination}'`];
        dlpHelperProc.running = true;
    }
    function addNewFolder() {
        folderPicker.open();
    }
    Process {
        id: dlpHelperProc
    }

    FileView {
        id: metadataFile
        path: root._metadataPath
        blockWrites: false
        onTextChanged: root.tracksMetadata = JSON.parse(metadataFile.text())
        onLoadFailed: err => {
            if (err === FileViewError.FileNotFound) {
                rebuildMetadata();
            }
        }
    }

    UnixSocket {
        id: vlcSocket
        path: "/tmp/vlc.sock"
    }

    FolderDialog {
        id: folderPicker
        onAccepted: {
            let currentFolders = Mem.states.mediaPlayer.folders;
            if (!currentFolders.includes(selectedFolder)) {
                currentFolders.push(selectedFolder);
                Mem.states.mediaPlayer.folders = currentFolders;
            }
        }
    }

    FolderListModel {
        folder: root._tracksDir
        showDirs: false
        showFiles: true
        onCountChanged: {
            NoonUtils.toast(`Songs Count Changed`, "music_note");
            rebuildMetadata();
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
