import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.common
import qs.common.widgets
import qs.common.functions
import qs.store
import qs.services
import qs.modules.main.sidebar

Item {
    id: root
    clip: true
    anchors.fill: parent
    signal dismiss
    property string category
    ContentChild {
        anchors.fill: parent
        _detached: true
        category: root.category
        anchors.margins: ["Beats", "Notes"].includes(category) ? 0 : Padding.massive
        parentRoot: root
        colors: SidebarData.getColors(category)
    }
}
