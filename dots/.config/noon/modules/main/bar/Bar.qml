import QtQuick
import qs.store
import qs.common
import qs.common.widgets
import qs.common.utils

import "layouts"
import "components"

Scope {
    readonly property var settings: Mem.options.bar
    property string position: settings.behavior.position
    Variants {
        model: settings.behavior.showOnAll ? MonitorsInfo.all : MonitorsInfo.main
        StyledLoader {
            id: loader
            required property var modelData
            shown: Mem.options.bar.enabled
            source: {
                const isVertical = BarData.isVertical;
                const layout = isVertical ? settings.verticalLayout : settings.horizontalLayout;
                return `layouts/${layout}.qml`;
            }
            onLoaded: _item.screen = loader.modelData
        }
    }
}
