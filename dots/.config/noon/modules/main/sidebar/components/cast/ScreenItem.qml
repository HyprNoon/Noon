import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.common
import qs.common.widgets

Item {
    id: root
    property string screenName
    property string screenRes
    property var captureSource
    signal clicked

    StyledRect {
        anchors.fill: parent
        anchors.margins: Padding.small
        color: Colors.colLayer1
        radius: Rounding.large
        clip: true

        StyledScreencopyView {
            z: 0
            anchors.fill: parent
            captureSource: root.captureSource
            live: true
            paintCursor: false
        }

        MouseArea {
            id: mouseArea
            z: 999
            hoverEnabled: true
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: root.clicked()
        }

        StyledRect {
            z: 1
            opacity: mouseArea.containsMouse ? 1 : 0
            anchors.fill: parent
            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: "transparent"
                }
                GradientStop {
                    position: 0.4
                    color: "transparent"
                }
                GradientStop {
                    position: 1
                    color: Colors.m3.m3shadow
                }
            }
            ColumnLayout {
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.margins: Padding.small
                spacing: Padding.tiny

                StyledText {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    text: root.screenName
                    font.pixelSize: Fonts.sizes.large
                    font.variableAxes: Fonts.variableAxes.title
                    color: Colors.colOnLayer1
                    truncate: true
                }

                StyledText {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    text: root.screenRes
                    font.pixelSize: Fonts.sizes.normal
                    color: Colors.colSubtext
                    truncate: true
                }
            }
        }
    }
}
