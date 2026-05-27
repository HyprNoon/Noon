import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

BottomDialog {
    id: root

    collapsedHeight: 420

    contentItem: ColumnLayout {
        anchors.fill: parent
        anchors.margins: Padding.verylarge
        spacing: 0

        PageHeader {
            title: qsTr("Nightlight")
            subTitle: "Adjust HyprSunset from here"
        }

        PageSeparator {}

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: Padding.large
            spacing: 16

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Symbol {
                    text: "nightlight"
                    font.pixelSize: Fonts.sizes.verylarge
                    color: Colors.colOnSurfaceVariant
                }

                StyledText {
                    Layout.fillWidth: true
                    text: qsTr("Enable Nightlight")
                    color: Colors.colOnSurfaceVariant
                }

                StyledSwitch {
                    checked: Mem.states.services.nightLight.enabled
                    onToggled: Mem.states.services.nightLight.enabled = checked
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Symbol {
                    text: "night_sight_auto"
                    font.pixelSize: Fonts.sizes.verylarge
                    color: Colors.colOnSurfaceVariant
                }

                StyledText {
                    Layout.fillWidth: true
                    text: qsTr("Auto")
                    color: Colors.colOnSurfaceVariant
                }

                StyledSwitch {
                    checked: Mem.options.services.time.autoNightLightCycle
                    onToggled: Mem.options.services.time.autoNightLightCycle = checked
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Symbol {
                    text: "nightlight"
                    font.pixelSize: Fonts.sizes.verylarge
                    color: Colors.colOnSurfaceVariant
                }

                StyledText {
                    Layout.fillWidth: true
                    text: qsTr("Temperature")
                    color: Colors.colOnSurfaceVariant
                }

                StyledText {
                    text: NightLightService.temperature + "K"
                    color: Colors.colOnSurfaceVariant
                    opacity: 0.7
                }
            }

            StyledSlider {
                Layout.fillWidth: true
                from: 3000
                to: 6500
                value: NightLightService.temperature
                enabled: NightLightService.temperature
                onMoved: NightLightService.temperature = value
                enableTooltip: false
            }

            Item {
                Layout.fillHeight: true
            }
        }

        RowLayout {
            Layout.preferredHeight: 50
            Layout.fillWidth: true

            Item {
                Layout.fillWidth: true
            }

            DialogButton {
                buttonText: qsTr("Done")
                onClicked: root.show = false
            }
        }
    }
}
