import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Services.UPower
import Quickshell
import qs.services
import qs.common
import qs.common.widgets
import "./../components"

StyledPanel {
    id: root
    name: "bar"
    shell: "noon"
    exclusiveZone: bg.implicitHeight
    fill: true
    _layer: "Top"
    readonly property string pos: Mem.options.bar.behavior.position
    readonly property bool isBottom: bg.side === "bottom"

    anchors.bottom: pos === "bottom"
    anchors.top: pos === "top"

    mask: Region {
        item: bg
    }

    Item {
        id: wrap
        anchors.top: !isBottom ? parent.top : undefined
        anchors.bottom: isBottom ? parent.bottom : undefined
        anchors.right: parent.right
        anchors.left: parent.left

        implicitHeight: bg.implicitHeight

        DynamicBarBg {
            id: bg
            implicitHeight: 25
            color: {
                if (!BatteryService.available)
                    return Colors.colLayer0
                else if (BatteryService.isLow && !BatteryService.isCharging)
                    return Colors.colOnError
                else if (BatteryService.isCritical && !BatteryService.isCharging)
                    return Colors.colError
                else return Colors.colLayer0
            }

            Ws {
                id: ws
                bar:root
                anchors.centerIn: parent
            }

            StyledText {
                anchors.left:parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: Padding.massive
                color: Colors.colOnSurface
                text: ws.showClock ? DateTimeService.time : ""
                animateChange: true
            }
        }

        RoundCorner {
            id: c1
            visible: bg.showCorners
            anchors.left: bg?.left
            anchors.leftMargin: Sizes.frameThickness
            color:bg.color

            anchors.top: !isBottom ? bg?.bottom : undefined
            anchors.bottom: isBottom ? bg?.top : undefined

            corner: isBottom ? RoundCorner.BottomLeft : RoundCorner.TopLeft
        }

        RoundCorner {
            id: c2
            anchors.right: bg?.right
            anchors.rightMargin: Sizes.frameThickness
            color:bg.color
            corner: isBottom ? RoundCorner.BottomRight : RoundCorner.TopRight
            visible: bg.showCorners
            anchors.top: !isBottom ? bg?.bottom : undefined
            anchors.bottom: isBottom ? bg?.top : undefined
            anchors.bottomMargin: Sizes.frameThickness
        }
    }

    component Ws:StyledRect {
        id: root
        required property var bar
        property bool showClock: false
        radius: Rounding.verylarge
        color: _bg_event_area.containsMouse ? Colors.colLayer0Hover : "transparent"
        implicitHeight:parent.height * 0.75
        implicitWidth: rowLayout.implicitWidth + Padding.verylarge

        RowLayout {
            id: rowLayout
            z: 99
            anchors.centerIn: parent
            spacing: Padding.small

            Repeater {
                model: Math.min(Math.max(...Hyprland.workspaces.values.map(ws => ws.id), 2), 10)

                Rectangle {
                    readonly property bool isActive: Hyprland.monitorFor(root.bar.screen).activeWorkspace?.id === (index + 1)
                    readonly property bool isOccupied: Hyprland.workspaces.values.some(ws => ws.id === (index + 1))

                    implicitWidth: isActive ? 40 : 10
                    implicitHeight: 10
                    radius: Rounding.small

                    opacity: isActive ? 1.0 : (isOccupied ? 0.6 : 0.2)
                    color: isActive ? Colors.colPrimary : Colors.colSecondary

                    Behavior on implicitWidth {
                        Anim {}
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: HyprlandService.focusWs(index + 1);
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }
        }

        WheelHandler {
            onWheel: event => HyprlandService.focusWs(`${event.angleDelta.y < 0 ? '+1' : '-1'}`)
        }
        MouseArea {
            id: _bg_event_area
            z: -1
            propagateComposedEvents: true
            anchors.fill: parent
            hoverEnabled: true
            onClicked: showClock = !showClock
        }
    }
}
