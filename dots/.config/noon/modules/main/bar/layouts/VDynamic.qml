import QtQuick
import Quickshell
import qs.common
import qs.common.widgets
import "./../components"

StyledPanel {
    id: bar

    property bool hovered: false

    readonly property string pos: Mem.options.bar.behavior.position
    readonly property bool autoHide: Mem.options.bar.behavior.autoHide
    readonly property int mode: Mem.options.bar.appearance.mode
    readonly property bool useBg: Mem.options.bar.appearance.useBg
    readonly property int peekSize: 10

    readonly property int barWidth: Mem.options.bar.appearance.width
    readonly property int hideMargin: autoHide && !hovered ? -(barWidth - peekSize) : 0

    name: "bar"
    shell: "noon"

    implicitWidth: barWidth + 100
    exclusiveZone: autoHide ? (hovered && !useBg ? barWidth : peekSize) : barWidth
    fill: true
    anchors.left: pos === "left"
    anchors.right: pos === "right"

    mask: Region {
        Region {
            item: bg
        }
        Region {
            item: c1
        }
        Region {
            item: c2
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: autoHide
        acceptedButtons: Qt.NoButton
        propagateComposedEvents: true

        onEntered: if (autoHide)
            bar.hovered = true
        onExited: if (autoHide)
            bar.hovered = false

        Item {
            id: container

            opacity: autoHide && !hovered ? 0 : 1
            implicitWidth: barWidth
            implicitHeight: Screen.height

            anchors {
                top: parent.top
                bottom: parent.bottom
                left: pos === "left" ? parent.left : undefined
                right: pos === "right" ? parent.right : undefined
                leftMargin: pos === "left" ? hideMargin : 0
                rightMargin: pos === "right" ? hideMargin : 0
            }

            Behavior on anchors.leftMargin {
                enabled: pos === "left"
                Anim {}
            }
            Behavior on anchors.rightMargin {
                enabled: pos === "right"
                Anim {}
            }

            StyledRectangularShadow {
                target: bg
            }

            DynamicBarBg {
                id: bg
                VContent {
                    barRoot: bar
                }
            }

            RoundCorner {
                id: c1
                visible: bg.showCorners
                anchors.top: bg?.top
                anchors.topMargin: Sizes.frameThickness
                anchors.left: pos === "right" ? undefined : bg?.right
                anchors.right: pos === "right" ? bg?.left : undefined
                corner: pos === "right" ? RoundCorner.TopRight : RoundCorner.TopLeft
            }

            RoundCorner {
                id: c2
                corner: pos === "right" ? RoundCorner.BottomRight : RoundCorner.BottomLeft
                visible: bg.showCorners
                anchors.left: pos === "right" ? undefined : bg?.right
                anchors.right: pos === "right" ? bg?.left : undefined
                anchors.bottom: bg?.bottom
                anchors.bottomMargin: Sizes.frameThickness
            }
        }
    }
}
