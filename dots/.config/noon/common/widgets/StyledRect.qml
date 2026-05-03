import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.common
import qs.common.widgets
import Qt5Compat.GraphicalEffects
import QtQuick.Effects

Rectangle {
    id: root
    readonly property int diaglonal: Math.sqrt(Math.pow(width, 2) + Math.pow(height, 2))
    property bool enableShadows: false
    property bool enableBorders: false
    property int rightRadius
    property int leftRadius
    property int topRadius
    property int bottomRadius
    property int implicitSize
    property int animationDuration: Animations.durations.normal
    property QtObject colors: Colors

    implicitHeight: implicitSize
    implicitWidth: implicitSize
    topRightRadius: Math.max(rightRadius, topRadius, radius)
    bottomRightRadius: Math.max(rightRadius, bottomRadius, radius)
    topLeftRadius: Math.max(leftRadius, topRadius, radius)
    bottomLeftRadius: Math.max(leftRadius, bottomRadius, radius)
    color: colors.colPrimaryContainer
    border.color: enableBorders ? colors.colOutline : "transparent"
    border.width: 1
    layer.enabled: clip
    layer.effect: OpacityMask {
        maskSource: Rectangle {
            width: root?.width
            height: root?.height
            radius: root?.radius
            topRightRadius: root?.topRightRadius
            bottomRightRadius: root?.bottomRightRadius
            topLeftRadius: root?.topLeftRadius
            bottomLeftRadius: root?.bottomLeftRadius
        }
    }

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
    Loader {
        anchors.fill: parent
        active: root.enableShadows
        onLoaded: {
            if (item && item !== null)
                item.target = root;
        }
        sourceComponent: StyledRectangularShadow {}
    }
}
