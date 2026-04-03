import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

StyledRect {
    height: controls?.implicitHeight + Padding.massive
    width: controls?.implicitWidth + Padding.massive
    radius: Rounding.veryhuge
    color: Colors.colLayer1
    anchors {
        right: parent.right
        bottom: parent.bottom
        rightMargin: -75
        margins: Padding.huge
    }
    ColumnLayout {
        id: controls
        anchors.centerIn: parent
        spacing: Padding.normal

        Repeater {
            model: ScriptModel {
                values: {
                    return [
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
                    ];
                }
            }
            delegate: RippleButtonWithIcon {
                materialIcon: modelData?.icon
                buttonRadius: Rounding.verylarge
                implicitSize: 72
                releaseAction: modelData.action()
            }
        }
    }
    Anim on anchors.rightMargin {
        from: -75
        to: anchors.margins
    }
}
