import QtQuick
import QtQuick.Effects
import Qt5Compat.GraphicalEffects
import QtQuick.Controls
import qs.common

Flow {
    id: root
    property bool popin: true
    add: Transition {
        Anim {
            properties: root.popin ? "opacity,scale" : "opacity"
            from: 0
            to: 1
            duration: Animations.durations.normal
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Animations.curves.expressiveFastSpatial
        }
    }

    move: Transition {
        ParallelAnimation {
            Anim {
                properties: "y"
                duration: Animations.durations.normal
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Animations.curves.expressiveFastSpatial
            }

            Anim {
                properties: root.popin ? "opacity,scale" : "opacity"
                to: 1
                duration: Animations.durations.normal
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Animations.curves.expressiveFastSpatial
            }
        }
    }
    layer.enabled: root.clip
    layer.effect: OpacityMask {
        maskSource: Rectangle {
            width: root.width
            height: root.height
            radius: root.radius
        }
    }
}
