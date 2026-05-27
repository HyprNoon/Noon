import QtQuick
import Quickshell

import qs.services
import qs.common
import qs.common.widgets

Scope {
    Variants {
        model: MonitorsInfo.all
        StyledPanel {
            id: root
            required property var modelData
            name: "noanim_blurred_layer"
            _layer: "Overlay"
            exclusiveZone: 0
            fill: true
            screen: modelData
            mask: Region {
                item: listview
            }
            NotificationListView {
                id: listview

                hint: false
                clip: false
                popup: true

                implicitWidth: Sizes.notificationPopupWidth - anchors.margins * 2
                implicitHeight: listview.contentItem.childrenRect.height

                readonly property string _pos: pos.toLowerCase()
                readonly property string pos: Mem.options.desktop.popups?.notifications ?? "TopCenter"
                // readonly property list<string> positions: ["TopLeft", "TopRight", "TopCenter", "BottomLeft", "BottomRight", "BottomCenter"]

                anchors.top: _pos.includes("top") ? parent.top : undefined
                anchors.left: _pos.includes("left") ? parent.left : undefined
                anchors.right: _pos.includes("right") ? parent.right : undefined
                anchors.bottom: _pos.includes("bottom") ? parent.bottom : undefined
                anchors.horizontalCenter: _pos.includes("center") ? parent.horizontalCenter : undefined

                popupProps: ({
                        overshoot: Screen.width,
                        threshold: 20
                    })
                Anim on anchors.margins {
                    from: -height
                    to: Sizes.elevationMargin
                    duration: Animations.durations.normal
                }
            }
        }
    }
}
