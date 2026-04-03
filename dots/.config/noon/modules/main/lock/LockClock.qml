import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

ColumnLayout {
    id: root

    anchors {
        top: parent.top
        left: parent.left
        topMargin: Padding.massive
        margins: Padding.massive * 2
    }
    implicitWidth: 400
    implicitHeight: 160

    ColumnLayout {
        id: contentColumn
        spacing: -Padding.massive
        Layout.fillHeight: true
        Layout.fillWidth: true
        StyledText {
            id: clockText

            Layout.alignment: Qt.AlignHCenter
            font.family: Fonts.family.numbers
            font.variableAxes: Fonts.variableAxes.longNumbers
            horizontalAlignment: Text.AlignHCenter
            color: Colors.colOnLayer0
            font.pixelSize: 200
            text: `${DateTimeService.hour}:${DateTimeService.minute}`
        }

        StyledText {
            Layout.alignment: Qt.AlignHCenter
            font.family: Fonts.family.title
            font.variableAxes: Fonts.variableAxes.title
            color: clockText.color
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 25
            opacity: 0.75
            text: DateTimeService.date
        }
    }

    RowLayout {
        Layout.alignment: Qt.AlignHCenter
        Layout.preferredHeight: 50
        spacing: Padding.normal

        BottomInfo {
            text: `${Math.round(BatteryService.percentage * 100, 2)}%`
            icon: "battery_full"
        }

        BottomInfo {
            text: Notifications.list.length
            icon: "notifications"
        }

        BottomInfo {
            visible: AlarmService.alarms.length > 0
            text: AlarmService.alarms.length
            icon: "alarm"
        }

        BottomInfo {
            text: Todo.list.length
            icon: "task_alt"
        }
    }

    component BottomInfo: Row {
        id: root

        property string text
        property string icon

        spacing: Padding.small

        Symbol {
            text: root.icon
            fill: 1
            font.pixelSize: 20
        }

        StyledText {
            font.family: Fonts.family.large
            color: clockText.color
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 18
            opacity: 0.75
            text: root.text
        }
    }
}
