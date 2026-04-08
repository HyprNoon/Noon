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
        anchors.margins: Padding.verylarge
        spacing: Padding.large

        BottomDialogHeader {
            title: qsTr("Bluetooth devices")
        }

        BottomDialogSeparator {
            extraVisibleCondition: !loading.visible
        }

        StyledIndeterminateProgressBar {
            id: loading
            visible: Bluetooth.defaultAdapter?.discovering ?? false
            Layout.fillWidth: true
        }

        StyledListView {
            Layout.fillHeight: true
            Layout.fillWidth: true
            clip: true
            spacing: 0

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
                device: modelData
                anchors {
                    left: parent?.left
                    right: parent?.right
                }
            }
        }

        RowLayout {
            Layout.preferredHeight: 50
            Layout.fillWidth: true

            StyledSwitch {
                checked: BluetoothService.currentDevice.discoverable
                onCheckedChanged: BluetoothService.currentDevice.discoverable = !BluetoothService.currentDevice.discoverable
                Layout.rightMargin: Padding.large
            }

            StyledText {
                text: "Discoverable"
                color: Colors.colOnLayer0
                Layout.fillWidth: true
            }

            DialogButton {
                buttonText: qsTr("Details")
                onClicked: {
                    root.show = false;
                    NoonUtils.execDetached(Mem.options.apps.bluetooth);
                    GlobalStates.main.sidebar.visible = false;
                }
            }

            DialogButton {
                buttonText: qsTr("Done")
                onClicked: root.show = false
            }
        }
    }
}
