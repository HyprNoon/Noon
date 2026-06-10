import qs.common
import qs.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire

StyledRect {
    id: root
    property bool showDeviceSelector: false
    property bool deviceSelectorInput
    property PwNode selectedDevice

    readonly property list<PwNode> appPwNodes: Pipewire.nodes.values.filter(node => {
        return node.isSink && node.isStream;
    })
    Keys.onEscapePressed: bottomDialog.show = false
    color: Colors.colLayer1
    radius: Rounding.verylarge

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Padding.large
        spacing: Padding.huge

        PageHeader {
            title: "Sounds"
            subTitle: "Manage volume outputs."
        }
        StyledListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 4

            model: root.appPwNodes
            delegate: MixerItem {
                list: listView
                anchors.left: parent?.left
                anchors.right: parent?.right
                topRadius: index === 0 ? Rounding.verylarge : Rounding.tiny
                bottomRadius: index === listView.count - 1 ? Rounding.huge : Rounding.tiny
            }
            PagePlaceholder {
                visible: listView.count === 0
                icon: "brand_awareness"
                title: "Nothing Playing"
                shape: MaterialShape.Shape.Bun
            }
        }
        // Device selector
        StyledRect {
            Layout.fillWidth: true
            Layout.fillHeight: false
            implicitHeight: deviceSelectorRowLayout.implicitHeight + Padding.huge
            radius: Rounding.huge
            color: Colors.colSurfaceContainerLow

            ButtonGroup {
                id: deviceSelectorRowLayout
                anchors.fill: parent
                anchors.margins: Padding.normal
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
    }

    BottomDialog {
        id: bottomDialog
        show: root.showDeviceSelector
        collapsedHeight: 240
        enableStagedReveal: false
        bottomAreaReveal: false
        contentItem: ColumnLayout {
            id: dialogColumnLayout
            anchors.fill: parent
            anchors.margins: Padding.huge
            spacing: 0

            PageHeader {
                id: dialogTitle
                title: root.deviceSelectorInput ? "Select input device" : "Select output device"
                showCloseButton: false
            }
            PageSeparator {}

            StyledListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                hint: false
                clip: true
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
