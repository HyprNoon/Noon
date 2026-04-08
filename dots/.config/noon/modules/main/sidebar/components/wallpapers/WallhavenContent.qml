import QtQuick
import Quickshell
import Quickshell.Io
import qs.common
import qs.common.functions
import qs.common.widgets
import qs.services

StyledRect {
    id: root
    visible: opacity > 0
    opacity: width > 320 ? 1 : 0
    color: Colors.colLayer1
    radius: Rounding.verylarge
    clip: true

    property string query: ""
    property string _debouncedQuery: ""
    property var wallhavenResults: []
    property bool isLoading: false
    property int currentPage: 1
    property bool hasMore: true
    property string apiKey: ""
    property string downloadingId: ""
    property int selectedCategory: 0

    property var categories: [
        {
            label: "Hot",
            icon: "mode_heat",
            sorting: "toplist",
            range: "1w"
        },
        {
            label: "Latest",
            icon: "app_badging",
            sorting: "date_added",
            range: ""
        },
        {
            label: "Top",
            icon: "social_leaderboard",
            sorting: "toplist",
            range: "1M"
        },
        {
            label: "Views",
            icon: "play_arrow",
            sorting: "views",
            range: ""
        },
        {
            label: "Random",
            icon: "shuffle",
            sorting: "random",
            range: ""
        }
    ]

    signal searchFocusRequested
    signal contentFocusRequested
    signal dismiss

    onQueryChanged: debounceTimer.restart()
    Component.onCompleted: root.fetchWallpapers()

    Timer {
        id: debounceTimer
        interval: 400
        repeat: false
        onTriggered: {
            root._debouncedQuery = root.query.trim();
            root.currentPage = 1;
            root.wallhavenResults = [];
            root.fetchWallpapers();
        }
    }

    onContentFocusRequested: listView.forceActiveFocus()

    function fetchWallpapers() {
        if (root.isLoading)
            return;
        root.isLoading = true;

        const cat = root.categories[root.selectedCategory];
        const query = root._debouncedQuery;

        let url = "https://wallhaven.cc/api/v1/search" + "?sorting=" + cat.sorting + "&page=" + root.currentPage + "&categories=110" + "&purity=100";

        if (query)
            url += "&q=" + encodeURIComponent(query);

        if (cat.range)
            url += "&toplist_range=" + cat.range;

        if (root.apiKey)
            url += "&apikey=" + root.apiKey;

        const xhr = new XMLHttpRequest();
        xhr.open("GET", url);
        xhr.onreadystatechange = function () {
            if (xhr.readyState !== XMLHttpRequest.DONE)
                return;
            root.isLoading = false;

            if (xhr.status !== 200)
                return;
            const json = JSON.parse(xhr.responseText);
            const items = json.data.map(function (w) {
                return {
                    id: w.id,
                    thumbUrl: w.thumbs.large,
                    fullUrl: w.path,
                    resolution: w.resolution,
                    fileType: w.file_type
                };
            });

            root.wallhavenResults = root.currentPage === 1 ? items : root.wallhavenResults.concat(items);

            root.hasMore = json.meta ? (json.meta.current_page < json.meta.last_page) : false;
        };
        xhr.send();
    }

    function loadMore() {
        if (!root.isLoading && root.hasMore) {
            root.currentPage++;
            root.fetchWallpapers();
        }
    }

    function selectCategory(index) {
        if (root.selectedCategory === index)
            return;
        root.selectedCategory = index;
        root.currentPage = 1;
        root.wallhavenResults = [];
        root.fetchWallpapers();
    }

    function downloadAndApply(item) {
        const ext = item.fileType.split("/")[1] || "jpg";
        const fileName = "wallhaven-" + item.id + "." + ext;
        const destPath = FileUtils.trimFileProtocol(WallpaperService.currentFolderPath + "/" + fileName);
        const destUrl = "file://" + destPath;

        root.downloadingId = item.id;
        downloader.command = ["curl", "-L", "-s", "-o", destPath, item.fullUrl];
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
                load_timer.restart();
            }
        }
    }

    Timer {
        id: load_timer
        interval: 800
        onTriggered: {
            if (WallpaperService.wallpaperModel)
                WallpaperService.wallpaperModel.refresh();
        }
    }
    StyledText {
        id: err
        anchors.centerIn: parent
        font.pixelSize: 50
    }
    StyledListView {
        id: listView
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: categoryBar.top
            bottomMargin: Padding.small
        }

        animateAppearance: true
        animateMovement: true
        popin: true
        spacing: Padding.small
        hint: false
        model: root.wallhavenResults
        highlightFollowsCurrentItem: true
        highlightMoveDuration: 300

        onContentYChanged: {
            if (contentHeight > 0 && contentY + height >= contentHeight - height * 0.5)
                root.loadMore();
        }

        delegate: Item {
            id: delegateItem
            required property int index
            required property var modelData

            implicitWidth: listView.width
            implicitHeight: width * 9 / 16

            WallpaperItem {
                id: wallpaperItem
                anchors.fill: parent
                isKeyboardSelected: listView.currentIndex === index
                isCurrentWallpaper: WallpaperService.currentWallpaper.toString().includes("wallhaven-" + modelData.id + ".")
                fileUrl: modelData.thumbUrl
                applyAction: () => {
                    root.downloadAndApply(modelData);
                }
                StyledRect {
                    z: 999
                    anchors {
                        bottom: parent.bottom
                        left: parent.left
                        margins: Padding.large
                    }
                    width: resLabel.implicitWidth + Padding.large
                    height: resLabel.implicitHeight + Padding.normal
                    radius: Rounding.normal
                    color: Colors.colPrimary
                    visible: root.downloadingId !== modelData.id

                    StyledText {
                        id: resLabel
                        anchors.centerIn: parent
                        text: modelData.resolution
                        font.pixelSize: 10
                        color: Colors.colOnPrimary
                    }
                }
            }

            StyledRect {
                anchors.fill: parent
                radius: parent.height * 0.05
                color: Colors.colLayer0
                opacity: root.downloadingId === modelData.id ? 0.65 : 0

                Symbol {
                    anchors.centerIn: parent
                    text: "downloading"
                    font.pixelSize: 32
                    color: Colors.colPrimary
                    visible: parent.opacity > 0
                }
            }

            StyledRectangularShadow {
                target: wallpaperItem
                enabled: wallpaperItem.isKeyboardSelected
            }
        }

        Keys.onPressed: event => {
            if (event.key === Qt.Key_Slash) {
                root.searchFocusRequested();
            } else if (event.key === Qt.Key_Up) {
                if (currentIndex <= 0) {
                    currentIndex = -1;
                    root.searchFocusRequested();
                } else {
                    currentIndex--;
                }
            } else if (event.key === Qt.Key_Down) {
                if (currentIndex < count - 1)
                    currentIndex++;
            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                if (currentIndex >= 0) {
                    const item = root.wallhavenResults[currentIndex];
                    if (item)
                        root.downloadAndApply(item);
                }
            } else if (event.key === Qt.Key_Escape) {
                root.dismiss();
            } else {
                return;
            }
            event.accepted = true;
        }
    }

    StyledRect {
        id: categoryBar
        anchors {
            right: parent.right
            bottom: parent.bottom
            margins: Padding.small
        }
        width: categoryRow.implicitWidth + Padding.massive
        height: categoryRow.implicitHeight + Padding.massive
        color: Colors.colLayer3
        radius: Rounding.full

        ListView {
            id: categoryRow
            anchors.centerIn: parent
            implicitWidth: contentItem.childrenRect.width
            implicitHeight: contentItem.childrenRect.height
            spacing: Padding.small
            clip: true
            model: root.categories

            delegate: StyledRect {
                required property int index
                required property var modelData

                implicitHeight: symb.implicitHeight + Padding.large * 2
                implicitWidth: symb.implicitWidth + Padding.large * 2
                radius: Rounding.large
                color: root.selectedCategory === index ? Colors.colPrimary : Colors.colLayer4

                Symbol {
                    id: symb
                    anchors.centerIn: parent
                    text: modelData.icon
                    fill: root.selectedCategory === index ? 1 : 0
                    font.pixelSize: Fonts.sizes.normal
                    color: root.selectedCategory === index ? Colors.colOnPrimary : Colors.colOnLayer4
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.selectCategory(index)
                }
            }
        }
    }

    PagePlaceholder {
        shown: !root.isLoading && listView.count === 0
        title: qsTr("No wallpapers found")
        icon: "image_not_supported"
        anchors.centerIn: parent
    }
}
