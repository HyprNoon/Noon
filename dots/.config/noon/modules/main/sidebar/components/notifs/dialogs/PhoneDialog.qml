import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.common.functions
import qs.services

BottomDialog {
    id: root

    collapsedHeight: parent.height / 2

    contentItem: ColumnLayout {
        anchors.fill: parent
        anchors.margins: Padding.veryhuge
        spacing: Padding.large

        StyledListView {
            id: devicesList
            Layout.fillHeight: true
            Layout.fillWidth: true
            _model: KdeConnectService.devices ?? []
            delegate: DeviceItem {
                list: devicesList
            }
        }

        ButtonGroup {
            Layout.maximumHeight: 40
            Layout.fillWidth: true

            Spacer {}

            DialogButton {
                buttonText: qsTr("Refresh")
                onClicked: KdeConnectService.getDevices()
            }

            DialogButton {
                buttonText: qsTr("Done")
                onClicked: root.show = false
            }
        }
    }
    component DeviceItem: StyledRect {
        id: root
        required property var modelData
        required property int index

        property var list
        readonly property var device: modelData
        topRadius: index === 0 ? Rounding.huge : Rounding.tiny
        bottomRadius: index === list.count - 1 ? Rounding.huge : Rounding.tiny

        anchors.right: parent?.right
        anchors.left: parent?.left

        implicitHeight: 140
        color: Colors.colLayer3
        Symbol {
            z: 999
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: Padding.huge
            icon: "check"
            iconSize: 24
            visible: Mem.states.services.kdeconnect.selectedDeviceIndex === root.index
        }
        MouseArea {
            anchors.fill: parent
            propagateComposedEvents: true
            onClicked: Mem.states.services.kdeconnect.selectedDeviceIndex = root.index
        }
        ButtonGroup {
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: Padding.huge
            spacing: Padding.small
            height: 40
            width: 135
            Repeater {
                model: [
                    {
                        "icon": "notifications_active",
                        "action": () => KdeConnectService.ringDevice(root.device.id)
                    },
                    {
                        "icon": "share",
                        "action": () => KdeConnectService.shareFiles(root.device.id)
                    },
                    {
                        "icon": "content_paste",
                        "action": () => KdeConnectService.sendClipboard(root.device.id)
                    }
                ]

                delegate: GroupButtonWithIcon {
                    required property var modelData
                    materialIcon: modelData?.icon ?? ""
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    colBackground: Colors.colLayer4
                    onClicked: () => modelData.action()
                }
            }
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: Padding.huge
            spacing: Padding.massive

            MaterialShapeWrappedSymbol {
                text: StringUtils.capitalizeFirstLetter(device.name !== "" ? "phone_android" : "device_unknown")
                shape: MaterialShape.Shape.Ghostish
                padding: Padding.huge
                iconSize: 54
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft
                spacing: 0

                StyledText {
                    text: device.name
                    font.pixelSize: Fonts.sizes.huge
                    font.variableAxes: Fonts.variableAxes.title
                    color: Colors.colOnLayer2
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignLeft
                }
                // StyledText {
                //     text: device.id
                //     truncate: true
                //     Layout.rightMargin: Padding.massive
                //     font.pixelSize: Fonts.sizes.verylarge
                //     font.variableAxes: Fonts.variableAxes.title
                //     color: Colors.colSubtext
                //     Layout.fillWidth: true
                //     horizontalAlignment: Text.AlignLeft
                // }
            }
        }
    }
}
