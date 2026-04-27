import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Effects
import qs.common
import qs.common.functions

RectangularGlow {
    property var target
    property int radius: target?.radius ?? Rounding.verylarge
    property bool show: !Colors.transparent
    property real intensity: 1
    z: -999
    opacity: show ? target?.opacity ?? 1 : 0
    anchors.fill: target
    spread: 0
    cornerRadius: radius
    glowRadius: radius
    color: ColorUtils.transparentize(Colors.colShadow, 1 - intensity)
    cached: true

    Behavior on opacity {
        Anim {}
    }
}
