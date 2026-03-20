import QtQuick
import Quickshell
import qs.common

LazyLoader {
    property bool enabled: true
    property var reloadOn
    onReloadOnChanged: if (enabled)
        reload()

    function reload() {
        active = false;
        active = true;
    }

    function debouncedReload(delay = 100) {
        debounceTimer.interval = delay;
        debounceTimer.restart();
    }

    Timer {
        id: debounceTimer
        onTriggered: reload()
    }

    active: enabled && Mem.ready
    component: children[0]
}
