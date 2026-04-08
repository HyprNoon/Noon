import qs.common
import qs.common.widgets
import qs.services
import qs.store
import QtQuick
import QtQuick.Layouts
import Quickshell

BarGroup {
    id: root

    Layout.fillWidth: true
    Layout.preferredHeight: width

    ClippedFilledCircularProgress {
        id: progress
        value: BeatsService.currentTrackProgressRatio()
        anchors.centerIn: parent
        implicitSize: root.width * 0.7

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
