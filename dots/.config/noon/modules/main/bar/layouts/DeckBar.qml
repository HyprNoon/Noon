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
    readonly property bool useBg: Mem.options.bar.appearance.useBg
    readonly property int peekSize: 10
    readonly property bool isBottom: pos === "bottom"
    readonly property int barHeight: Mem.options.bar.appearance.size
    readonly property int elevation: mode === 0 ? Sizes.barElevation : 0
    readonly property int hideMargin: autoHide && !hovered ? -(barHeight - peekSize) : 0

    name: "bar"
    shell: "noon"

    implicitHeight: barHeight + 100
    exclusiveZone: autoHide ? (hovered && !useBg ? barHeight : peekSize) : barHeight

    fill: true
    anchors.top: !isBottom
    anchors.bottom: isBottom

    mask: Region {
        item: bg
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
            implicitHeight: barHeight
            implicitWidth: Screen.width

            anchors {
                left: parent.left
                right: parent.right
                top: !isBottom ? parent.top : undefined
                bottom: isBottom ? parent.bottom : undefined
                topMargin: !isBottom ? hideMargin : 0
                bottomMargin: isBottom ? hideMargin : 0
            }

            Behavior on anchors.topMargin {
                enabled: !isBottom
                Anim {}
            }
            Behavior on anchors.bottomMargin {
                enabled: isBottom
                Anim {}
            }

            StyledRectangularShadow {
                target: bg
            }
            DynamicBarBg {
                id: bg
                DeckBarContent {
                    panel: bar
                }
            }

            RoundCorner {
                id: c1
                visible: bg.showCorners
                anchors.left: bg?.left
                anchors.leftMargin: Sizes.frameThickness

                anchors.top: !isBottom ? bg?.bottom : undefined
                anchors.bottom: isBottom ? bg?.top : undefined

                corner: isBottom ? RoundCorner.BottomLeft : RoundCorner.TopLeft
            }

            RoundCorner {
                id: c2
                anchors.right: bg?.right
                anchors.rightMargin: Sizes.frameThickness

                corner: isBottom ? RoundCorner.BottomRight : RoundCorner.TopRight
                visible: bg.showCorners
                anchors.top: !isBottom ? bg?.bottom : undefined
                anchors.bottom: isBottom ? bg?.top : undefined
                anchors.bottomMargin: Sizes.frameThickness
            }
        }
    }
}
