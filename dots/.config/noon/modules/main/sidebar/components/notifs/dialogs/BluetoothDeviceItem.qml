import qs.common
import qs.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts

DialogListItem {
    id: root
    required property var device
    property bool expanded: false
    pointingHandCursor: !expanded

    onClicked: expanded = !expanded
    altAction: () => expanded = !expanded

    component ActionButton: DialogButton {
        colBackground: Colors.colPrimary
        colBackgroundHover: Colors.colPrimaryHover
        colRipple: Colors.colPrimaryActive
        colText: Colors.colOnPrimary
    }

    contentItem: ColumnLayout {
        anchors {
            fill: parent
            topMargin: root.verticalPadding
            leftMargin: root.horizontalPadding
            rightMargin: root.horizontalPadding
        }
        spacing: 0

        RowLayout {
            // Name
            spacing: 10

            Symbol {
                font.pixelSize: Fonts.sizes.verylarge
                text: BluetoothService.getDeviceIcon(root.device?.icon || "")
                color: Colors.colOnSurfaceVariant
            }

            ColumnLayout {
                spacing: 2
                Layout.fillWidth: true
                StyledText {
                    Layout.fillWidth: true
                    color: Colors.colOnSurfaceVariant
                    elide: Text.ElideRight
                    text: root.device?.name || qsTr("Unknown device")
                }
                StyledText {
                    visible: (root.device?.connected || root.device?.paired) ?? false
                    Layout.fillWidth: true
                    font.pixelSize: Fonts.sizes.verysmall
                    color: Colors.colSubtext
                    elide: Text.ElideRight
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
                icon: "keyboard_arrow_down"
                font.pixelSize: Fonts.sizes.verylarge
                color: Colors.colOnLayer3
                rotation: root.expanded ? 180 : 0
                Behavior on rotation {
                    Anim {}
                }
            }
        }

        RowLayout {
            visible: root.expanded
            Layout.topMargin: 8
            Item {
                Layout.fillWidth: true
            }
            ActionButton {
                buttonText: root.device?.connected ? qsTr("Disconnect") : qsTr("Connect")

                onClicked: {
                    if (root.device?.connected) {
                        root.device.disconnect();
                    } else {
                        root.device.connect();
                    }
                }
            }
            ActionButton {
                visible: root.device?.paired ?? false
                colBackground: Colors.colError
                colBackgroundHover: Colors.colErrorHover
                colRipple: Colors.colErrorActive
                colText: Colors.colOnError

                buttonText: qsTr("Forget")
                onClicked: {
                    root.device?.forget();
                }
            }
        }
        Item {
            Layout.fillHeight: true
        }
    }
}
