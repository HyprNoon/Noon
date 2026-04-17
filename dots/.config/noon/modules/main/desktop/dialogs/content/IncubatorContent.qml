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
    readonly property string category: Mem.states.desktop.dialogs.lastIncubatedCategory

    ContentChild {
        anchors.fill: parent
        category: root.category
        anchors.margins: ["View", "Beats", "Notes"].includes(category) ? 0 : Padding.massive
        _detached: true
        _expanded: true
        parentRoot: root
        colors: SidebarData.getColors(category)
    }

    StyledLoader {
        anchors.fill: parent
        shown: !category
        sourceComponent: PagePlaceholder {
            anchors.centerIn: parent
            iconSize: 150
            shape: MaterialShape.Shape.PixelCircle
            icon: "question_mark"
            title: "Nothig here !"
            description: "Incubated Content Will Show here"
        }
    }
}
