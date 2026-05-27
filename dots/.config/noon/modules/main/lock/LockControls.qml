import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

Item {
    width: controls?.implicitWidth + Padding.massive
    height: controls?.implicitHeight + Padding.massive

    anchors {
        right: parent.right
        bottom: parent.bottom
        rightMargin: -75
        margins: Padding.huge
    }

    StyledRect {
        id: bg
        height: controls?.implicitHeight + Padding.massive
        width: controls?.implicitWidth + Padding.massive
        radius: Rounding.silly
        color: Colors.colLayer1
        anchors.centerIn: parent
        ColumnLayout {
            id: controls
            anchors.centerIn: parent
            spacing: Padding.normal

            Repeater {
                model: [
                    {
                        icon: "power_settings_new",
                        releaseAction: () => NoonUtils.execDetached("systemctl poweroff")
                    },
                    {
                        icon: "restart_alt",
                        releaseAction: () => NoonUtils.execDetached("reboot")
                    },
                    {
                        icon: "dark_mode",
                        releaseAction: () => NoonUtils.execDetached("systemctl suspend")
                    }
                ]
                delegate: RippleButtonWithIcon {
                    materialIcon: modelData?.icon
                    buttonRadius: Rounding.massive
                    implicitSize: 72
                    releaseAction: modelData.action()
                }
            }
        }
    }
    StyledRectangularShadow {
        target: bg
    }
    Anim on anchors.rightMargin {
        from: -75
        to: anchors.margins
    }
}
