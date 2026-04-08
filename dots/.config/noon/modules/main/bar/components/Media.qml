import qs.common
import qs.common.widgets
import qs.services
import qs.store
import QtQuick
import QtQuick.Layouts
import Quickshell

BarGroup {
    id: root

    property bool expanded: true
    Layout.preferredWidth: rowLayout.implicitWidth + Padding.huge

    RowLayout {
        id: rowLayout
        spacing: Padding.large
        anchors.centerIn: parent
        Item {
            width: 36
            Layout.fillHeight: true

            ClippedFilledCircularProgress {
                anchors.centerIn: parent
                value: BeatsService.currentTrackProgressRatio()
                lineWidth: 2
                implicitSize: 26
            }

            Symbol {
                z: 999
                anchors.centerIn: parent
                fill: 1
                animateChange: true
                text: BeatsService._playing ? "pause" : "music_note"
                font.pixelSize: Fonts.sizes.normal
                color: Colors.colOnSecondary
            }
        }

        StyledText {
            visible: root.expanded
            truncate: true
            color: Colors.colOnLayer1
            Layout.fillWidth: true
            Layout.maximumWidth: 180
            horizontalAlignment: Text.AlignHCenter
            text: BeatsService.title
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
