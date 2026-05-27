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
    readonly property var focused: monitors.find(s => s.name === Hyprland?.focusedMonitor?.name ?? "") ?? monitors[0] ?? null
    readonly property var focusedScreen: Array.from(focused)
    readonly property var all: monitors
    readonly property var main: monitors.length > 0 ? [monitors[0]] : []
    readonly property var secondary: monitors.length > 1 ? monitors.slice(1) : []
    readonly property var availableResolutions: [...Mem.options.desktop.customResolutions, ...stdResolutions]
    readonly property var stdResolutions: ["1024x768@60", "1280x720@60", "1280x800@60", "1280x1024@60", "1366x768@60", "1440x900@60", "1600x900@60", "1680x1050@60", "1680x1050@75", "1920x1080@60", "1920x1080@75", "1920x1080@144", "1920x1200@60", "2560x1440@60", "2560x1440@144", "2560x1600@60", "3440x1440@60", "3440x1440@100", "3840x2160@60", "3840x2160@120"]
    function monitorFor(panel) {
        return Hyprland.monitorFor(panel);
    }
}
