pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.common
import qs.common.utils
import Noon.Hypr

Singleton {
    id: root

    readonly property ScreenTimeManager tracker: ScreenTimeManager {
        bridge: HyprlandService?.bridge ?? null
        dbPath: Directories.services.screenTimeDB
        saveInterval: 12000
    }

    readonly property var appTimes: tracker.appTimes
}
