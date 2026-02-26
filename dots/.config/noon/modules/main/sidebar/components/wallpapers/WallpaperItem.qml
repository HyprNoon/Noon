import QtQuick.Controls.Material
import QtQuick
import QtQuick.Layouts
import Quickshell
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
    readonly property bool isVideoFile: {
        const name = fileUrl.toString().toLowerCase();
        for (let i = 0; i < NameFilters.video.length; i++) {
            if (name.endsWith(NameFilters.video[i]))
                return true;
        }
        return false;
    }

    readonly property Component imageComp: StyledImage {}
    readonly property Component vidComp: VideoPreview {
        Symbol {
            text: "play_arrow"
            color: Colors.colOnBackground
            font.pixelSize: 20
            fill: 1
            anchors {
                top: parent.top
                right: parent.right
                margins: 8
            }
        }
    }

    anchors.fill: parent
    anchors.margins: isKeyboardSelected ? Padding.massive : Padding.large
    radius: Rounding.large
    color: "transparent"
    clip: true

    Behavior on anchors.margins {
        Anim {}
    }

    StyledLoader {
        id: _loader
        z: 10
        anchors.fill: parent
        sourceComponent: isVideoFile ? vidComp : imageComp
        onLoaded: if (ready) {
            if (!isVideoFile)
                item.source = Qt.binding(() => WallpaperService.getThumbnailPath(wallpaperItem.fileUrl));
            else
                item.source = Qt.binding(() => Qt.resolvedUrl(wallpaperItem.fileUrl));
        }
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
                WallpaperService.applyWallpaper(fileUrl);
        }
        onEntered: {
            if (isVideoFile && videoPlayer.playbackState !== MediaPlayer.PlayingState)
                videoPlayer.play();
        }
        onExited: {
            if (isVideoFile && videoPlayer.playbackState === MediaPlayer.PlayingState)
                videoPlayer.pause();
        }
    }

    RoundCorner {
        id: checkmark

        corner: cornerEnum.bottomRight
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
                        FileUtils.deleteItem(wallpaperItem.fileUrl);
                }
            }
        ]
    }
}
