pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.common
import qs.common.utils
import Noon.Utils.Hypr

Singleton {
    id: root

    readonly property HyprBridge bridge: HyprBridge {}
    readonly property bool isHyprland: Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE") !== ""
    readonly property list<var> monitors: bridge.monitors
    readonly property list<var> windowList: bridge.windowList
    readonly property list<var> workspaces: bridge.workspaces
    readonly property var windowByAddress: bridge.windowByAddress
    readonly property var workspaceById: bridge.workspaceById
    readonly property var activeWorkspace: bridge.activeWorkspace
    readonly property string currentKeyboardLayout: bridge?.currentKeyboardLayout
    readonly property string keyboardLayoutShortName: currentKeyboardLayout.substring(0, 2).toUpperCase()

    onKeyboardLayoutShortNameChanged: NoonUtils.toast({
        id: 7,
        content: "Keyboard layout changed to " + root.keyboardLayoutShortName,
        icon: "keyboard_command_key"
    })

    function switchKeyboardLayout() {
        NoonUtils.execDetached(["hyprctl", "switchxkblayout", "current", "next"]);
    }
}
