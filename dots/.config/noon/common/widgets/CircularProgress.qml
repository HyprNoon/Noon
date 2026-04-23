// From https://github.com/rafzby/circular-progressbar with modifications
// License: LGPL-3.0 - A copy can be found in `licenses` folder of repo
import QtQuick
import QtQuick.Shapes
import qs.common

/**
 * Material 3 circular progress. See https://m3.material.io/components/progress-indicators/specs
 */
Item {
    id: root

    property int size: 30
    property int lineWidth: 2
    property real value: 0
    property color primaryColor: Colors.m3.m3onSecondaryContainer
    property color secondaryColor: Colors.colSecondaryContainer
    property real gapAngle: 180 / 2
    property bool fill: true
    property int fillOverflow: 2
    property int animationDuration: 1000
    property var easingType: Easing.OutCubic
    property bool enableAnimation: true
    property real degree: value * 360
    property real centerX: root.width / 2
    property real centerY: root.height / 2
    property real arcRadius: root.size / 2 - root.lineWidth
    property real startAngle: -90

    width: size
    height: size

    Loader {
        active: root.fill
        anchors.fill: parent

        sourceComponent: Rectangle {
            radius: Rounding.full
            color: root.secondaryColor
        }

    }

    Shape {
        anchors.fill: parent
        layer.enabled: true
        layer.smooth: true
        preferredRendererType: Shape.CurveRenderer

        // Secondary arc (remaining progress)
        ShapePath {
            id: secondaryPath

            strokeColor: root.secondaryColor
            strokeWidth: root.lineWidth
            capStyle: ShapePath.RoundCap
            fillColor: "transparent"

            PathAngleArc {
                centerX: root.centerX
                centerY: root.centerY
                radiusX: root.arcRadius
                radiusY: root.arcRadius
                startAngle: root.degree === 0 ? root.startAngle : root.startAngle + root.degree + root.gapAngle
                sweepAngle: root.degree === 0 ? 360 : 360 - root.degree - 2 * root.gapAngle
            }

        }

        // Primary arc (progress indication)
        ShapePath {
            id: primaryPath

            strokeColor: root.primaryColor
            strokeWidth: root.lineWidth
            capStyle: ShapePath.RoundCap
            fillColor: "transparent"

            PathAngleArc {
                centerX: root.centerX
                centerY: root.centerY
                radiusX: root.arcRadius
                radiusY: root.arcRadius
                startAngle: root.startAngle
                sweepAngle: root.degree
            }

        }

    }

    Behavior on degree {
        enabled: root.enableAnimation

        Anim {
            duration: root.animationDuration
            easing.type: root.easingType
        }

    }

}
