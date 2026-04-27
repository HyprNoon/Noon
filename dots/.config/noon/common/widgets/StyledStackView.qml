import QtQuick
import QtQuick.Controls
import qs.common

/**
 * A Stack with animations.
 */

StackView {
    id: root

    property int slideDirection: 1

    replaceEnter: Transition {
        ParallelAnimation {
            PropertyAnimation {
                property: "y"
                from: -root.slideDirection * root.height
                to: 0
                duration: Animations.durations.large
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Animations.curves.emphasizedDecel
            }
            PropertyAnimation {
                property: "scale"
                from: 0.65
                to: 1
                duration: Animations.durations.huge
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Animations.curves.emphasized
            }
            PropertyAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: Animations.durations.small
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Animations.curves.emphasized
            }
        }
    }
    replaceExit: Transition {
        ParallelAnimation {
            PropertyAnimation {
                property: "y"
                from: 0
                to: root.slideDirection * root.height
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Animations.curves.emphasizedAccel
                duration: Animations.durations.large
            }
            PropertyAnimation {
                property: "scale"
                from: 1
                to: 0.65
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Animations.curves.emphasized
                duration: Animations.durations.huge
            }
            PropertyAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: Animations.durations.small
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Animations.curves.emphasized
            }
        }
    }
}
