import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.store
import qs.common
import qs.common.utils
import qs.common.widgets

Item {
    id: root
    property string currentPath: Globals.applications.editor.currentPath

    anchors {
        fill: parent
        margins: Padding.normal
    }

    StyledListView {
        id: listView
        anchors.fill: parent
        radius: Rounding.verylarge
        clip: true
        model: SettingsData.tweaks
        delegate: StyledDelegateItem {
            expanded: Mem.states.applications.settings.sidebar_expanded
            required property var modelData
            property var index
            property bool isSelected: Mem.states.applications.settings.cat === modelData.section
            shape: MaterialShape.Shape.Cookie4Sided
            title: modelData.section
            toggled: isSelected
            subtext: modelData.shell || ""
            fill: isSelected ? 1 : 0
            materialIcon: modelData.icon || ""
            releaseAction: () => {
                Mem.states.applications.settings.cat = modelData.section;
            }
        }
    }
}
