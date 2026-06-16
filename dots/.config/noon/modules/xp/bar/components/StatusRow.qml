import "../../common"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Qt5Compat.GraphicalEffects
import qs.services
import qs.common
import QtQuick.Effects
import qs.common.widgets

StyledRect {
    id: rightArea
    Layout.preferredWidth: Math.min(230)
    Layout.fillHeight: true
    color: XColors.colors.colSecondary
    StyledRect {
        id: showDesktopArea
        anchors.right: parent.right
        implicitHeight: parent.height
        implicitWidth: 6
        color: desktopMouse.containsMouse ? XColors.colors.colPrimaryBorderDim : XColors.colors.colPrimaryBorder
        MouseArea {
            id: desktopMouse
            anchors.fill: parent
            hoverEnabled: true
            onClicked: HyprlandService.focusWs("special")
        }
    }
    StyledRect {
        id: separator

        implicitHeight: parent.height
        implicitWidth: 3
        color: XColors.colors.colShadows
        opacity: 0.85
        anchors {
            left: parent.left
        }
        layer.enabled: true
        layer.effect: DropShadow {
            color: XColors.colors.colShadows
            samples: 7
            radius: 5
        }
    }

    RLayout {
        spacing: XPadding.small
        anchors {
            top: parent.top
            right: showDesktopArea.left
            bottom: parent.bottom
            left: parent.left
            rightMargin: XPadding.large
        }

        Spacer {}
        SysTray {}
        StatusIcons {}
        Clock {}
    }
    gradient: Gradient {
        GradientStop {
            position: 0.4
            color: XColors.colors.colSecondaryBorder
        }
        GradientStop {
            position: 0
            color: XColors.colors.colSecondary
        }
    }
}
