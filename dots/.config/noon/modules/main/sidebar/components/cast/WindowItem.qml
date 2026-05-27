import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.common
import qs.common.widgets

StyledRect {
    id: winItem
    property string windowTitle
    property string windowClass
    property var captureSource
    signal clicked

    height: 140
    color: Colors.colLayer1

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: winItem.clicked()
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: Padding.small
        spacing: Padding.massive

        StyledRect {
            Layout.preferredWidth: 150
            Layout.fillHeight: true
            color: Colors.colLayer3
            radius: Rounding.normal
            clip: true

            StyledScreencopyView {
                anchors.fill: parent
                captureSource: winItem.captureSource
                live: true
                paintCursor: false
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 0
            spacing: 4

            StyledText {
                text: winItem.windowTitle
                font.pixelSize: Fonts.sizes.normal
                font.variableAxes: Fonts.variableAxes.title
                color: Colors.colOnLayer1
                Layout.fillWidth: true
                Layout.rightMargin: Padding.massive
                elide: Text.ElideRight
                maximumLineCount: 2
                wrapMode: Text.Wrap
            }

            StyledText {
                text: winItem.windowClass
                font.pixelSize: Fonts.sizes.small
                color: Colors.colSubtext
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }
}
