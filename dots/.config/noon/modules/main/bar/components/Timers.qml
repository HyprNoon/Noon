import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
import qs.common
import qs.common.utils
import qs.common.widgets
import qs.services
import qs.store

BarGroup {
    id: root
    visible: TimerService.timers.length > 0
    property bool revealAll: false
    readonly property int itemSize: Math.round((vertical ? width : height) * 0.6)

    Layout.preferredHeight: content.implicitHeight + Padding.massive + (revealAll ? 20 : 0)
    Layout.preferredWidth: content.implicitWidth + Padding.massive + (revealAll ? 20 : 0)

    MouseArea {
        id: mouse

        anchors.fill: parent
        onPressed: revealAll = !revealAll
        hoverEnabled: true
    }

    // TimerPopup {
    //     hoverTarget: mouse
    // }

    GridLayout {
        id: content

        property bool verticalMode: root.verticalMode

        anchors.centerIn: parent
        rowSpacing: Padding.normal
        columnSpacing: Padding.normal
        rows: !verticalMode ? 1 : -1
        columns: verticalMode ? 1 : -1
        Repeater {
            model: TimerService.timers
            delegate: TimerItem {
                required property var modelData
                iconName: modelData.icon
                time: Math.round(modelData.remainingTime / 60)
                progress: (modelData.originalDuration - modelData.remainingTime) / modelData.originalDuration
                collapsed: !root.revealAll
                itemSize: root.itemSize
            }
        }
    }

    component TimerItem: Item {
        id: root
        required property real progress
        required property string iconName
        required property string time
        property bool verticalMode: parent.verticalMode
        property bool shown: true
        property bool collapsed: false
        property int itemSize: 2

        clip: true
        visible: width > 0 && height > 0
        implicitWidth: resourceLayout.x < 0 ? 0 : childrenRect.width
        implicitHeight: childrenRect.height
        Layout.fillWidth: true

        GridLayout {
            id: resourceLayout

            rowSpacing: Padding.normal
            columnSpacing: Padding.huge
            x: shown ? 0 : -resourceLayout.width
            columns: verticalMode ? 1 : 2
            Item {
                Layout.alignment: Qt.AlignVCenter
                implicitWidth: root.itemSize
                implicitHeight: root.itemSize

                ClippedFilledCircularProgress {
                    anchors.centerIn: parent
                    value: root.progress
                    implicitSize: root.itemSize
                }

                Symbol {
                    z: 99
                    anchors.centerIn: parent
                    fill: 1
                    text: iconName
                    font.pixelSize: Math.round(root.itemSize * 0.8)
                    color: Colors.colLayer0
                }
            }

            Revealer {
                reveal: !collapsed
                Layout.alignment: Qt.AlignCenter
                vertical: root.verticalMode

                StyledText {
                    visible: parent.reveal
                    anchors.centerIn: parent
                    color: Colors.colOnLayer0
                    text: root.time
                    font.pixelSize: Fonts.sizes.verysmall
                    font.letterSpacing: 1.5
                    font.weight: 900
                    font.family: Fonts.family.monospace
                }
            }
        }

        Behavior on implicitWidth {
            Anim {}
        }
    }
}
