import QtQuick
import qs.common
import qs.common.utils
import qs.common.widgets

Scope {
    id: background

    Variants {
        model: MonitorsInfo.all

        StyledPanel {
            id: backgroundPanel
            required property var modelData
            screen: modelData
            shell: "-"
            name: "bg"
            _layer: "Background"
            color: "transparent"
            exclusiveZone: -1
            fill: true

            BgView {}
        }
    }
}
