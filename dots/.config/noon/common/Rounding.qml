pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import qs.common

Singleton {
    property real scale: Mem.options.appearance.rounding.scale
    property int tiny: 6 * scale
    property int verysmall: 8 * scale
    property int small: 10 * scale
    property int normal: 12 * scale
    property int large: 16 * scale
    property int verylarge: 20 * scale
    property int huge: 22 * scale
    property int massive: 28 * scale
    property int silly: 32 * scale
    property int full: 999

    onScaleChanged: NoonUtils.setHyprKey("rounding", verylarge)
}
