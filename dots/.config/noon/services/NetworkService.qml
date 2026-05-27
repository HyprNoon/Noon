pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import qs.common
import qs.common.utils
import Noon.Utils.Network

Singleton {
    id: root

    readonly property NmController manager: NmController {
        updateInterval: 4000
    }
}
