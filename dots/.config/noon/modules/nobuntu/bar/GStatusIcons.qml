import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.common
import qs.common.widgets
import qs.services
import "../common"

StyledRect {
    readonly property real iconSize: 18

    implicitHeight: Math.round(parent.height * 0.75)
    implicitWidth: layout.implicitWidth + Padding.large * 2
    anchors.right: parent.right
    anchors.rightMargin: Padding.verylarge
    anchors.verticalCenter: parent.verticalCenter
    radius: Rounding.large

    color: {
        if (_event_area.pressed)
            return Colors.colLayer0Active;
        if (_event_area.containsMouse)
            return Colors.colLayer0Hover;
        return "transparent";
    }

    RowLayout {
        id: layout
        anchors.centerIn: parent
        spacing: Padding.normal

        Repeater {
            model: [
                {
                    show: AudioService.sink?.audio?.muted ?? false,
                    icon: "audio-volume-muted",
                    cmd: null
                },
                {
                    show: AudioService.source?.audio?.muted ?? false,
                    icon: "microphone-sensitivity-muted",
                    cmd: null
                },
                {
                    show: BluetoothService.available,
                    icon: BluetoothService.getLinuxSymbolicIcon(BluetoothService.filterConnectedDevices(BluetoothService.pairedDevices)),
                    cmd: null
                },
                {
                    show: true,
                    icon: getNetIcon(),
                    cmd: Mem.options.apps.networkEthernet
                }
            ]

            StyledIconImage {
                visible: modelData.show
                _source: modelData.icon
                implicitSize: iconSize

                MouseArea {
                    anchors.fill: parent
                    enabled: !!modelData.cmd
                    cursorShape: Qt.PointingHandCursor
                    onClicked: NoonUtils.execDetached(modelData.cmd)
                }
            }
        }

        RowLayout {
            visible: BatteryService.available
            spacing: Padding.tiny
            StyledIconImage {
                _source: getBatteryIcon()
                implicitSize: iconSize
            }
            StyledText {
                text: Math.round(BatteryService.percentage * 100) + "%"
                font {
                    family: "Roboto"
                    weight: Font.DemiBold
                    pointSize: 10
                }
            }
        }
    }

    MouseArea {
        id: _event_area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: NoonUtils.callIpc("nobuntu toggle_db")
    }

    function getNetIcon() {
        if (NetworkService.manager.ethernet) {
            return "network-wired";
        }

        if (!NetworkService.manager.wifiEnabled) {
            return "network-wireless-offline";
        }

        if (NetworkService.manager.wifi && NetworkService.manager.networkName !== "") {
            const s = NetworkService.manager.networkStrength;
            if (s > 80)
                return "network-wireless-signal-excellent";
            if (s > 60)
                return "network-wireless-signal-good";
            if (s > 40)
                return "network-wireless-signal-ok";
            if (s > 20)
                return "network-wireless-signal-weak";
            return "network-wireless-signal-none";
        }

        return "network-wireless-offline";
    }

    function getBatteryIcon() {
        if (!BatteryService.available)
            return "";

        const p = BatteryService.percentage * 100;
        const charging = BatteryService.charging;
        let icon = "";

        if (p >= 95)
            icon = "battery-full";
        else if (p >= 80)
            icon = "battery-level-90";
        else if (p >= 60)
            icon = "battery-level-80";
        else if (p >= 40)
            icon = "battery-level-50";
        else if (p >= 10)
            icon = "battery-level-20";
        else
            icon = "battery-caution";

        return charging ? `${icon}-charging-symbolic` : icon;
    }
}
