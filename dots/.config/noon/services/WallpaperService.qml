pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Qt.labs.folderlistmodel
import qs.store
import qs.common
import qs.common.utils
import qs.common.functions
import qs.services

Singleton {
    id: root

    readonly property string currentWallpaper: Mem.states.desktop.bg.currentBg ?? "root:///assets/images/default_wallpaper.png"
    readonly property string currentFgPath: FileUtils.trimFileProtocol(Directories.wallpapers.depthDir + Qt.md5(FileUtils.trimFileProtocol(currentWallpaper)) + ".png")
    readonly property string shellMode: Mem.states.desktop.appearance.mode
    readonly property string currentFolderPath: Mem.states.desktop.bg.currentFolder
    readonly property FolderListModel wallpaperModel: _wallpaperModel
    readonly property bool isBright: Mem.states.desktop.bg.isBright
    property var _thumbnailCache: ({})
    property var wallpaperSelectorCachedModel
    property string thumbnailSize: "large"
    property alias _generatingThumbnails: thumbnailGenerator.running
    readonly property bool _loaded: {
        if (currentWallpaper.length > 1 && Mem.options.desktop.bg.useQs) {
            if (Mem.options.desktop.bg.deloadOnFullscreen && !Mem.states.desktop.bg.isLive) {
                return !GlobalStates?.topLevel?.fullscreen ?? true;
            } else {
                return !Mem.states.desktop.bg.isLive;
            }
        }
        return true;
    }
    signal thumbnailsDone
    Component.onCompleted: refreshFolderDelayed()
    onCurrentFolderPathChanged: {
        refreshFolderDelayed();
        if (_thumbnailCache.length <= 0)
            generateThumbnailsForCurrentFolder();
    }

    Timer {
        id: folderRefreshTimer
        interval: Mem.options.hacks.arbitraryRaceConditionDelay
        onTriggered: _wallpaperModel.folder = currentFolderPath
    }

    Process {
        id: thumbnailGenerator
        running: false
        onExited: exitcode => {
            if (exitcode === 0)
                thumbnailsDone();
        }
        stdout: StdioCollector {
            onStreamFinished: _thumbnailCache = {}
        }
    }

    function generateThumbnails(directory) {
        if (thumbnailGenerator.running)
            return false;

        const cleanDir = FileUtils.trimFileProtocol(directory);
        // Aligned with thumbnail script: -d (dir), -s (size), -w (workers), -i (only images flag)
        const cmd = ["python3", Directories.wallpapers.thumbScript, "-d", cleanDir, "-s", thumbnailSize, "-i"];
        thumbnailGenerator.command = cmd;
        thumbnailGenerator.running = true;
        return true;
    }

    function getThumbnailPath(fileUrl) {
        if (!fileUrl?.startsWith("file://"))
            return fileUrl;

        const cacheKey = `${fileUrl}`;
        if (_thumbnailCache[cacheKey])
            return _thumbnailCache[cacheKey];

        let cleanPath = FileUtils.trimFileProtocol(fileUrl);
        if (!cleanPath.startsWith("/"))
            cleanPath = "/" + cleanPath;

        const encodedUri = `file://${encodeURI(cleanPath)}`;
        const hash = Qt.md5(encodedUri);

        const sizeDirMap = {
            "normal": "normal",
            "large": "large",
            "x-large": "x-large",
            "xx-large": "xx-large"
        };
        const sizeDir = sizeDirMap[thumbnailSize];
        const thumbnailPath = `${FileUtils.trimFileProtocol(Directories.standard.home)}/.cache/thumbnails/${sizeDir}/${hash}.png`;

        _thumbnailCache[cacheKey] = `file://${thumbnailPath}`;
        return _thumbnailCache[cacheKey];
    }

    function generateThumbnailsForCurrentFolder() {
        generateThumbnails(currentFolderPath);
    }

    function clearThumbnailCache() {
        _thumbnailCache = {};
    }

    function updateShellMode(mode) {
        NoonUtils.execDetached(`python3 ${Directories.wallpapers.switchScript} --noswitch -f --mode '${mode}'`);
    }

    function toggleShellMode() {
        NoonUtils.execDetached(`python3 ${Directories.wallpapers.switchScript} --noswitch -f --mode toggle`);
    }

    function updateScheme(selectedMode) {
        NoonUtils.execDetached(`python3 ${Directories.wallpapers.switchScript} --noswitch -f --scheme '${selectedMode}'`);
    }

    function refreshFolderDelayed() {
        _wallpaperModel.refreshFolder();
    }

    function resetWallpaper() {
        applyWallpaper("root:///assets/images/default_wallpaper.png");
    }

    function pickAccentColor() {
        NoonUtils.execDetached(`python3 ${Directories.wallpapers.switchScript} --pick`);
    }

    function changeAccentColor(color: string) {
        NoonUtils.execDetached(`python3 ${Directories.wallpapers.switchScript} --color '${color}'`);
    }

    function applyWallpaper(fileUrl) {
        const cleanPath = FileUtils.trimFileProtocol(fileUrl);
        const thumbUrl = getThumbnailPath(fileUrl);
        const cleanThumb = FileUtils.trimFileProtocol(thumbUrl);

        let cmd = `python3 ${Directories.wallpapers.switchScript} --image '${cleanPath}'`;

        if (cleanThumb && cleanThumb !== cleanPath)
            cmd += ` --extract-col-from '${cleanThumb}'`;

        NoonUtils.execDetached(cmd);
    }

    function applyRandomWallpaper() {
        if (_wallpaperModel.count <= 0)
            return;
        NoonUtils.execDetached(`python3 ${Directories.wallpapers.switchScript} --random-no-recursive -R '${FileUtils.trimFileProtocol(currentFolderPath)}'`);
    }

    function shuffleWallpapers() {
        if (_wallpaperModel.count <= 0)
            return;
        let indices = [];
        for (let i = 0; i < _wallpaperModel.count; i++) {
            indices.push(i);
        }

        // Fisher-Yates shuffle
        for (let i = indices.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [indices[i], indices[j]] = [indices[j], indices[i]];
        }

        _wallpaperModel.filteredIndices = indices;
        _wallpaperModel.isFiltering = true;
        _wallpaperModel.modelUpdated();
    }

    function goBack() {
        const currentDir = Mem.states.desktop.bg.currentFolder;
        const parentDir = FileUtils.parentDirectory(currentDir);
        if (parentDir && parentDir !== currentDir)
            Mem.states.desktop.bg.currentFolder = parentDir;
    }

    FolderListModel {
        id: _wallpaperModel

        property var filteredIndices: []
        property bool isFiltering: false
        property var _preparedCache: ({})

        signal modelUpdated

        folder: currentFolderPath
        nameFilters: NameFilters.picture
        showDirs: false
        showFiles: true
        sortField: FolderListModel.Name
        caseSensitive: true

        onCountChanged: {
            modelUpdated();
            _preparedCache = {};
            generateThumbnailsForCurrentFolder();
        }

        onFolderChanged: modelUpdated()

        function refreshFolder() {
            filteredIndices = [];
            isFiltering = false;
            _preparedCache = {};
            folder = "";
            folderRefreshTimer.start();
        }

        function isVideo(index) {
            const fileUrl = get(index, "fileUrl");
            if (!fileUrl)
                return false;

            const fileName = fileUrl.toString().toLowerCase();
            const videoExtensions = [".mp4", ".mov", ".m4v", ".avi", ".mkv", ".webm"];
            return videoExtensions.some(ext => fileName.endsWith(ext));
        }

        function getFile(index) {
            if (isFiltering && index >= 0 && index < filteredIndices.length)
                return get(filteredIndices[index], "fileUrl");
            return get(index, "fileUrl");
        }

        function prepareTargets() {
            _preparedCache = {};
            for (let i = 0; i < count; i++) {
                const fileName = get(i, "fileName").toString();
                _preparedCache[i] = Fuzzy.prepare(fileName);
            }
        }

        function filterWallpapers(query) {
            if (!query || query.trim() === "") {
                clearFilter();
                return;
            }

            if (Object.keys(_preparedCache).length === 0)
                prepareTargets();

            let targets = [];
            for (let i = 0; i < count; i++) {
                targets.push({
                    index: i,
                    prepared: _preparedCache[i]
                });
            }

            const results = Fuzzy.go(query, targets, {
                key: 'prepared',
                threshold: -10000,
                limit: 500,
                all: false
            });

            filteredIndices = results.map(result => result.obj.index);
            isFiltering = true;
            modelUpdated();
        }

        function clearFilter() {
            filteredIndices = [];
            isFiltering = false;
            modelUpdated();
        }
    }
}
