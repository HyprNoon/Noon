pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.common
import qs.common.functions
import qs.services
import "wallpapers"

Singleton {
    id: root

    property var methods: [
        {
            name: "wallhaven",
            api: wallhavenApi
        },
        {
            name: "unsplash",
            api: unsplashApi
        }
    ]

    readonly property string currentMethod: Mem.options.services.wallpapers.method
    readonly property QtObject api: methods.find(method => method.name === currentMethod)?.api ?? wallhavenMethod

    property var results: []

    property bool isLoading: false
    property bool hasMore: true
    property string downloadingId: ""
    property int selectedCategory: 0
    property int _currentPage: 1

    readonly property var categories: api.categories

    property string query: ""

    onQueryChanged: _doFetch(1, true)

    Component.onCompleted: {
        root._doFetch(1, true);
    }

    onCurrentMethodChanged: {
        root.query = "";
        root.selectedCategory = 0;
        root._currentPage = 1;
        root.results = [];
        root._doFetch(1, true);
    }
    function search(query) {
        root.query = query;
    }
    function _doFetch(page, reset) {
        if (root.isLoading)
            return;
        root.isLoading = true;

        const url = api.buildUrl(page, root.query, root.selectedCategory);
        const existing = reset ? [] : root.results.slice();

        const xhr = new XMLHttpRequest();
        xhr.open("GET", url);

        if (root.currentApiIndex === 1)
            xhr.setRequestHeader("Accept-Version", "v1");

        xhr.onreadystatechange = function () {
            if (xhr.readyState !== XMLHttpRequest.DONE)
                return;
            root.isLoading = false;
            if (xhr.status !== 200)
                return;
            const json = JSON.parse(xhr.responseText);
            const items = api.normalizeResults(json.data ?? json);
            root.results = page === 1 ? items : existing.concat(items);
            root.hasMore = api.parseHasMore(json.meta ?? json);
            root._currentPage = page;
        };
        xhr.send();
    }

    function loadMore() {
        if (!root.isLoading && root.hasMore)
            root._doFetch(root._currentPage + 1, false);
    }

    function selectCategory(index) {
        if (root.selectedCategory === index)
            return;
        root.selectedCategory = index;
        root.results = [];
        root._doFetch(1, true);
    }

    function downloadAndApply(item) {
        const info = api.resolveDownloadInfo(item);
        const destPath = FileUtils.trimFileProtocol(WallpaperService.currentFolderPath + "/" + info.fileName);
        const destUrl = "file://" + destPath;

        root.downloadingId = item.id;
        downloader.command = ["curl", "-L", "-s", "-o", destPath, info.fullUrl];
        downloader._pendingUrl = destUrl;
        downloader.running = true;
    }

    Process {
        id: downloader
        property string _pendingUrl: ""

        onExited: function (code) {
            root.downloadingId = "";
            if (code === 0) {
                WallpaperService.applyWallpaper(_pendingUrl);
                NoonUtils.playSound("event_accepted");
                refreshTimer.restart();
            }
        }
    }

    Timer {
        id: refreshTimer
        interval: 800
        onTriggered: {
            if (WallpaperService.wallpaperModel)
                WallpaperService.wallpaperModel.refresh();
        }
    }
    WallhavenApi {
        id: wallhavenApi
    }
    UnsplashApi {
        id: unsplashApi
    }
}
