import QtQuick
import qs.common
import Quickshell
import Quickshell.Widgets

ClippingWrapperRectangle {
    property int rightRadius
    property int leftRadius
    property int topRadius
    property int bottomRadius
    property int implicitSize
    property int animationDuration: Animations.durations.normal
    property QtObject colors: Colors
    property bool enableBorders: false
    readonly property int diaglonal: Math.sqrt(Math.pow(width, 2) + Math.pow(height, 2))

    implicitHeight: implicitSize
    implicitWidth: implicitSize
    topRightRadius: Math.max(rightRadius, topRadius, radius)
    bottomRightRadius: Math.max(rightRadius, bottomRadius, radius)
    topLeftRadius: Math.max(leftRadius, topRadius, radius)
    bottomLeftRadius: Math.max(leftRadius, bottomRadius, radius)
    color: colors.colPrimaryContainer
    border.color: enableBorders ? colors.colOutline : "transparent"
    border.width: 1

    Behavior on color {
        CAnim {
            duration: animationDuration
        }
    }

    Behavior on opacity {
        Anim {
            duration: animationDuration
        }
    }
    Behavior on width {
        Anim {
            duration: animationDuration
        }
    }
    Behavior on height {
        Anim {
            duration: animationDuration
        }
    }
    Behavior on scale {
        Anim {
            duration: animationDuration
        }
    }
    Behavior on y {
        Anim {
            duration: animationDuration
        }
    }

    Behavior on implicitWidth {
        Anim {
            duration: animationDuration
        }
    }
    Behavior on implicitHeight {
        Anim {
            duration: animationDuration
        }
    }
}
