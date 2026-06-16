import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.common
import qs.common.widgets
import qs.services
import "../common"

Item {
    id: root
    Layout.fillWidth: true
    Layout.preferredHeight: 60
    Layout.rightMargin: Padding.normal
    Layout.leftMargin: Padding.normal

    readonly property var icons_model: [
        {
            icon: "camera-photo-symbolic",
            action: () => NoonUtils.execDetached(Mem.options.apps.screenshot)
        },
        {
            icon: "emblem-system-symbolic",
            action: () => NoonUtils.callIpc("apps settings")
        },
        {
            icon: "system-shutdown-symbolic",
            action: () => NoonUtils.callIpc("sidebar reveal Session")
        },
        {
            icon: "system-lock-screen-symbolic",
            action: () => NoonUtils.callIpc("global lock")
        }
    ]
    RowLayout {
        anchors.fill: parent
        spacing: Padding.normal

        GBattery {}
        Repeater {
            model: root.icons_model.slice(0, 2)

            GButtonWithIcon {
                iconSource: modelData.icon
                implicitSize: 38
                iconSize: 18
                onPressed: {
                    modelData.action();
                    Globals.nobuntu.db.show = false;
                }
            }
        }
        Spacer {}
        Repeater {
            model: root.icons_model.slice(2)

            GButtonWithIcon {
                iconSource: modelData.icon
                implicitSize: 38
                iconSize: 18
                onPressed: {
                    modelData.action();
                    Globals.nobuntu.db.show = false;
                }
            }
        }
    }

    component GBattery: GButton {
        implicitWidth: content.implicitWidth + Padding.massive * 1.5
        visible: BatteryService.available

        RowLayout {
            id: content
            spacing: Padding.small
            anchors.centerIn: parent

            StyledIconImage {
                readonly property string icon: {
                    if (!BatteryService.available)
                        return "";
                    if (BatteryService.isCharging)
                        return "battery-charging-symbolic";

                    if (BatteryService.isCritical)
                        return "battery-caution-symbolic";
                    if (BatteryService.isLow)
                        return "battery-low-symbolic";

                    const p = BatteryService.percentage * 100;
                    if (p > 90)
                        return "battery-full-symbolic";
                    if (p > 60)
                        return "battery-good-symbolic";
                    if (p > 30)
                        return "battery-low-symbolic";

                    return "battery-empty-symbolic";
                }

                _source: icon
                implicitSize: 22
                visible: icon !== ""
            }

            StyledText {
                text: Math.round(100 * BatteryService.percentage) + " %"
                color: Colors.colOnLayer3
                font.family: "Roboto"
                font.pixelSize: 13
                font.weight: 700
                horizontalAlignment: Text.AlignRight | Text.AlignVCenter
            }
        }
    }
}
