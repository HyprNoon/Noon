import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import "./../components"

StyledPanel {
    id: bar

    readonly property string pos: Mem.options.bar.behavior.position
    readonly property int barHeight: Mem.options.bar.appearance.size

    name: "bar"
    shell: "noon"

    implicitHeight: barHeight + 100
    exclusiveZone: barHeight
    fill: true
    anchors.bottom: pos === "bottom"
    anchors.top: pos === "top"

    mask: Region {
        item: mask
    }
    Item {
        id: mask
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: Padding.massive
        anchors.leftMargin: Padding.massive
        implicitHeight: barHeight

        StatusIcons {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
        }

        ActiveWindow {
            anchors.left: parent.left
            implicitHeight: parent.height
        }

        StyledRectangularShadow {
            target: bg
        }

        StyledRect {
            id: bg
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            implicitWidth: contentRow.implicitWidth + Padding.massive * 2
            color: Colors.colLayer0
            bottomRadius: Rounding.verylarge
            RowLayout {
                id: contentRow
                anchors.fill: parent

                ClockWidget {
                    Layout.alignment: Qt.AlignCenter
                }
            }
        }
    }
}
