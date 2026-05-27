import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.common
import qs.common.widgets
import qs.services

Rectangle {
    readonly property real iconSize: 16

    height: parent.height * 0.85
    width: layout.implicitWidth + 20
    color: "transparent"

    RowLayout {
        id: layout
        anchors.centerIn: parent
        spacing: 10

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
                    show: true,
                    icon: getNetIcon(),
                    cmd: Mem.options.apps.networkEthernet
                },
                {
                    show: BluetoothService.available,
                    icon: getBtIcon(),
                    cmd: null
                }
            ]

            IconImage {
                visible: modelData.show
                source: NoonUtils.iconPath(modelData.icon)
                implicitSize: iconSize

                MouseArea {
                    anchors.fill: parent
                    enabled: !!modelData.cmd
                    cursorShape: Qt.PointingHandCursor
                    onClicked: NoonUtils.execDetached(modelData.cmd)
                }
            }
        }
    }

    // Helper logic kept separate to keep the UI tree clean
    function getNetIcon() {
        if ((NetworkService.manager.networkName || "") !== "" && NetworkService.manager.networkName !== "lo") {
            const s = NetworkService.manager.networkStrength ?? 0;
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
        return (NetworkInformation.TransportMedium?.Ethernet) ? "network-connected" : "network-wireless-offline";
    }

    function getBtIcon() {
        if (BluetoothService.bluetoothConnected)
            return "bluetooth-active";
        return BluetoothService.bluetoothEnabled ? "bluetooth" : "bluetooth-disabled";
    }
}
