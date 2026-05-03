import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.common

/**
 * Material 3 switch. See https://m3.material.io/components/switch/overview
 */
Switch {
    id: root

    property QtObject colors: Colors
    property real scale: 0.85 // Default in m3 spec is huge af
    // Color properties - standardized across components
    property color activeColor: colors.colPrimary ?? "#685496"
    property color inactiveColor: colors.colSurfaceContainerHighest ?? "#45464F"
    property color activeBorderColor: colors.colPrimary ?? "#685496"
    property color inactiveBorderColor: colors.colOutline
    property color buttonActiveColor: colors.colOnPrimary
    property color buttonColor: colors.colOutline
    property color iconActiveColor: colors.colPrimary
    property color iconColor: "transparent"
    implicitHeight: 32 * root.scale
    implicitWidth: 52 * root.scale

    PointingHandInteraction {}
    text: ""
    // Custom track styling
    background: Rectangle {
        width: parent.width
        height: parent.height
        radius: Rounding.full ?? 9999
        color: root.checked ? root.activeColor : root.inactiveColor
        border.width: 2 * root.scale
        border.color: root.checked ? root.activeBorderColor : root.inactiveBorderColor

        Behavior on color {
            CAnim {}
        }

        Behavior on border.color {
            CAnim {}
        }
    }

    // Custom thumb styling
    indicator: StyledRect {
        width: (root.pressed || root.down) ? (28 * root.scale) : root.checked ? (24 * root.scale) : (16 * root.scale)
        height: (root.pressed || root.down) ? (28 * root.scale) : root.checked ? (24 * root.scale) : (16 * root.scale)
        radius: Rounding.full
        color: root.checked ? root.buttonActiveColor : root.buttonColor
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: root.checked ? ((root.pressed || root.down) ? (22 * root.scale) : 24 * root.scale) : ((root.pressed || root.down) ? (2 * root.scale) : 8 * root.scale)

        Symbol {
            visible: false
            text: 'done'
            fill: 1
            anchors.centerIn: parent
            font.pixelSize: parent.width * scale
            color: root.checked ? root.iconActiveColor : root.iconColor

            Behavior on color {
                CAnim {}
            }
        }

        Behavior on anchors.leftMargin {
            Anim {}
        }
    }
}
