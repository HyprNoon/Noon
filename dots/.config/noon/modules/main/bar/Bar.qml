import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import qs.store
import qs.common
import qs.common.widgets
import qs.common.utils

import "components"
import "layouts/horizontal"
import "layouts/vertical"

Scope {
    readonly property var settings: Mem.options.bar
    Variants {
        model: settings.behavior.showOnAll ? MonitorsInfo.all : MonitorsInfo.main
        StyledLoader {
            id: loader
            required property var modelData
            readonly property string mode: settings.layout
            readonly property bool vertical: mode.startsWith("V")
            readonly property string path: vertical ? "layouts/vertical/" : "layouts/horizontal/"
            shown: Mem.options.bar.enabled
            source: `${path}${mode}.qml`
            onLoaded: _item.screen = loader.modelData
        }
    }
}
