import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

Item {
    id: root
    implicitHeight: content.implicitHeight
    implicitWidth: content.implicitWidth

    readonly property real clockScale: Mem.states.desktop.clock.scale
    readonly property bool hovered: hoverArea.containsMouse
    // Logic for font axes based on hover state
    property int wght: hovered ? 1000 : Mem.states.fonts.variableAxes.display.wght
    property int wdth: hovered ? 0 : Mem.states.fonts.variableAxes.display.wdth

    Behavior on wght {
        Anim {}
    }
    Behavior on wdth {
        Anim {}
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
    }

    ColumnLayout {
        id: content
        anchors.centerIn: parent
        spacing: -18 * clockScale

        StyledText {
            text: DateTimeService.time
            font.family: Fonts.family.clock
            font.pixelSize: 100 * clockScale
            color: hovered ? Colors.colPrimary : Colors.colOnBackground
            font.variableAxes: {
                "wdth": root.wdth,
                "wght": root.wght
            }
        }

        StyledText {
            id: date
            Layout.leftMargin: 3
            text: DateTimeService.date
            color: hovered ? Colors.colSecondaryContainer : Colors.colOnBackground
            font.family: Fonts.family.clock
            font.pixelSize: 40 * clockScale
            opacity: 0.75
            renderType: Text.NativeRendering
            font.variableAxes: {
                "wdth": root.wdth,
                "wght": root.wght
            }
        }
    }
}
