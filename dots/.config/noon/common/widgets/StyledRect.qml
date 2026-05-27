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
    property bool enableAnimations: true
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
    transitions: Transition {
        Anim {
            properties: "topRightRadius,bottomRightRadius,topLeftRadius,bottomLeftRadius,anchors.topMargin,anchors.bottomMargin,radius,opacity"
        }
        CAnim {
            property: "color"
        }
    }

    Behavior on color {
        enabled: root.enableAnimations
        CAnim {
            duration: animationDuration
        }
    }

    Behavior on opacity {
        enabled: root.enableAnimations
        Anim {
            duration: animationDuration
        }
    }
    Behavior on width {
        enabled: root.enableAnimations
        Anim {
            duration: animationDuration
        }
    }
    Behavior on height {
        enabled: root.enableAnimations
        Anim {
            duration: animationDuration
        }
    }
    Behavior on scale {
        enabled: root.enableAnimations
        Anim {
            duration: animationDuration
        }
    }
    Behavior on y {
        enabled: root.enableAnimations
        Anim {
            duration: animationDuration
        }
    }

    Behavior on implicitWidth {
        enabled: root.enableAnimations
        Anim {
            duration: animationDuration
        }
    }
    Behavior on implicitHeight {
        enabled: root.enableAnimations
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
