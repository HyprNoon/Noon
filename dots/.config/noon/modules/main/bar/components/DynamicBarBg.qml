import QtQuick
import Quickshell
import qs.common
import qs.common.widgets

ShaderRect {
    id: bg
    readonly property string side: Mem.options.bar.behavior.position
    readonly property bool showCorners: state === "concave"
    readonly property bool isBottom: side === "bottom"
    readonly property bool useBg: Mem.options.bar.appearance.useBg
    anchors.fill: parent
    enableBorders: false
    extraShaderCondition: useBg
    state: Mem.options.bar.appearance?.style ?? "float"

    states: [
        State {
            name: "sharp"
        },
        State {
            name: "concave"
        },
        State {
            name: "float"
            PropertyChanges {
                target: bg

                anchors.topMargin: !isBottom ? Sizes.barElevation : -Sizes.barElevation
                anchors.bottomMargin: isBottom ? Sizes.barElevation : -Sizes.barElevation
                anchors.margins: Sizes.hyprland.gapsOut

                radius: Rounding.verylarge
                enableBorders: Mem.options.bar.appearance.outline
            }
        },
        State {
            name: "convex"
            PropertyChanges {
                target: bg
                enableBorders: false
                anchors.leftMargin: Sizes.hyprland.gapsOut
                anchors.rightMargin: Sizes.hyprland.gapsOut
                topRadius: isBottom ? Rounding.large : 0
                bottomRadius: !isBottom ? Rounding.large : 0
            }
        }
    ]
}
