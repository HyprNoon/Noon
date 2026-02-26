pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.common.widgets

Singleton {
    id: root
    readonly property var monitors: Quickshell.screens
    readonly property Toplevel topLevel: ToplevelManager?.activeToplevel ?? null
    readonly property var focused: monitors?.find(monitor => monitor.name === Hyprland?.focusedMonitor?.name)
    readonly property var all: monitors
    readonly property var main: [monitors[0]]
    readonly property var secondary: monitors.length > 1 ? [monitors.slice(1)] : []
    readonly property alias dummyPanel: dummy

    function monitorFor(panel) {
        return Hyprland.monitorFor(panel);
    }
    DummyPanel {
        id: dummy
    }
}
