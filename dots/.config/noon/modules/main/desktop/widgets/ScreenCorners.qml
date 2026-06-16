import QtQuick
import qs.common
import qs.common.utils
import qs.common.widgets

Variants {
    model: MonitorsInfo.all

    StyledPanel {
        id: root
        required property var modelData
        screen: modelData
        _layer: "Overlay"
        exclusiveZone: -1
        name: "screenCorners"
        fill: true
        mask: Region {}
        Repeater {
            model: ["TopLeft", "TopRight", "BottomLeft", "BottomRight"]
            delegate: RoundCorner {
                required property var modelData
                anchors.top: modelData.includes("Top") ? parent.top : undefined
                anchors.left: modelData.includes("Left") ? parent.left : undefined
                anchors.bottom: modelData.includes("Bottom") ? parent.bottom : undefined
                anchors.right: modelData.includes("Right") ? parent.right : undefined
                size: Mem?.hypr?.rounding ?? Rounding.verylarge
                corner: RoundCorner[modelData]
                color: "#000"
            }
        }
    }
}
