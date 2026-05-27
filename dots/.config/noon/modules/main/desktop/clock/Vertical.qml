import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

Item {
    id: root

    implicitWidth: layout.implicitWidth + Padding.massive
    implicitHeight: layout.implicitHeight + Padding.massive

    readonly property real clockScale: Mem.states.desktop.clock.scale
    readonly property bool hovered: hoverArea.containsMouse

    property int wght: hovered ? 1000 : Mem.states.fonts.variableAxes.display.wght
    property int wdth: hovered ? 0 : Mem.states.fonts.variableAxes.display.wdth

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
    }

    GridLayout {
        id: layout
        anchors.centerIn: parent
        rowSpacing: -25 * clockScale
        columns: 2
        rows: 2

        Repeater {
            model: {
                const h = DateTimeService.hour;
                const m = DateTimeService.minute;
                return [h[0], h[1], m[0], m[1]];
            }

            StyledText {
                id: textItem
                required property var modelData
                required property int index
                text: modelData
                font.pixelSize: 100 * root.clockScale
                font.family: Fonts.family.clock
                color: root.hovered ? ((Math.floor(index / 2) + index) % 2 === 0 ? Colors.colPrimary : Colors.colSecondaryContainer) : Colors.colOnBackground

                font.variableAxes: {
                    "wdth": root.wdth,
                    "wght": root.wght
                }

                Behavior on color {
                    CAnim {}
                }
            }
        }
    }

    // Animations
    Behavior on wght {
        Anim {}
    }
    Behavior on wdth {
        Anim {}
    }
}
