import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

BottomDialog {
    id: root

    collapsedHeight: parent.height * 0.35

    contentItem: ColumnLayout {
        anchors.fill: parent
        anchors.margins: Padding.massive
        spacing: Padding.large

        PageHeader {
            title: "Appearance"
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: Padding.large
            spacing: Padding.large

            RowLayout {
                Layout.preferredHeight: 50
                Layout.fillWidth: true
                spacing: Padding.small

                Symbol {
                    text: Mem.looks.mode === "dark" ? "dark_mode" : "light_mode"
                    font.pixelSize: Fonts.sizes.verylarge
                    color: Colors.colOnSurfaceVariant
                }

                StyledText {
                    Layout.fillWidth: true
                    text: qsTr("Dark Mode")
                    color: Colors.colOnSurfaceVariant
                }

                StyledSwitch {
                    checked: Mem.looks.mode === "dark"
                    onToggled: {
                        Mem.looks.mode = checked ? "dark" : "light";
                        WallpaperService.toggleShellMode();
                    }
                }
            }

            RowLayout {
                Layout.preferredHeight: 50
                Layout.fillWidth: true
                spacing: Padding.small

                Symbol {
                    text: "schedule"
                    font.pixelSize: Fonts.sizes.verylarge
                    color: Colors.colOnSurfaceVariant
                }

                StyledText {
                    Layout.fillWidth: true
                    text: qsTr("Auto Mode (Time-based)")
                    color: Colors.colOnSurfaceVariant
                }

                StyledSwitch {
                    checked: Mem.looks.autoShellMode
                    onToggled: Mem.looks.autoShellMode = checked
                }
            }

            RowLayout {
                Layout.preferredHeight: 50
                Layout.fillWidth: true
                spacing: Padding.small

                Symbol {
                    text: "auto_awesome"
                    font.pixelSize: Fonts.sizes.verylarge
                    color: Colors.colOnSurfaceVariant
                }

                StyledText {
                    Layout.fillWidth: true
                    text: qsTr("Auto Color Scheme")
                    color: Colors.colOnSurfaceVariant
                }

                StyledSwitch {
                    checked: Mem.looks.autoSchemeSelection
                    onToggled: Mem.looks.autoSchemeSelection = checked
                }
            }
            Spacer {}
        }

        RowLayout {
            Layout.preferredHeight: 50
            Layout.fillWidth: true

            Item {
                Layout.fillWidth: true
            }

            DialogButton {
                buttonText: qsTr("Pick Accent Color")
                onClicked: WallpaperService.pickAccentColor()
            }

            DialogButton {
                buttonText: qsTr("Done")
                onClicked: root.show = false
            }
        }
    }
}
