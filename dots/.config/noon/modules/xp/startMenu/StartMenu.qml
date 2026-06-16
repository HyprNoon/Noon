import "../common"
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import qs.common
import qs.common.widgets
import qs.services

StyledPanel {
    id: root

    readonly property int shadowAccount: 100
    property bool top: false
    visible: Globals.xp.showStartMenu
    shell: "xp"
    name: "startMenu"
    implicitHeight: XSizes.startMenu.size.height + shadowAccount
    implicitWidth: XSizes.startMenu.size.width + shadowAccount
    WlrLayershell.layer: WlrLayer.Top
    anchors {
        bottom: true
        top: false
        left: true
    }
    StyledRectangularShadow {
        target: bg
    }
    StyledRect {
        id: bg
        anchors {
            fill: parent
            topMargin: shadowAccount
            rightMargin: shadowAccount
            bottomMargin: 1
            margins: -border.width
        }
        topRadius: XRounding.small
        border.width: 2
        border.color: XColors.colors.colPrimaryBorder
        clip: true
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#1366CF"
            }
            GradientStop {
                position: 0.2
                color: "#3E8DEE"
            }
            GradientStop {
                position: 0.8
                color: "#3E8DEE"
            }
            GradientStop {
                position: 1
                color: "#1366CF"
            }
        }

        ColumnLayout {
            anchors.fill: parent
            TopArea {}
            CenterArea {}
            BottomArea {}
        }
    }
}
