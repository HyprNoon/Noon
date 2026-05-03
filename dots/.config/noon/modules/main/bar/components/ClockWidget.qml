import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.services
import qs.store

BarGroup {
    id: root
    vertical: false
    Layout.preferredWidth: 220

    StyledText {
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: Fonts.sizes.large
        color: Colors.colOnLayer1
        text: DateTimeService.gnome_format
    }

    MouseArea {
        id: event_area
        anchors.fill: parent
        hoverEnabled: true
    }

    ClockPopup {
        hoverTarget: event_area
    }
}
