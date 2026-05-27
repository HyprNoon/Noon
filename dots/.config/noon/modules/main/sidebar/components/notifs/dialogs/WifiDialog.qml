import qs.services
import qs.common
import qs.common.widgets
import QtQuick
import QtQuick.Layouts
import Quickshell

BottomDialog {
    id: root

    collapsedHeight: parent.height * 0.65
    property bool isScanning: false

    Timer {
        id: scanTimer
        interval: 4000
        onTriggered: root.isScanning = false
    }

    contentItem: ColumnLayout {
        anchors.fill: parent
        anchors.margins: Padding.massive
        spacing: Padding.large

        PageHeader {
            title: "Connect to Wi-Fi"
        }

        StyledIndeterminateProgressBar {
            visible: root.isScanning
            Layout.fillWidth: true
        }

        StyledListView {
            id: nwList
            Layout.fillHeight: true
            Layout.fillWidth: true
            clip: true
            spacing: 4
            reuseItems: false
            _model: NetworkService.manager.wifiNetworks
            delegate: WifiNetworkItem {
                required property var modelData
                required property int index
                list: nwList
                width: ListView.view.width
                network: modelData
            }
        }

        RowLayout {
            Layout.preferredHeight: 50
            Layout.fillWidth: true

            Item {
                Layout.fillWidth: true
            }

            DialogButton {
                buttonText: qsTr("Refresh")
                onClicked: {
                    root.isScanning = true;
                    NetworkService.manager.rescanWifi();
                    scanTimer.restart();
                }
            }

            DialogButton {
                buttonText: qsTr("Details")
                onClicked: {
                    root.show = false;
                    const app = NetworkService.manager.ethernet ? Mem.options.apps.networkEthernet : Mem.options.apps.network;
                    NoonUtils.execDetached(app);
                    NoonUtils.callIpc("sidebar hide");
                }
            }

            DialogButton {
                buttonText: qsTr("Done")
                onClicked: root.show = false
            }
        }
    }
}
