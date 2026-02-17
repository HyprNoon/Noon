import QtQuick
import QtQuick.Layouts
import qs.services
import qs.common
import qs.common.widgets

IslandComponent {
    ColumnLayout {
        id: columnLayout

        anchors.centerIn: parent
        spacing: 4

        // Header
        Row {
            id: header

            spacing: 5

            Symbol {
                anchors.verticalCenter: parent.verticalCenter
                fill: 0
                font.weight: Font.Medium
                text: "battery_android_full"
                font.pixelSize: Fonts.sizes.large
                color: Colors.m3.m3onSurfaceVariant
            }

            StyledText {
                anchors.verticalCenter: parent.verticalCenter
                text: "Battery"
                color: Colors.m3.m3onSurfaceVariant

                font {
                    weight: Font.Medium
                    pixelSize: Fonts.sizes.normal
                }
            }

            Spacer {}
        }

        StyledText {
            text: Math.round(BatteryService.percentage * 100) + "%"

            font {
                pixelSize: Fonts.sizes.title
                family: Fonts.family.numbers
                variableAxes: Fonts.variableAxes.longNumbers
            }
        }
        // This row is hidden when the battery is full.

        RowLayout {
            property bool rowVisible: {
                let timeValue = BatteryService.isCharging ? BatteryService.timeToFull : BatteryService.timeToEmpty;
                let power = BatteryService.energyRate;
                return !(BatteryService.chargeState == 4 || timeValue <= 0 || power <= 0.01);
            }

            spacing: 5
            Layout.fillWidth: true
            visible: rowVisible
            opacity: rowVisible ? 1 : 0

            Symbol {
                text: "schedule"
                color: Colors.m3.m3onSurfaceVariant
                font.pixelSize: Fonts.sizes.large
            }

            StyledText {
                text: BatteryService.isCharging ? qsTr("Time to full:") : qsTr("Time to empty:")
                color: Colors.m3.m3onSurfaceVariant
            }

            StyledText {
                function formatTime(seconds) {
                    var h = Math.floor(seconds / 3600);
                    var m = Math.floor((seconds % 3600) / 60);
                    if (h > 0)
                        return `${h}h, ${m}m`;
                    else
                        return `${m}m`;
                }

                Layout.fillWidth: true
                horizontalAlignment: Text.AlignRight
                color: Colors.m3.m3onSurfaceVariant
                text: {
                    if (BatteryService.isCharging)
                        return formatTime(BatteryService.timeToFull);
                    else
                        return formatTime(BatteryService.timeToEmpty);
                }
            }

            Behavior on opacity {
                Anim {}
            }
        }

        RowLayout {
            property bool rowVisible: !(BatteryService.chargeState != 4 && BatteryService.energyRate == 0)

            spacing: 5
            Layout.fillWidth: true
            visible: rowVisible
            opacity: rowVisible ? 1 : 0

            Symbol {
                text: "bolt"
                color: Colors.m3.m3onSurfaceVariant
                font.pixelSize: Fonts.sizes.large
            }

            StyledText {
                text: {
                    if (BatteryService.chargeState == 4)
                        return qsTr("Fully charged");
                    else if (BatteryService.chargeState == 1)
                        return qsTr("Charging:");
                    else
                        return qsTr("Discharging:");
                }
                color: Colors.m3.m3onSurfaceVariant
            }

            StyledText {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignRight
                color: Colors.m3.m3onSurfaceVariant
                text: {
                    if (BatteryService.chargeState == 4)
                        return "";
                    else
                        return `${BatteryService.energyRate.toFixed(2)}W`;
                }
            }

            Behavior on opacity {
                Anim {}
            }
        }
    }
}
