import QtQuick
import Quickshell
import qs.common
import qs.common.widgets

ShaderRect {
    id: bg
    readonly property bool vertical: ["left", "right"].includes(side)
    readonly property string side: Mem.options.bar.behavior.position
    readonly property bool showCorners: state === "concave"

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
                anchors.rightMargin: side === "right" ? Sizes.barElevation : -Sizes.barElevation
                anchors.leftMargin: side === "left" ? Sizes.barElevation : -Sizes.barElevation
                anchors.topMargin: Sizes.hyprland.gapsOut
                anchors.bottomMargin: Sizes.hyprland.gapsOut
                radius: Rounding.verylarge
                enableBorders: Mem.options.bar.appearance.outline
            }
        },
        State {
            name: "convex"
            PropertyChanges {
                target: bg
                anchors.topMargin: Sizes.hyprland.gapsOut
                anchors.bottomMargin: Sizes.hyprland.gapsOut
                rightRadius: side === "left" ? Rounding.large : 0
                leftRadius: side === "right" ? Rounding.large : 0
                enableBorders: false
            }
        }
    ]
}
