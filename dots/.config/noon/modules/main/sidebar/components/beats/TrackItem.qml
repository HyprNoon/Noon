import QtQuick
import QtQuick.Layouts
import qs.services
import qs.common
import qs.common.widgets

StyledRect {
    id: root
    required property var modelData
    required property int index
    readonly property alias eventArea: eventArea
    property string title
    property string artist
    property string coverArt
    property bool isPlaylist
    property var action
    clip: true
    color: Colors.colLayer2
    radius: Rounding.huge
    signal preview(url: string, x: int, y: int)

    MouseArea {
        id: eventArea
        z: 99999
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        propagateComposedEvents: true
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        anchors.fill: parent
        onClicked: {
            feedAnim.running = true;
            if (action)
                action();
        }
    }
    SequentialAnimation {
        id: feedAnim
        running: false
        NumberAnimation {
            target: root
            property: "scale"
            to: 0.94
            duration: 150
        }
        NumberAnimation {
            target: root
            property: "scale"
            to: 1
            duration: 200
        }
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
                    text: root.title
                    Layout.fillWidth: true
                    truncate: true
                    color: Colors.colOnLayer3
                }

                StyledText {
                    font.pixelSize: Fonts.sizes.verysmall
                    text: root.artist
                    Layout.fillWidth: true
                    truncate: true
                    color: Colors.colSubtext
                }
            }
            Symbol {
                visible: root.isPlaylist
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
        source: Qt.resolvedUrl(root.coverArt) ?? ""
        cache: true
    }
}
