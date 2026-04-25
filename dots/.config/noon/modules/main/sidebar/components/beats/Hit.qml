import QtQuick
import QtQuick.Layouts
import qs.services
import qs.common
import qs.common.widgets

StyledRect {
    id: root
    required property var modelData
    required property int index
    clip: true
    color: Colors.colLayer2
    radius: Rounding.huge
    signal preview(url: string, x: int, y: int)

    MouseArea {
        id: eventArea
        z: 99999
        propagateComposedEvents: true
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        anchors.fill: parent
        onClicked: preview(modelData.url, root.x, root.y)
    }

    StyledRect {
        id: footer
        z: 999
        clip: true
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        color: Colors.m3.m3surfaceContainerHigh
        height: 45
        RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: Padding.veryhuge
            anchors.leftMargin: Padding.veryhuge
            spacing: Padding.huge
            height: 45
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: -Padding.tiny

                StyledText {
                    font.pixelSize: Fonts.sizes.small
                    font.variableAxes: Fonts.variableAxes.title
                    text: modelData.title
                    Layout.fillWidth: true
                    truncate: true
                    color: Colors.colOnLayer3
                }

                StyledText {
                    font.pixelSize: Fonts.sizes.verysmall
                    text: modelData.artist
                    Layout.fillWidth: true
                    truncate: true
                    color: Colors.colSubtext
                }
            }
            Symbol {
                visible: modelData.isPlaylist
                font.pixelSize: 20
                text: "list"
                color: Colors.colOnLayer3
            }
        }
    }
    Symbol {
        text: "music_note"
        visible: !modelData.thumbnail
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -Padding.huge
        font.pixelSize: 54
        color: Colors.colSecondary
    }
    StyledImage {
        anchors.fill: parent
        source: Qt.resolvedUrl(modelData?.thumbnail) ?? ""
        cache: true
    }
}
