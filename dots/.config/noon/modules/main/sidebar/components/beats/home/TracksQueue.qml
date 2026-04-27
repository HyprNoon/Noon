import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.common.functions
import qs.services

StyledRect {
    id: root

    z: 99
    radius: Rounding.massive
    color: colors.colLayer1
    colors: parent.colors
    clip: true

    StyledListView {
        id: list
        anchors.fill: parent
        anchors.margins: Padding.huge

        model: BeatsService.daemonOptions.players.main.queue
        delegate: StyledRect {
            required property var modelData
            required property int index
            readonly property int trackIndex: modelData?.index ?? false
            readonly property bool isCurrent: modelData?.current ?? false
            anchors.right: parent?.right
            anchors.left: parent?.left
            height: 60
            topRadius: index === 0 ? Rounding.verylarge : Rounding.tiny
            bottomRadius: index === list.count - 1 ? Rounding.verylarge : Rounding.tiny
            color: Colors.colLayer2
            RLayout {
                anchors.fill: parent
                anchors.leftMargin: Padding.huge
                spacing: Padding.huge
                Rectangle {
                    visible: isCurrent
                    height: 30
                    radius: 8
                    width: 4
                    color: Colors.colPrimaryContainer
                }
                StyledText {
                    text: modelData?.title
                    truncate: true
                    opacity: isCurrent ? 1 : 0.4
                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true
                    Layout.rightMargin: Padding.massive
                    color: Colors.colOnLayer2
                    font.pixelSize: Fonts.sizes.normal
                }
            }
        }
    }
}
