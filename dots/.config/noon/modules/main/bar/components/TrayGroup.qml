import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import Quickshell
import qs.common
import qs.common.widgets
import qs.store

StyledPopup {
    id: root
    required property var panel
    property alias shown: root.active
    contentItem: GridLayout {
        implicitHeight: 80
        implicitWidth: 80
        anchors.centerIn: parent
        columnSpacing: Padding.small
        rowSpacing: Padding.small
        columns: 2
        Repeater {
            model: SystemTray.items

            SysTrayItem {
                required property SystemTrayItem modelData

                item: modelData
                implicitWidth: 34
                implicitHeight: 34
            }
        }
    }
}
