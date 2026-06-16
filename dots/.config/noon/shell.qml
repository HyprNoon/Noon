//@ pragma UseQApplication
//@ pragma RespectSystemStyle

//@ pragma Env QT_AUTO_SCREEN_SCALE_FACTOR=1
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic
//@ pragma Env __NV_PRIME_RENDER_OFFLOAD=0

//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QS_DISABLE_CRASH_HANDLER=1
//@ pragma Env QT_QPA_PLATFORMTHEME=kde

import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.common
import qs.common.utils

import "modules/xp"
import "modules/zen"
import "modules/main"
import "modules/nobuntu"
import "modules/applications"
import "modules/common"

ShellRoot {
    id: root
    readonly property string mode: Mem.options.desktop.shell.mode
    readonly property bool deload: Mem.states.desktop.shell.deload || (Mem.options.desktop.shell.deloadOnFullscreen && (Globals.topLevel?.fullscreen ?? false))
    readonly property var shellMap: {
        "main": "main/Main.qml",
        "xp": "xp/XP.qml",
        "zen": "zen/Zen.qml",
        "nobuntu": "nobuntu/NoBuntu.qml"
    }

    Loader {
        active: !deload
        asynchronous: false
        source: Qt.resolvedUrl("modules/" + shellMap[(mode ?? "main")])
        onLoaded: Globals.handle_init(root.mode)
    }

    WidgetLoader {
        enabled: !deload
        CommonModules {}
    }

    MCP {}
    GlobalIPC {}
    // AppsIPC {}
}
