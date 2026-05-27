import "../../common"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import qs.common
import qs.common.widgets
import qs.services
import QtNetwork

RowLayout {
    id: root
    spacing: 0
    property int commonIconSize: 24

    Revealer {
        reveal: AudioService.sink?.audio?.muted ?? false
        Layout.fillHeight: true
        Layout.rightMargin: reveal ? XPadding.tiny : 0

        Behavior on Layout.rightMargin {
            Anim {}
        }

        StyledIconImage {
            anchors.centerIn: parent
            source: NoonUtils.iconPath("audio-volume-muted")
            implicitSize: commonIconSize
        }
    }

    Revealer {
        reveal: AudioService.source?.audio?.muted ?? false
        Layout.fillHeight: true
        Layout.rightMargin: reveal ? XPadding.tiny : 0

        Behavior on Layout.rightMargin {
            Anim {}
        }

        Item {
            width: commonIconSize
            height: commonIconSize

            StyledIconImage {
                anchors.centerIn: parent
                source: NoonUtils.iconPath("microphone-sensitivity-muted")
                implicitSize: commonIconSize
                mipmap: true
                smooth: true
            }
        }
    }

    Item {
        Layout.rightMargin: XPadding.tiny
        width: commonIconSize
        height: commonIconSize

        readonly property string networkIcon: {
            if (NetworkService.manager.ethernet) {
                return "network-connected";
            }

            if (!NetworkService.manager.wifiEnabled) {
                return "network-wireless-offline";
            }

            if (NetworkService.manager.wifi && (NetworkService.manager.networkName ?? "") !== "") {
                const strength = NetworkService.manager.networkStrength ?? 0;
                if (strength > 80)
                    return "network-wireless-signal-excellent";
                if (strength > 60)
                    return "network-wireless-signal-good";
                if (strength > 40)
                    return "network-wireless-signal-ok";
                if (strength > 20)
                    return "network-wireless-signal-weak";
                return "network-wireless-signal-none";
            }

            return "network-wireless-offline";
        }

        StyledIconImage {
            anchors.centerIn: parent
            source: NoonUtils.iconPath(parent.networkIcon)
            width: commonIconSize
            height: commonIconSize
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: NoonUtils.execDetached(Mem.options.apps.networkEthernet)
        }
    }

    Item {
        width: commonIconSize
        height: commonIconSize
        visible: BluetoothService.available

        readonly property string bluetoothIcon: {
            const connected = BluetoothService.bluetoothConnected ?? false;
            const enabled = BluetoothService.bluetoothEnabled ?? false;

            if (connected)
                return "bluetooth-active";
            if (enabled)
                return "bluetooth";
            return "bluetooth-disabled";
        }

        StyledIconImage {
            anchors.centerIn: parent
            source: NoonUtils.iconPath(parent.bluetoothIcon)
            implicitSize: commonIconSize
        }
    }
}
