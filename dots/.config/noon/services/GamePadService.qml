pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Noon.Devices
import qs.common
import qs.common.utils

Singleton {
    id: root

    readonly property GamePadTranslator main: GamePadTranslator {
        deviceIndex: 0
    }

    readonly property GamePadTranslator secondary: GamePadTranslator {
        deviceIndex: 1
    }
}
