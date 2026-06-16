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
    readonly property bool fgReady: FileUtils.exists(currentFgPath)
    readonly property string currentWallpaper: Mem.looks.currentBg ?? "root:///assets/images/default_wallpaper.png"
    readonly property string currentFgPath: clean(Directories.wallpapers.depthDir + Qt.md5(clean(currentWallpaper)) + ".png")
    readonly property string shellMode: Mem.looks.mode
    readonly property string currentFolderPath: Mem.looks.currentFolder
    readonly property FolderListModel wallpaperModel: _wallpaperModel
    readonly property bool isBright: Mem.looks.isBright
    readonly property var baseCmd: ["python3", Directories.wallpapers.colGenScript]
    property var _thumbnailCache: ({})
    property var wallpaperSelectorCachedModel
    property string thumbnailSize: "large"
    property alias _generatingThumbnails: thumbnailGenerator.running
    readonly property bool _loaded: {
        if (currentWallpaper.length > 1) {
            if (Mem.options.desktop.bg.deloadOnFullscreen && !Mem.looks.isLive) {
                return !Globals?.topLevel?.fullscreen ?? true;
            } else {
                return !Mem.looks.isLive;
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
    function clean(fileUrl) {
        return FileUtils.trimFileProtocol(fileUrl);
    }
    function generateThumbnails(directory) {
        if (thumbnailGenerator.running)
            return false;

        const cleanDir = clean(directory);
        const cmd = ["python3", Directories.wallpapers.thumbScript, "-d", cleanDir, "-s", thumbnailSize];
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

        let cleanPath = clean(fileUrl);
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
        const thumbnailPath = `${clean(Directories.standard.home)}/.cache/thumbnails/${sizeDir}/${hash}.png`;

        _thumbnailCache[cacheKey] = `file://${thumbnailPath}`;
        return _thumbnailCache[cacheKey];
    }

    function refreshFolderDelayed() {
        _wallpaperModel.refreshFolder();
    }

    function generateThumbnailsForCurrentFolder() {
        generateThumbnails(currentFolderPath);
    }

    function clearThumbnailCache() {
        _thumbnailCache = {};
    }

    function updateShellMode(mode) {
        _cmd("mode", `${mode}`);
    }

    function toggleShellMode() {
        _cmd("mode", "toggle");
    }

    function updateScheme(selectedMode) {
        _cmd("set", `${clean(root.currentWallpaper)}`, "--scheme", `${selectedMode}`);
    }

    function resetWallpaper() {
        applyWallpaper(Directories.shellDir + "/assets/images/default_wallpaper.png");
    }

    function _cmd(...args) {
        if (mainProc.running)
            mainProc.running = false
        mainProc.command = [...baseCmd, ...args];
        mainProc.running = true;
    }

    function pickAccentColor() {
        _cmd("pick");
    }

    function changeAccentColor(color) {
        _cmd("color", `${color}`);
    }

    function changeAccentFromSource(file) {
        _cmd("set", `${clean(file)}`);
    }

    function setSystemWallpaper(file) {
        Mem.looks.currentBg = `${file}`;
    }

    function applyWallpaper(fileUrl) {
        const thumbUrl = getThumbnailPath(fileUrl);
        const cleanThumb = clean(thumbUrl);
        setSystemWallpaper(fileUrl);
        if (!ColorsService.isDynamic)
            changeAccentColor(ColorsService.colors.m3primary);
        else if (cleanThumb && cleanThumb !== fileUrl)
            changeAccentFromSource(cleanThumb);
        else if (ColorsService.isDynamic)
            changeAccentFromSource();
    }

    function applyRandomWallpaper() {
        if (_wallpaperModel.count > 0)
            applyWallpaper(_wallpaperModel.get(Math.floor(Math.random() * _wallpaperModel.count),"fileUrl"));
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
        const currentDir = Mem.looks.currentFolder;
        const parentDir = FileUtils.parentDirectory(currentDir);
        if (parentDir && parentDir !== currentDir)
            Mem.looks.currentFolder = parentDir;
    }

    FolderListModel {
        id: _wallpaperModel

        property var filteredIndices: []
        property bool isFiltering: false
        property var _preparedCache: ({})

        signal modelUpdated

        folder: currentFolderPath
        nameFilters: [...NameFilters.picture,...NameFilters.video]
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
    Process {
        id: mainProc
    }
}
