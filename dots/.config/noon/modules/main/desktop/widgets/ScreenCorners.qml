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
            model: [
                {
                    top: true,
                    left: true,
                    corner: RoundCorner.TopLeft
                },
                {
                    top: true,
                    right: true,
                    corner: RoundCorner.TopRight
                },
                {
                    bottom: true,
                    left: true,
                    corner: RoundCorner.BottomLeft
                },
                {
                    bottom: true,
                    right: true,
                    corner: RoundCorner.BottomRight
                }
            ]
            delegate: RoundCorner {
                required property var modelData
                anchors {
                    top: modelData.top ? parent.top : undefined
                    left: modelData.left ? parent.left : undefined
                    bottom: modelData.bottom ? parent.bottom : undefined
                    right: modelData.right ? parent.right : undefined
                }
                size: Rounding.verylarge
                corner: modelData.corner
                color: "black"
            }
        }
    }
}
