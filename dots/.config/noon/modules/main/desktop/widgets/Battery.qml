import QtQuick
import QtQuick.Layouts
import qs.services
import qs.common
import qs.common.widgets

IslandComponent {
    ColumnLayout {
        id: columnLayout
        anchors.leftMargin: Padding.massive
        anchors.margins: Padding.veryhuge
        anchors.fill: parent
        spacing: -10

        StyledText {
            text: "Battery"
            horizontalAlignment: Text.AlignLeft
            color: Colors.colSubtext
            font.pixelSize: Fonts.sizes.verylarge
            font.variableAxes: Fonts.variableAxes.title
        }

        Spacer {}

        StyledText {
            Layout.fillHeight: true
            Layout.fillWidth: true
            text: Math.round(BatteryService.percentage * 100) + "%"

            font {
                pixelSize: 64
                family: Fonts.family.numbers
                variableAxes: Fonts.variableAxes.longNumbers
            }
        }
        RowLayout {
            id: statusRow
            Layout.alignment: Qt.AlignBottom

            function formatTime(seconds) {
                var h = Math.floor(seconds / 3600);
                var m = Math.floor((seconds % 3600) / 60);
                if (h > 0)
                    return `${h}h, ${m}m`;
                else
                    return `${m}m`;
            }
            states: [
                State {
                    name: "charging"
                    when: BatteryService.isCharging
                    PropertyChanges {
                        target: icon
                        text: "bolt"
                    }
                    PropertyChanges {
                        target: description
                        text: "Maxing in "
                    }
                    PropertyChanges {
                        target: value
                        text: statusRow.formatTime(BatteryService.timeToFull)
                    }
                },
                State {
                    name: "draining"
                    when: !BatteryService.isCharging
                    PropertyChanges {
                        target: icon
                        text: "timer"
                    }
                    PropertyChanges {
                        target: description
                        text: "Draining in "
                    }
                    PropertyChanges {
                        target: value
                        text: statusRow.formatTime(BatteryService.timeToEmpty)
                    }
                }
            ]
            Symbol {
                id: icon
                color: Colors.m3.m3onSurfaceVariant
                fill: 1
                font.pixelSize: Fonts.sizes.large
            }

            StyledText {
                id: description
                color: Colors.m3.m3onSurfaceVariant
                truncate: true
                Layout.fillWidth: true
            }

            StyledText {
                id: value
                horizontalAlignment: Text.AlignRight
                color: Colors.m3.m3onSurfaceVariant
            }
        }
    }
}
