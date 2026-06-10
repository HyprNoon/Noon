import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.services
import qs.store

StyledPopup {
    id: root

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 16
        implicitWidth: 360

        // Header Section: Main connection state with dynamic icon indicator
        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Rectangle {
                width: 40
                height: 40
                radius: 12
                color: NetworkService.manager.ethernet || NetworkService.manager.wifi ? Colors.m3.m3primaryContainer : Colors.m3.m3errorContainer

                Symbol {
                    anchors.centerIn: parent
                    icon: NetworkService.manager.ethernet ? "lan" : NetworkService.manager.wifi ? "wifi" : "wifi-off"
                    color: NetworkService.manager.ethernet || NetworkService.manager.wifi ? Colors.m3.m3onPrimaryContainer : Colors.m3.m3onErrorContainer
                    font.pixelSize: 20
                }
            }

            ColumnLayout {
                spacing: 2
                Layout.fillWidth: true

                StyledText {
                    text: NetworkService.manager.ethernet ? qsTr("Ethernet") : NetworkService.manager.wifi ? qsTr("Wi-Fi") : qsTr("Disconnected")
                    font.weight: Font.DemiBold
                    font.pixelSize: Fonts.sizes.large
                    color: Colors.m3.m3onSurface
                }

                StyledText {
                    text: NetworkService.manager.wifi && NetworkService.manager.networkName ? NetworkService.manager.networkName : NetworkService.manager.ipAddress
                    font.pixelSize: Fonts.sizes.small
                    color: Colors.m3.m3onSurfaceVariant
                    visible: NetworkService.manager.ethernet || NetworkService.manager.wifi
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
            }
        }

        // Divider
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Colors.m3.m3outlineVariant
        }

        // Metrics Grid: Side-by-side speed stats
        RowLayout {
            Layout.fillWidth: true
            spacing: 16
            visible: NetworkService.manager.ethernet || NetworkService.manager.wifi

            // Download
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Symbol {
                    icon: "keyboard_arrow_down"
                    color: Colors.m3.m3primary
                    font.pixelSize: 18
                }

                ColumnLayout {
                    spacing: 2

                    StyledText {
                        text: qsTr("Download")
                        font.pixelSize: Fonts.sizes.small
                        color: Colors.m3.m3onSurfaceVariant
                    }

                    StyledText {
                        text: NetworkService.manager.downloadSpeedText
                        font.weight: Font.Medium
                        font.pixelSize: Fonts.sizes.medium
                        color: Colors.m3.m3onSurface
                    }
                }
            }

            // Upload
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Symbol {
                    icon: "keyboard_arrow_up"
                    color: Colors.m3.m3primary
                    font.pixelSize: 18
                }

                ColumnLayout {
                    spacing: 2

                    StyledText {
                        text: qsTr("Upload")
                        font.pixelSize: Fonts.sizes.small
                        color: Colors.m3.m3onSurfaceVariant
                    }

                    StyledText {
                        text: NetworkService.manager.uploadSpeedText
                        font.weight: Font.Medium
                        font.pixelSize: Fonts.sizes.medium
                        color: Colors.m3.m3onSurface
                    }
                }
            }
        }

        // Network Metadata Card Section
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 10
            visible: NetworkService.manager.ethernet || NetworkService.manager.wifi

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Colors.m3.m3outlineVariant
            }

            RowLayout {
                Layout.fillWidth: true
                visible: NetworkService.manager.wifi && NetworkService.manager.networkStrength > 0

                RowLayout {
                    spacing: 6
                    Symbol {
                        icon: "broadcast_on_home"
                        color: Colors.m3.m3onSurfaceVariant
                        font.pixelSize: 16
                    }
                    StyledText {
                        text: qsTr("Signal Strength")
                        color: Colors.m3.m3onSurfaceVariant
                    }
                }

                StyledText {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignRight
                    text: NetworkService.manager.networkStrengthText
                    color: Colors.m3.m3onSurface
                    font.weight: Font.Medium
                }
            }

            // IP Address Row
            RowLayout {
                Layout.fillWidth: true

                RowLayout {
                    spacing: 6
                    Symbol {
                        icon: "lan"
                        color: Colors.m3.m3onSurfaceVariant
                        font.pixelSize: 16
                    }
                    StyledText {
                        text: qsTr("IP Address")
                        color: Colors.m3.m3onSurfaceVariant
                    }
                }

                StyledText {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignRight
                    text: NetworkService.manager.ipAddress
                    color: Colors.m3.m3onSurface
                    font.weight: Font.Medium
                    elide: Text.ElideRight
                }
            }
        }
    }
}
