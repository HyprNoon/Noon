import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.utils
import qs.common.widgets
import QtMultimedia

StyledRect {
    id: root
    required property var window
    property string filePath: ""
    radius: Rounding.large
    color: "transparent"
    clip: true

    function play(filePath) {
        vid.source = Qt.resolvedUrl(filePath);
        vid.play();
    }

    Video {
        id: vid
        anchors.fill: parent
        loops: 1
        fillMode: VideoOutput.PreserveAspectCrop
        autoPlay: false
        property bool _playing: source !== null && playbackState === MediaPlayer.PlayingState
        on_PlayingChanged: overlay.show("toggle_playing")
        MouseArea {
            anchors.fill: parent
            onClicked: {
                video.play();
            }
            DropArea {
                anchors.fill: parent
                keys: ["text/uri-list"]
                onDropped: drop => {
                    let newPaths = drop.urls.map(url => url.toString());
                    Globals.applications.mediaplayer.queue = [...Globals.applications.mediaplayer.queue, ...newPaths];
                    Qt.callLater(() => root.play(Globals.applications.mediaplayer.queue[0]));
                    console.log("Dropped files:", newPaths);
                }
            }
        }
        MouseArea {
            id: controlsHoverArea
            z: 999
            implicitHeight: 50
            anchors {
                right: parent.right
                left: parent.left
                bottom: parent.bottom
            }
            hoverEnabled: true
            propagateComposedEvents: true
            onEntered: {
                controls.visible = true;
                hideControlsTimer.running = false;
            }
            onExited: {
                hideControlsTimer.running = true;
            }
        }
        focus: true
        Keys.onSpacePressed: video.playbackState == MediaPlayer.PlayingState ? video.pause() : video.play()
        Keys.onLeftPressed: video.position = video.position - 5000
        Keys.onRightPressed: video.position = video.position + 5000
    }
    MediaPlayerControls {
        id: controls
        player: vid
        window: root.window
    }
    MediaPlayerOverlay {
        id: overlay
        player: vid
    }
    Timer {
        id: hideControlsTimer
        interval: 3000
        onTriggered: controls.hide()
    }
    Timer {
        running: overlay.visible
        interval: 1000
        onTriggered: overlay.hide()
    }
    PagePlaceholder {
        implicitWidth: 400
        implicitHeight: 400
        anchors.centerIn: parent
        icon: "play_arrow"
        shown: !vid.hasVideo
        title: "No Active Media"
        description: "Select or Drop a media file to play."
    }
}
