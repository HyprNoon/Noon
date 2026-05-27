import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.services

StyledPopup {
    id: root

    contentItem: ColumnLayout {
        id: columnLayout
        anchors.centerIn: parent
        spacing: Padding.normal

        StyledText {
            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
            text: DateTimeService.request("hh:mm:ss ap").split(" ")[0]
            color: Colors.m3.m3primary
            font.pixelSize: 76
            font.family: Fonts.family.variable
            font.variableAxes: Fonts.variableAxes.longNumbers
        }

        // AM/PM (12hr format only)
        StyledText {
            Layout.alignment: Qt.AlignHCenter
            text: DateTimeService.twelveHour ? DateTimeService.dayTime : ""
            color: Colors.m3.m3onSurfaceVariant
            font.pixelSize: Fonts.sizes.verylarge
            font.weight: Font.Medium
            font.letterSpacing: 6
            visible: DateTimeService.twelveHour
            Layout.topMargin: -4
            opacity: 0.6
        }

        Separator {
            Layout.margins: Padding.massive
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: Padding.huge
            spacing: Padding.large
            StyledText {
                Layout.alignment: Qt.AlignHCenter
                text: Qt.formatDateTime(DateTimeService.clock.date, "dddd, MMMM d")
                color: Colors.m3.m3onSurface
                font.pixelSize: Fonts.sizes.verylarge
                font.family: Fonts.family.variable
                font.variableAxes: Fonts.variableAxes.title
            }

            StyledText {
                Layout.alignment: Qt.AlignHCenter
                text: DateTimeService.year
                color: Colors.m3.m3onSurfaceVariant
                font.pixelSize: Fonts.sizes.small
                font.weight: Font.Light
                Layout.topMargin: -2
                opacity: 0.5
            }

            StyledText {
                Layout.alignment: Qt.AlignHCenter
                text: "\u2191 " + DateTimeService.uptime
                color: Colors.m3.m3onSurfaceVariant
                font.pixelSize: Fonts.sizes.verysmall
                font.weight: Font.Light
                opacity: 0.35
            }
        }
    }
}
