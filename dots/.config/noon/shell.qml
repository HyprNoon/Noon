//@ pragma UseQApplication
//@ pragma RespectSystemStyle
//@ pragma Env __NV_PRIME_RENDER_OFFLOAD=0
//@ pragma Env QT_AUTO_SCREEN_SCALE_FACTOR=1
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QML_XHR_ALLOW_FILE_READ=1
//@ pragma Env QML_XHR_ALLOW_FILE_WRITE=1

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

Scope {
    id: root
    readonly property string mode: Mem.options.desktop.shell.mode
    readonly property bool deload: Mem.states.desktop.shell.deload || (Mem.options.desktop.shell.deloadOnFullscreen && (GlobalStates.topLevel?.fullscreen ?? false))
    readonly property var shellMap: ({
            "main": "main/Main.qml",
            "xp": "xp/XP.qml",
            "zen": "zen/Zen.qml",
            "nobuntu": "nobuntu/NoBuntu.qml"
        })

    Loader {
        active: !deload
        source: Qt.resolvedUrl("modules/" + shellMap[mode])
        onLoaded: GlobalStates.handle_init(root.mode)
    }
    WidgetLoader {
        enabled: !deload
        CommonModules {}
    }

    MCP {}
    GlobalIPC {}
    AppsIPC {}
}
