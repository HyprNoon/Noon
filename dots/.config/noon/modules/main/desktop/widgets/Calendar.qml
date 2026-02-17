import QtQuick
import QtQuick.Layouts
import qs.services
import qs.common
import qs.common.widgets

IslandComponent {
    ColumnLayout {
        anchors.centerIn: parent
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Padding.normal
            StyledText {
                text: parseInt(DateTimeService.day).toString().replace(/^0+/, '')
                font {
                    pixelSize: 145
                    variableAxes: Fonts.variableAxes.longNumbers
                    family: Fonts.family.numbers
                }
                color: Colors.colSecondary
            }
            ColumnLayout {
                StyledText {
                    text: DateTimeService.year.substring(2)
                    font {
                        pixelSize: 46
                        variableAxes: Fonts.variableAxes.longNumbers
                        family: Fonts.family.numbers
                    }
                    color: Colors.colSecondaryContainer
                }

                StyledText {
                    text: Qt.formatDateTime(DateTimeService.clockVar.date, "MMM")
                    font {
                        pixelSize: 46
                        variableAxes: Fonts.variableAxes.longNumbers
                        family: Fonts.family.numbers
                    }
                    color: Colors.colSecondary
                }
            }
        }
    }
}
