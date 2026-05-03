pragma Singleton
import QtQuick
import qs.common
import qs.common.utils
import qs.common.widgets
import Noon.Utils

Singleton {
    id: root
    readonly property alias manager: manager

    ClipboardManager {
        id: manager
        limit: 400
    }
}
