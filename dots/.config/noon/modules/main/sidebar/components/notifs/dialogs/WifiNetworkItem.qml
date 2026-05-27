import qs.common
import qs.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts

StyledRect {
    id: root
    required property var network
    required property Item list

    anchors.right: parent?.right
    anchors.left: parent?.left
    implicitHeight: contentCol.implicitHeight + Padding.massive
    topRadius: index === 0 ? Rounding.huge : Rounding.verysmall
    bottomRadius: index === (list.count - 1) ? Rounding.huge : Rounding.verysmall

    color: Colors.colLayer3
    readonly property bool requirePassword: network.security && network.security.length > 0 && !network.saved
    property bool expanded: false
    property bool showPasswordEntry: false

    MouseArea {
        z: 0
        // enabled: network?.active ?? false
        propagateComposedEvents: true
        anchors.fill: parent
        onClicked: root.expanded = !root.expanded
    }

    function clear() {
        passwordField.text = "";
        root.showPasswordEntry = false;
        root.expanded = false;
    }

    function connectNetwork() {
        if (root.requirePassword && !root.showPasswordEntry) {
            root.showPasswordEntry = true;
            return;
        }
        NetworkService.manager.connectToWifiNetwork(root.network.ssid, passwordField.text);
        Qt.callLater(clear);
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
            Layout.minimumHeight: 35
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Padding.large

            Symbol {
                font.pixelSize: Fonts.sizes.verylarge
                text: {
                    const s = root.network?.strength ?? 0;
                    if (s > 80)
                        return "signal_wifi_4_bar";
                    if (s > 60)
                        return "network_wifi_3_bar";
                    if (s > 40)
                        return "network_wifi_2_bar";
                    if (s > 20)
                        return "network_wifi_1_bar";
                    return "signal_wifi_0_bar";
                }
                fill: 1
                color: Colors.colOnSurfaceVariant
            }

            StyledText {
                Layout.fillWidth: true
                color: Colors.colOnSurfaceVariant
                truncate: true
                font.pixelSize: Fonts.sizes.small
                text: root.network?.ssid ?? qsTr("Unknown")
            }

            Symbol {
                visible: (root.network?.security && root.network.security.length > 0) || (root.network?.active ?? false)
                text: {
                    if (root.network?.active)
                        return "check";
                    if (root.network?.saved)
                        return "lock_open";
                    return "lock";
                }
                font.pixelSize: Fonts.sizes.verylarge
                color: root.network?.active ? Colors.m3.m3primary : Colors.colOnSurfaceVariant
            }
        }

        ColumnLayout {
            visible: root.expanded
            Layout.fillWidth: true
            spacing: Padding.normal

            MaterialTextField {
                id: passwordField
                visible: root.showPasswordEntry && root.requirePassword
                Layout.fillWidth: true
                placeholderText: qsTr("Password")
                echoMode: TextInput.Password
                inputMethodHints: Qt.ImhSensitiveData
                focus: root.showPasswordEntry
                onAccepted: root.connectNetwork()
            }

            ActionsRow {
                model: [
                    {
                        name: "Cancel",
                        action: () => root.clear()
                    },
                    {
                        name: root.network.active ? "Forget" : "Connect",
                        action: () => {
                            if (root.network.active)
                                NetworkService.manager.forgetWifiNetwork(root.network.ssid);
                            else
                                root.connectNetwork();
                        }
                    }
                ]
            }
        }

        DialogButton {
            visible: (root.network?.active ?? false) && (!root.network?.security || root.network.security.length === 0)
            Layout.fillWidth: true
            buttonText: qsTr("Open network portal")
            colBackground: Colors.colLayer4
            colBackgroundHover: Colors.colLayer4Hover
            colRipple: Colors.colLayer4Active
            onClicked: {
                Qt.openUrlExternally("http://nmcheck.gnome.org/");
                NoonUtils.callIpc("sidebar hide");
            }
        }
    }

    component ActionsRow: RowLayout {
        id: root
        required property var model
        Layout.bottomMargin: -Padding.normal
        Layout.alignment: Qt.AlignBottom
        Layout.fillWidth: true
        spacing: Padding.large

        Item {
            Layout.fillWidth: true
        }

        Repeater {
            model: root.model
            delegate: DialogButton {
                buttonText: modelData.name
                releaseAction: () => modelData.action()
            }
        }
    }
}
