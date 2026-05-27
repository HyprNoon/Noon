import qs.common
import qs.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts

StyledRect {
    id: root
    required property var device
    required property Item list

    anchors.right: parent?.right
    anchors.left: parent?.left
    implicitHeight: contentCol.implicitHeight + Padding.massive
    topRadius: index === 0 ? Rounding.huge : Rounding.verysmall
    bottomRadius: index === (list.count - 1) ? Rounding.huge : Rounding.verysmall

    color: Colors.colLayer3
    property bool expanded: false

    MouseArea {
        z: 0
        propagateComposedEvents: true
        anchors.fill: parent
        onClicked: root.expanded = !root.expanded
    }

    ColumnLayout {
        id: contentCol
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.leftMargin: Padding.huge
        anchors.rightMargin: Padding.huge
        anchors.topMargin: Padding.normal

        spacing: Padding.normal

        RowLayout {
            Layout.alignment: Qt.AlignVCenter
            Layout.minimumHeight: 40
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Padding.large

            Symbol {
                font.pixelSize: Fonts.sizes.verylarge
                text: BluetoothService.getDeviceIcon(root.device?.icon || "")
                fill: 1
                color: Colors.colOnSurfaceVariant
            }

            ColumnLayout {
                spacing: 2
                Layout.fillWidth: true
                StyledText {
                    Layout.fillWidth: true
                    color: Colors.colOnSurfaceVariant
                    truncate: true
                    font.pixelSize: Fonts.sizes.small
                    text: root.device?.name || qsTr("Unknown device")
                }
                StyledText {
                    visible: (root.device?.connected || root.device?.paired) ?? false
                    Layout.fillWidth: true
                    font.pixelSize: Fonts.sizes.verysmall
                    color: Colors.colSubtext
                    truncate: true
                    text: {
                        if (!root.device?.paired)
                            return "";
                        let statusText = root.device?.connected ? qsTr("Connected") : qsTr("Paired");
                        if (!root.device?.batteryAvailable)
                            return statusText;
                        statusText += ` • ${Math.round(root.device?.battery * 100)}%`;
                        return statusText;
                    }
                }
            }

            Symbol {
                visible: root.device?.connected ?? false
                text: "check"
                font.pixelSize: Fonts.sizes.verylarge
                color: Colors.m3.m3primary
            }
        }

        ColumnLayout {
            visible: root.expanded
            Layout.fillWidth: true
            spacing: Padding.normal

            ActionsRow {
                model: [
                    {
                        name: qsTr("Forget"),
                        visible: root.device?.paired ?? false,
                        action: () => {
                            root.device?.forget();
                        }
                    },
                    {
                        name: root.device?.connected ? qsTr("Disconnect") : qsTr("Connect"),
                        action: () => {
                            if (root.device?.connected) {
                                root.device.disconnect();
                            } else {
                                root.device.connect();
                            }
                        }
                    },
                ]
            }
        }
    }

    component ActionsRow: RowLayout {
        id: actionsRoot
        required property var model
        Layout.bottomMargin: -Padding.normal
        Layout.alignment: Qt.AlignBottom
        Layout.fillWidth: true
        spacing: Padding.large

        Item {
            Layout.fillWidth: true
        }

        Repeater {
            model: actionsRoot.model
            delegate: DialogButton {
                visible: modelData.visible !== undefined ? modelData.visible : true
                buttonText: modelData.name
                releaseAction: () => modelData.action()
            }
        }
    }
}
