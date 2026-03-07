import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.services
import qs.store

StyledPopup {
    id: root

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 8
        implicitWidth: 400

        // Header
        StyledText {
            text: qsTr("Network")
            color: Colors.m3.m3onSurfaceVariant
            font.weight: Font.Medium
            font.pixelSize: Fonts.sizes.large
            Layout.bottomMargin: 4
        }

        // Data List
        Repeater {
            model: [
                {
                    label: qsTr("Connection:"),
                    value: NetworkService.ethernet ? "Ethernet" : NetworkService.wifi ? "Wi-Fi" : "Disconnected",
                    show: true
                },
                {
                    label: qsTr("Network:"),
                    value: NetworkService.networkName,
                    show: NetworkService.networkName.length > 0
                },
                {
                    label: qsTr("Signal:"),
                    value: NetworkService.networkStrengthText,
                    show: NetworkService.wifi && NetworkService.networkStrength > 0
                },
                {
                    label: qsTr("Download:"),
                    value: NetworkService.downloadSpeedText,
                    show: true
                },
                {
                    label: qsTr("Upload:"),
                    value: NetworkService.uploadSpeedText,
                    show: true
                },
                {
                    label: qsTr("IP:"),
                    value: NetworkService.stats.ip_address,
                    show: true
                }
            ]

            delegate: RowLayout {
                spacing: 5
                Layout.fillWidth: true
                visible: modelData.show

                StyledText {
                    text: modelData.label
                    color: Colors.m3.m3onSurfaceVariant
                }

                StyledText {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignRight
                    color: Colors.m3.m3onSurfaceVariant
                    text: modelData.value
                    elide: Text.ElideRight
                }
            }
        }
    }
}
