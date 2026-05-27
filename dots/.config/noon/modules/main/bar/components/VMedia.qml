import qs.common
import qs.common.widgets
import qs.services
import qs.store
import QtQuick
import QtQuick.Layouts
import Quickshell

BarGroup {
    id: root
    property var sink: AudioService.sink
    property real maxValue: 1.5

    Layout.fillWidth: true
    Layout.preferredHeight: width

    ClippedFilledCircularProgress {
        id: progress
        value: BeatsService.currentTrackProgressRatio()
        anchors.centerIn: parent
        implicitSize: root.width * 0.6

        Symbol {
            fill: 1
            anchors.centerIn: parent
            font.pixelSize: progress.implicitSize
            text: BeatsService?.isPlaying ? "pause" : "music_note"
            color: Colors.m3.m3onSecondaryContainer
        }
    }
    MediaPopup {
        hoverTarget: mouse
    }
    MouseArea {
        id: mouse
        anchors.fill: parent
        acceptedButtons: Qt.MiddleButton | Qt.BackButton | Qt.ForwardButton | Qt.RightButton | Qt.LeftButton
        hoverEnabled: true
        scrollGestureEnabled: true
        onWheel: wheel => {
            if (!root.sink || !root.sink.audio)
                return;
            var delta = wheel.angleDelta.y / 120;
            var newValue = root.sink.audio.volume + (delta * 0.05);
            root.sink.audio.volume = Math.max(0, Math.min(newValue, root.maxValue));
            wheel.accepted = true;
        }

        onPressed: event => {
            const activePlayer = BeatsService.player;
            switch (event.button) {
            case Qt.MiddleButton:
            case Qt.BackButton:
                activePlayer.previous();
                break;
            case Qt.ForwardButton:
            case Qt.RightButton:
                activePlayer.next();
                break;
            case Qt.LeftButton:
                activePlayer.togglePlaying();
                break;
            }
        }
    }
}
