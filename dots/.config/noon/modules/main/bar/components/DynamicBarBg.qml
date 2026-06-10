import QtQuick
import Quickshell
import qs.common
import qs.common.widgets

ShaderRect {
    id: bg
    readonly property string side: Mem.options.bar.behavior.position
    readonly property bool showCorners: state === "concave"
    readonly property bool isBottom: side === "bottom"
    readonly property bool isTop: side === "top" || side === ""
    readonly property bool isLeft: side === "left"
    readonly property bool isRight: side === "right"
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

                anchors.topMargin: isTop ? Sizes.barElevation : (isBottom ? 0 : Sizes.hyprland.gapsOut)
                anchors.bottomMargin: isBottom ? Sizes.barElevation : (isTop ? 0 : Sizes.hyprland.gapsOut)
                anchors.leftMargin: isLeft ? Sizes.barElevation : Sizes.hyprland.gapsOut
                anchors.rightMargin: isRight ? Sizes.barElevation : Sizes.hyprland.gapsOut

                radius: Rounding.verylarge
                enableBorders: Mem.options.bar.appearance.outline
            }
        },
        State {
            name: "convex"
            PropertyChanges {
                target: bg
                enableBorders: false
                anchors.topMargin: (isLeft || isRight) ? Sizes.hyprland.gapsOut : 0
                anchors.bottomMargin: (isLeft || isRight) ? Sizes.hyprland.gapsOut : 0
                anchors.leftMargin: (isTop || isBottom) ? Sizes.hyprland.gapsOut : 0
                anchors.rightMargin: (isTop || isBottom) ? Sizes.hyprland.gapsOut : 0

                topRadius: isBottom ? Rounding.large : 0
                bottomRadius: isTop ? Rounding.large : 0
                leftRadius: isRight ? Rounding.large : 0
                rightRadius: isLeft ? Rounding.large : 0
            }
        }
    ]
}
