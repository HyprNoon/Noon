import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import qs.common
import qs.common.widgets
import "./../common"

StyledPanel {
    id: root
    name: "notifs"
    shell: "nobuntu"
    visible: Globals.nobuntu.notifs.show
    anchors {
        top: true
        right: true
        left: true
        bottom: true
    }
    mask: Region {
        item: bg
    }
    FocusHandler {
        windows: [root]
        active: root.visible
        onCleared: Globals.nobuntu.notifs.show = false
    }
    StyledRect {
        id: bg
        anchors {
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: -30
            top: parent.top
            topMargin: Padding.large
        }
        implicitHeight: 620
        implicitWidth: 750
        radius: 40
        enableBorders: true
        color: Colors.colLayer2
        RowLayout {
            anchors.fill: parent
            anchors.margins: Padding.massive
            spacing: Padding.large

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                GNotifList {}
                GNotifsMedia {}
            }
            VerticalSeparator {}

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.maximumWidth: bg.implicitWidth / 2.25
                GCalendarHeader {}
                GCalendar {}
                GNotifEvents {}
            }
        }
    }
}
