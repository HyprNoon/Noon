import QtQuick
import qs.common
import qs.common.functions
import qs.common.utils
import qs.common.widgets
import qs.services

StyledRect {
    id: wallpaperItem

    required property string fileUrl
    property bool isKeyboardSelected: false
    property bool isCurrentWallpaper: false
    property var applyAction: () => WallpaperService.applyWallpaper(fileUrl)

    readonly property bool isVideoFile: {
        const vid = ["mp4", "mov", "m4v", "avi", "mkv", "webm"];
        for (const ext in vid) {
            if (fileUrl.endsWith(ext))
                return true;
        }
        return false;
    }

    anchors.fill: parent
    anchors.margins: isKeyboardSelected ? Padding.massive : Padding.large
    radius: Rounding.large
    color: "transparent"
    clip: true

    Behavior on anchors.margins {
        Anim {}
    }

    Symbol {
        z: 9999
        icon: "play_arrow"
        iconSize: 20
        visible: wallpaperItem.isVideoFile
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: Padding.large
        fill: 1
        color: Colors.colOnSurface
    }

    StyledImage {
        anchors.fill: parent
        source: WallpaperService.getThumbnailPath(wallpaperItem.fileUrl)
        sourceSize: undefined
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onPressed: event => {
            if (event.button === Qt.RightButton)
                wallpaperMenu.popup(event.x, event.y);
            else if (event.button === Qt.LeftButton)
                applyAction();
        }
    }

    RoundCorner {
        id: checkmark

        corner: RoundCorner.BottomRight
        size: 70
        color: Colors.m3.m3primary
        visible: isCurrentWallpaper
        z: 99

        anchors {
            bottom: parent.bottom
            right: parent.right
        }

        Symbol {
            z: 999
            text: "check"
            fill: 1
            color: Colors.m3.m3onPrimary
            font.pixelSize: 25
            anchors {
                bottom: parent.bottom
                right: parent.right
            }
        }
    }

    StyledMenu {
        id: wallpaperMenu

        content: [
            {
                "text": "Favorite",
                "materialIcon": "favorite",
                "action": function () {
                    if (wallpaperItem.fileUrl)
                        FileUtils.moveItem(wallpaperItem.fileUrl, Directories.wallpapers.favorite);
                }
            },
            {
                "text": "delete",
                "materialIcon": "delete",
                "action": function () {
                    if (wallpaperItem.fileUrl)
                        NoonUtils.deleteFile(wallpaperItem.fileUrl);
                }
            }
        ]
    }
}
