import QtQuick
import Quickshell
import qs.common
import qs.common.widgets

Variants {
    model: MonitorsInfo.main

    StyledPanel {
        required property var modelData
        name: "noanim_layer"
        exclusiveZone: 0
        fill: true
        _layer: "Bottom"
        _margins: Sizes.elevationMargin

        mask: Region {
            item: loader
        }

        Loader {
            id: loader
            z: 999

            readonly property Component verticalVariant: Vertical {}
            readonly property Component normalVariant: Horizontal {}
            readonly property bool isVertical: Mem.options.desktop.clock.verticalMode

            anchors.left: parent.left
            anchors.bottom: parent.bottom

            sourceComponent: isVertical ? verticalVariant : normalVariant
        }
    }
}
