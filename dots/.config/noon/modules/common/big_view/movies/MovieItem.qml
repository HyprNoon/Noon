import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets

Item {
    id: movieItem
    property bool isSelected: false
    Behavior on scale {
        Anim {}
    }
    scale: isSelected ? 1.0 : 0.92
    opacity: isSelected ? 1.0 : 0.65

    StyledRectangularShadow {
        target: card
        visible: isSelected
        glowRadius: 30
    }

    StyledRect {
        id: card
        anchors.fill: parent
        anchors.margins: Padding.tiny
        radius: Rounding.large
        color: isSelected ? Colors.colSecondaryContainer : (mouseArea.containsMouse ? Colors.colSecondaryContainerHover : Colors.colLayer2)

        Behavior on color {
            Anim {}
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Padding.normal
            spacing: Padding.small

            StyledRect {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: Rounding.small
                color: Colors.colLayer3
                clip: true

                VideoPreview {
                    z: 1
                    anchors.fill: parent
                    source: movieItem.modelData.fileUrl
                }

                Symbol {
                    z: 0
                    anchors.centerIn: parent
                    text: "movie"
                    fill: 1
                    font.pixelSize: 32
                    color: Colors.colSubtext
                    opacity: 0.5
                }

                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 4
                    color: Colors.colPrimary
                    visible: isSelected
                }
            }

            StyledText {
                Layout.fillWidth: true
                Layout.maximumHeight: Fonts.sizes.normal + Padding.normal
                text: movieItem.modelData?.fileName ?? ""
                font.pixelSize: Fonts.sizes.verysmall
                font.family: Fonts.family.variable
                font.variableAxes: Fonts.variableAxes.main
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                maximumLineCount: 1
                color: isSelected ? Colors.colOnSecondaryContainer : Colors.colOnSurface
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if (movieItem.modelData?.fileUrl)
                    Qt.openUrlExternally(movieItem.modelData.fileUrl);
            }
        }
    }
}
