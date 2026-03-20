//@ pragma UseQApplication
//@ pragma RespectSystemStyle
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
import qs.modules.deloaded
import qs.modules.main
import qs.modules.xp
import qs.modules.nobuntu
import qs.modules.applications

Scope {
    id: root
    readonly property Component deloadComponent: DormantSphere {}
    readonly property Component main: Main {}
    readonly property Component xp: XP {}
    readonly property Component nobuntu: NoBuntu {}
    readonly property bool deload: Mem.states.desktop.shell.deload || (Mem.options.desktop.shell.deloadOnFullscreen && (GlobalStates.topLevel.fullscreen ?? false))
    readonly property string mode: Mem.options.desktop.shell.mode
    readonly property var shellMap: {
        "main": main,
        "xp": xp,
        "nobuntu": nobuntu
    }

    Loader {
        sourceComponent: deload ? deloadComponent : shellMap[mode]
        onLoaded: GlobalStates.handle_init(root.mode)
    }

    GlobalIPC {}
    AppsIPC {}
}
