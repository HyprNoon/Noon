pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import qs.common

Singleton {
    property QtObject durations: QtObject {
        property real scale: Mem.options.appearance.animations.scale
        property int verysmall: 100 * scale
        property int small: 200 * scale
        property int normal: 300 * scale
        property int large: 400 * scale
        property int verylarge: 500 * scale
        property int huge: 600 * scale
        property int veryhuge: 700 * scale
        property int gigantic: 1000 * scale
        property int massive: 1500 * scale
        property int expressiveFastSpatial: 300 * scale
        property int expressiveDefaultSpatial: 500 * scale
        property int expressiveEffects: 200 * scale
    }

    property QtObject curves: QtObject {
        property list<real> expressiveEffects: [0.34, 0.8, 0.34, 1, 1, 1]
        property list<real> standard: [0.2, 0, 0, 1, 1, 1]
        property list<real> standardAccel: [0.3, 0, 1, 1, 1, 1]
        property list<real> standardDecel: [0, 0, 0, 1, 1, 1]
        property list<real> emphasized: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82, 0.25, 1, 1, 1]
        property list<real> emphasizedAccel: [0.3, 0, 0.8, 0.15, 1, 1]
        property list<real> emphasizedDecel: [0.05, 0.7, 0.1, 1, 1, 1]
        property list<real> expressiveFastSpatial: [0.42, 1.67, 0.21, 0.9, 1, 1]
        property list<real> expressiveDefaultSpatial: [0.38, 1.21, 0.22, 1, 1, 1]
    }
}
