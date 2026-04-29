import qs.common
import qs.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire

Item {
    id: root
    property bool showDeviceSelector: false
    property bool deviceSelectorInput
    property PwNode selectedDevice

    readonly property list<PwNode> appPwNodes: Pipewire.nodes.values.filter(node => {
        return node.isSink && node.isStream;
    })
    Keys.onEscapePressed: bottomDialog.show = false

    ColumnLayout {
        anchors.fill: parent
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            StyledListView {
                id: listView
                model: root.appPwNodes
                clip: true
                anchors.fill: parent
                anchors.margins: Padding.huge
                spacing: Padding.large

                delegate: MixerItem {
                    required property var modelData
                    anchors.left: parent?.left
                    anchors.right: parent?.right
                }
            }
            PagePlaceholder {
                visible: listView.count === 0
                icon: "brand_awareness"
                title: "Nothing Playing"
                shape: MaterialShape.Shape.Bun
            }
        }

        // Device selector
        ButtonGroup {
            id: deviceSelectorRowLayout
            Layout.fillWidth: true
            Layout.fillHeight: false
            AudioDeviceSelectorButton {
                Layout.fillWidth: true
                input: false
                onClicked: {
                    bottomDialog.show = true;
                    root.deviceSelectorInput = false;
                }
            }
            AudioDeviceSelectorButton {
                Layout.fillWidth: true
                input: true
                onClicked: {
                    bottomDialog.show = true;
                    root.deviceSelectorInput = true;
                }
            }
        }
    }

    BottomDialog {
        id: bottomDialog
        show: root.showDeviceSelector
        collapsedHeight: 180 + dialogFlickable.contentHeight
        enableStagedReveal: false
        bottomAreaReveal: false
        contentItem: ColumnLayout {
            id: dialogColumnLayout
            anchors.fill: parent
            anchors.margins: Padding.huge
            spacing: 0

            BottomDialogHeader {
                id: dialogTitle
                title: root.deviceSelectorInput ? "Select input device" : "Select output device"
                showCloseButton: false
            }
            BottomDialogSeparator {}

            StyledListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                hint: false
                model: ScriptModel {
                    values: Pipewire.nodes.values.filter(node => {
                        return !node.isStream && node.isSink !== root.deviceSelectorInput && node.audio;
                    })
                }
                delegate: StyledRadioButton {
                    id: radioButton
                    required property var modelData
                    anchors.left: parent?.left
                    anchors.right: parent?.right
                    anchors.leftMargin: Padding.large
                    description: modelData.description
                    checked: modelData.id === Pipewire.defaultAudioSink?.id
                    onCheckedChanged: {
                        if (!checked)
                            return;
                        if (root.deviceSelectorInput) {
                            Pipewire.preferredDefaultAudioSource = root.selectedDevice;
                        } else {
                            Pipewire.preferredDefaultAudioSink = root.selectedDevice;
                        }
                    }
                }
            }

            RowLayout {
                id: dialogButtonsRowLayout
                Layout.alignment: Qt.AlignRight

                Item {
                    Layout.fillWidth: true
                }
                DialogButton {
                    buttonText: "Done"
                    onClicked: bottomDialog.show = false
                }
            }
        }
    }
}
