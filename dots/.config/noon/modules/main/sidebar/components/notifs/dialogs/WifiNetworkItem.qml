import qs.common
import qs.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts

DialogListItem {
    id: root
    required property var network

    property bool showPasswordPrompt: false

    active: network?.active ?? false

    // Reset password prompt when network changes
    onNetworkChanged: {
        showPasswordPrompt = false;
    }

    onClicked: {
        if (network.active) {
            // Disconnect if already connected
            NetworkService.disconnectWifiNetwork();
        } else {
            const isSecured = network.security && network.security.length > 0;
            const isSaved = network.saved ?? false;

            if (isSecured && !isSaved) {
                // Show password prompt only for unsaved secured networks
                showPasswordPrompt = true;
            } else {
                // Connect directly (saved networks or open networks)
                NetworkService.connectToWifiNetwork(network.ssid, "");
            }
        }
    }

    contentItem: ColumnLayout {
        anchors {
            fill: parent
            topMargin: root.verticalPadding
            bottomMargin: root.verticalPadding
            leftMargin: root.horizontalPadding
            rightMargin: root.horizontalPadding
        }
        spacing: 8

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

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
                color: Colors.colOnSurfaceVariant
            }

            StyledText {
                Layout.fillWidth: true
                color: Colors.colOnSurfaceVariant
                elide: Text.ElideRight
                text: root.network?.ssid ?? qsTr("Unknown")
            }

            Symbol {
                visible: {
                    const hasSecurity = root.network?.security && root.network.security.length > 0;
                    const isActive = root.network?.active ?? false;
                    return hasSecurity || isActive;
                }
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

        // Password prompt
        ColumnLayout {
            Layout.fillWidth: true
            visible: root.showPasswordPrompt
            spacing: 8

            MaterialTextField {
                id: passwordField
                Layout.fillWidth: true
                placeholderText: qsTr("Password")
                echoMode: TextInput.Password
                inputMethodHints: Qt.ImhSensitiveData
                focus: root.showPasswordPrompt

                onAccepted: {
                    NetworkService.connectToWifiNetwork(root.network.ssid, text);
                    root.showPasswordPrompt = false;
                    text = "";
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Item {
                    Layout.fillWidth: true
                }

                DialogButton {
                    buttonText: qsTr("Cancel")
                    onClicked: {
                        root.showPasswordPrompt = false;
                        passwordField.text = "";
                    }
                }

                DialogButton {
                    buttonText: qsTr("Connect")
                    onClicked: {
                        NetworkService.connectToWifiNetwork(root.network.ssid, passwordField.text);
                        root.showPasswordPrompt = false;
                        passwordField.text = "";
                    }
                }
            }
        }

        // Public wifi portal (for active open networks)
        ColumnLayout {
            Layout.fillWidth: true
            visible: {
                const isActive = root.network?.active ?? false;
                const isOpen = !root.network?.security || root.network.security.length === 0;
                return isActive && isOpen;
            }

            DialogButton {
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
    }
}
