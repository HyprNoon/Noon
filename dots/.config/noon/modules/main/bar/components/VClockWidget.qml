import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.services

BarGroup {
    id: root

    implicitHeight: columnLayout.implicitHeight + (active ? Padding.massive : 0)

    MouseArea {
        id: event_area
        hoverEnabled: true
        anchors.fill: parent
    }

    ColumnLayout {
        id: columnLayout

        anchors.centerIn: parent
        spacing: Padding.tiny

        Repeater {
            model: [DateTimeService.hour, DateTimeService.minute, DateTimeService.request("ddd")]
            StyledText {
                required property var modelData
                required property int index
                text: modelData
                font.variableAxes: Fonts.variableAxes.main
                font.pixelSize: index === 2 ? Fonts.sizes.small : Fonts.sizes.normal
                color: Colors.colSecondary
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }

    PrayerPopup {
        hoverTarget: event_area
    }
}
