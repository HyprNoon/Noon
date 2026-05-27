import qs.services
import qs.common
import qs.common.widgets
import qs.common.functions
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell.Bluetooth
import Quickshell
import Quickshell.Hyprland

BottomDialog {
    id: root

    collapsedHeight: parent.height * 0.65

    contentItem: ColumnLayout {
        anchors.fill: parent
        anchors.margins: Padding.huge
        spacing: Padding.large

        PageHeader {
            title: qsTr("Bluetooth devices")
            subTitle: qsTr("Configure Connected Devices")
        }

        StyledIndeterminateProgressBar {
            id: loading
            visible: Bluetooth.defaultAdapter?.discovering ?? false
            Layout.fillWidth: true
        }

        StyledListView {
            id: listView
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins: Padding.large
            clip: true
            spacing: 3

            model: ScriptModel {
                values: [...Bluetooth.devices.values].sort((a, b) => {
                    // Connected -> paired -> others
                    let conn = (b.connected - a.connected) || (b.paired - a.paired);
                    if (conn !== 0)
                        return conn;

                    // Ones with meaningful names before MAC addresses
                    const macRegex = /^([0-9A-Fa-f]{2}-){5}[0-9A-Fa-f]{2}$/;
                    const aIsMac = macRegex.test(a.name);
                    const bIsMac = macRegex.test(b.name);
                    if (aIsMac !== bIsMac)
                        return aIsMac ? 1 : -1;

                    // Alphabetical by name
                    return a.name.localeCompare(b.name);
                })
            }

            delegate: BluetoothDeviceItem {
                required property BluetoothDevice modelData
                required property int index
                device: modelData
                list: listView

                anchors.left: parent?.left
                anchors.right: parent?.right
            }
        }

        RowLayout {

            Layout.preferredHeight: 50
            Layout.fillWidth: true
            spacing: Padding.tiny

            StyledSwitch {
                checked: BluetoothService.adapter.discoverable
                onClicked: BluetoothService.adapter.discoverable = checked
                Layout.leftMargin: Padding.huge
            }

            StyledText {
                text: "Visible"
                color: Colors.colOnLayer0
                Layout.fillWidth: true
                leftPadding: Padding.large
            }

            DialogButton {
                buttonText: qsTr("Details")
                onClicked: {
                    root.show = false;
                    NoonUtils.execDetached(Mem.options.apps.bluetooth);
                    NoonUtils.callIpc("sidebar hide");
                }
            }

            DialogButton {
                buttonText: qsTr("Discover")
                onClicked: BluetoothService.startDiscovery()
            }

            DialogButton {
                buttonText: qsTr("Done")
                onClicked: root.show = false
            }
        }
    }
}
