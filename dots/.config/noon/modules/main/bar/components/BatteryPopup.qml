import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.services

StyledPopup {
    id: root
    contentMargins: 0
    contentItem: StyledRect {
        id: main
        clip: true
        color: Colors.colLayer0
        anchors.centerIn: parent
        radius: Rounding.silly
        implicitWidth: 300
        implicitHeight: 120

        StyledRect {
            id: progress
            z: 10
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }
            rightRadius: Rounding.silly
            color: {
                const p = BatteryService.percentage;
                switch (p) {
                case p < 15:
                    return Colors.colError;
                    break;
                case p >= 15:
                    return Colors.colPrimary;
                    break;
                case p >= 85:
                    return Colors.colSuccess;
                    break;
                default:
                    return Colors.colPrimary;
                }
            }
            Anim on width {
                from: 0
                to: BatteryService?.percentage * main.width
                duration: 2500
            }
        }

        StyledText {
            z: 9999
            anchors.left: parent.left
            anchors.leftMargin: Padding.massive
            anchors.verticalCenter: parent.verticalCenter
            text: Math.round(BatteryService.percentage * 100)
            color: {
                const p = BatteryService.percentage;
                switch (p) {
                case p < 15:
                    return Colors.colOnError;
                    break;
                case p >= 15:
                    return Colors.colOnPrimary;
                    break;
                case p >= 85:
                    return Colors.colOnSuccess;
                    break;
                default:
                    return Colors.colOnPrimary;
                }
            }
            font {
                pixelSize: 100
                family: Fonts.family.numbers
                variableAxes: Fonts.variableAxes.longNumbers
            }
        }
        ColumnLayout {
            id: rightColumn
            z: 999
            readonly property color rightColor: BatteryService.percentage > 0.77 ? Colors.colPrimary : Colors.colOnLayer0
            anchors {
                right: parent.right
                rightMargin: Padding.massive * 2
                verticalCenter: parent.verticalCenter
            }

            Symbol {
                visible: BatteryService.isCharging
                fill: 1
                text: "bolt"
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                color: rightColumn.rightColor
                font.pixelSize: Fonts.sizes.title
            }
            // StyledText {
            //     color: Colors.colSubtext
            //     font.pixelSize: Fonts.sizes.small
            //     horizontalAlignment: Text.AlignHCenter
            //     Layout.fillWidth: true
            //     text: BatteryService.energyRate.toFixed(2)
            // }

            StyledText {
                color: rightColumn.rightColor
                font {
                    pixelSize: Fonts.sizes.huge
                    variableAxes: Fonts.variableAxes.main
                }
                function formatTime(seconds) {
                    var h = Math.floor(seconds / 3600);
                    var m = Math.floor((seconds % 3600) / 60);
                    if (h > 0)
                        return `${h}h, ${m}m`;
                    else
                        return `${m}m`;
                }

                text: BatteryService.isCharging ? formatTime(BatteryService.timeToFull) : formatTime(BatteryService.timeToEmpty)
            }
        }
    }
}
