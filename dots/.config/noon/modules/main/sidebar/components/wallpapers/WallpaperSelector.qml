import QtQuick
import Quickshell
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
    property string searchQuery: ""
    property string _debouncedQuery: ""

    signal searchFocusRequested
    signal contentFocusRequested
    signal dismiss

    onSearchQueryChanged: debounceTimer.restart()
    Component.onCompleted: load_timer.restart()

    Timer {
        id: debounceTimer
        interval: 120
        repeat: false
        onTriggered: root._debouncedQuery = root.searchQuery.trim()
    }

    onContentFocusRequested: listView.forceActiveFocus()

    function loadWallpapers() {
        const model = WallpaperService.wallpaperModel;
        if (!model)
            return;

        let wallpapers = new Array(model.count);
        let targetIndex = -1;
        const currentPath = WallpaperService.currentWallpaper.toString();

        for (let i = 0; i < model.count; i++) {
            const fileUrl = model.getFile(i);
            if (fileUrl) {
                const pathString = fileUrl.toString();
                wallpapers[i] = {
                    index: i,
                    fileUrl: fileUrl,
                    fileName: FileUtils.getEscapedFileName(fileUrl)
                };

                // Check if this is the active wallpaper
                if (pathString === currentPath) {
                    targetIndex = i;
                }
            }
        }

        WallpaperService.wallpaperSelectorCachedModel = wallpapers;

        // Scroll the list after the model updates
        if (targetIndex !== -1) {
            // Use Qt.callLater to ensure the view has processed the model change
            Qt.callLater(() => {
                listView.currentIndex = targetIndex;
                listView.positionViewAtIndex(targetIndex, ListView.Center);
            });
        }
    }

    ScriptModel {
        id: filteredModel

        values: {
            const baseData = WallpaperService.wallpaperSelectorCachedModel;
            if (!baseData || baseData.length === 0)
                return [];

            const query = root._debouncedQuery;
            if (!query)
                return baseData;

            const fuzzyResults = Fuzzy.go(query, baseData, {
                key: 'fileName',
                threshold: -10000,
                limit: 20
            });

            return fuzzyResults.map(r => r.obj);
        }
    }

    Timer {
        id: load_timer
        interval: 200
        onTriggered: loadWallpapers()
    }

    Connections {
        target: WallpaperService
        function onCurrentFolderPathChanged() {
            load_timer.restart();
        }
        function onThumbnailsDone() {
            load_timer.restart();
        }
    }
    Connections {
        target: WallpaperService.wallpaperModel
        function onModelUpdated() {
            load_timer.restart();
        }
    }
    StyledListView {
        id: listView

        anchors.fill: parent

        animateAppearance: true
        animateMovement: true
        popin: true

        spacing: Padding.small
        hint: false
        model: filteredModel
        currentIndex: filteredModel.values.indexOf(WallpaperService.currentWallpaper)
        highlightFollowsCurrentItem: true
        highlightMoveDuration: 300

        // onCurrentIndexChanged: {
        //     if (currentIndex >= 0) {
        //         WallpaperService.applyWallpaper(filteredModel.values[currentIndex].fileUrl.toString());
        //     }
        // }

        delegate: Item {
            id: loader
            z: 9999
            required property int index
            required property var modelData
            implicitWidth: listView.width
            implicitHeight: width * 9 / 16

            WallpaperItem {
                id: wallpaperItem
                isKeyboardSelected: listView.currentIndex === index
                isCurrentWallpaper: modelData.fileUrl.toString() === WallpaperService.currentWallpaper
                fileUrl: modelData.fileUrl
            }

            StyledRectangularShadow {
                target: wallpaperItem
                enabled: wallpaperItem.isKeyboardSelected
                show: wallpaperItem.isKeyboardSelected
            }
        }

        Keys.onPressed: event => {
            if (event.key === Qt.Key_Slash && root.focus) {
                root.searchFocusRequested();
            } else if (event.key === Qt.Key_Up) {
                if (currentIndex <= 0) {
                    currentIndex = -1;
                    root.searchFocusRequested();
                } else {
                    currentIndex--;
                }
            } else if (event.key === Qt.Key_Down) {
                if (currentIndex < count - 1) {
                    currentIndex++;
                }
            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                if (currentIndex >= 0) {
                    const selectedData = filteredModel.values[currentIndex];
                    if (selectedData && selectedData.fileUrl) {
                        WallpaperService.applyWallpaper(selectedData.fileUrl);
                        NoonUtils.playSound("event_accepted");
                    }
                }
            } else if (event.key === Qt.Key_Escape) {
                root.dismiss();
            } else
                return;

            event.accepted = true;
        }
    }

    WallpaperControls {}

    PagePlaceholder {
        shown: listView.count === 0
        title: qsTr("No wallpapers found")
        icon: "image_not_supported"
        anchors.centerIn: parent
    }
}
