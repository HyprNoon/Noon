pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.common
import qs.common.utils
import Noon.Hypr

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
    readonly property list<string> availableAnimations: root.availableAnimationsModel.getArray("fileBaseName")

    readonly property FolderListModel availableAnimationsModel: FolderListModel {
        folder: Directories.standard.config + "/hypr/lua/animations/"
        nameFilters: ["*.lua"]
    }

    onKeyboardLayoutShortNameChanged: NoonUtils.toast({
        id: 7,
        content: "Keyboard layout changed to " + root.keyboardLayoutShortName,
        icon: "keyboard_command_key"
    })
    Component.onCompleted: bindVars()
    function switchKeyboardLayout() {
        NoonUtils.execDetached(["hyprctl", "switchxkblayout", "current", "next"]);
    }
    function focusWs(ws) {
        Hyprland.dispatch(`hl.dsp.focus({ workspace = ${ws} })`);
    }
    function bindVars() {
        const mappings = {
            "apps.fileManager": "file_manager",
            "apps.terminal": "terminal",
            "apps.browser": "browser",
            "apps.borwser": "browser_alt",
            "apps.terminal_alt": "browser",
            "apps.editor": "editor"
        };

        for (const [cfgPath, qmlProp] of Object.entries(mappings)) {
            Mem.hypr[cfgPath] = qmlProp;
        }
    }
}
