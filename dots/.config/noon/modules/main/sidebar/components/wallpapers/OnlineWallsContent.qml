import QtQuick
import qs.common
import qs.common.widgets
import qs.services
import qs.services.wallpapers

StyledRect {
    id: root
    visible: opacity > 0
    opacity: width > 320 ? 1 : 0
    color: Colors.colLayer1
    radius: Rounding.verylarge
    clip: true

    property string query: ""
    property string _debouncedQuery: ""

    signal searchFocusRequested
    signal contentFocusRequested
    signal dismiss

    onQueryChanged: debounceTimer.restart()
    onContentFocusRequested: listView.forceActiveFocus()

    Timer {
        id: debounceTimer
        interval: 200
        repeat: false
        onTriggered: {
            root._debouncedQuery = root.query.trim();
            OnlineWallpaperService.search(root._debouncedQuery);
        }
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
        model: OnlineWallpaperService.results
        highlightFollowsCurrentItem: true
        highlightMoveDuration: 300

        onContentYChanged: {
            if (contentHeight > 0 && contentY + height >= contentHeight - height * 0.25)
                OnlineWallpaperService.loadMore();
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
                isCurrentWallpaper: WallpaperService.currentWallpaper.toString().includes(modelData.id + ".")
                fileUrl: modelData.thumbUrl
                applyAction: () => OnlineWallpaperService.downloadAndApply(modelData)

                StyledRect {
                    z: 999
                    anchors {
                        bottom: parent.bottom
                        right: parent.right
                        margins: Padding.large
                    }
                    width: resLabel.implicitWidth + Padding.large
                    height: resLabel.implicitHeight + Padding.normal
                    radius: Rounding.normal
                    color: Colors.colPrimary
                    visible: OnlineWallpaperService.downloadingId !== modelData.id

                    StyledText {
                        id: resLabel
                        anchors.centerIn: parent
                        text: modelData.resolution
                        font.pixelSize: Fonts.sizes.verysmall
                        color: Colors.colOnPrimary
                    }
                }
            }

            StyledRect {
                anchors.fill: parent
                radius: parent.height * 0.05
                color: Colors.colLayer0
                opacity: OnlineWallpaperService.downloadingId === modelData.id ? 0.65 : 0

                MaterialLoadingIndicator {
                    z: 999
                    loading: parent.opacity > 0
                    anchors.centerIn: parent
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
                    const item = OnlineWallpaperService.results[currentIndex];
                    if (item)
                        OnlineWallpaperService.downloadAndApply(item);
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
            model: OnlineWallpaperService.categories

            delegate: StyledRect {
                required property int index
                required property var modelData

                implicitHeight: symb.implicitHeight + Padding.large * 2
                implicitWidth: symb.implicitWidth + Padding.large * 2
                radius: Rounding.large
                color: OnlineWallpaperService.selectedCategory === index ? Colors.colPrimary : Colors.colLayer4

                Symbol {
                    id: symb
                    anchors.centerIn: parent
                    text: modelData.icon
                    fill: OnlineWallpaperService.selectedCategory === index ? 1 : 0
                    font.pixelSize: Fonts.sizes.normal
                    color: OnlineWallpaperService.selectedCategory === index ? Colors.colOnPrimary : Colors.colOnLayer4
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: OnlineWallpaperService.selectCategory(index)
                }
            }
        }
    }

    PagePlaceholder {
        shown: !OnlineWallpaperService.isLoading && listView.count === 0
        title: "No wallpapers found"
        icon: "image_not_supported"
        anchors.centerIn: parent
    }
}
