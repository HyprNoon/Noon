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
    exclusiveZone: bg.implicitWidth
    fill: true
    _layer: "Top"
    readonly property string pos: Mem.options.bar.behavior.position
    readonly property bool isRight: bg.side === "right"

    anchors.left: !isRight
    anchors.right: isRight

    mask: Region {
        item: bg
    }

    Item {
        id: wrap
        anchors.left: !isRight ? parent.left : undefined
        anchors.right: isRight ? parent.right : undefined
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        implicitWidth: bg.implicitWidth

        DynamicBarBg {
            id: bg
            implicitWidth: 25
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
                anchors.verticalCenterOffset: -Padding.massive * 2
            }

            StyledText {
                anchors.top:parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: Padding.massive * 1.5
                color: Colors.colOnSurface
                text: ws.showClock ? DateTimeService.time : ""
                animateChange: true
                rotation: -90
            }
        }

        RoundCorner {
            id: c1
            visible: bg.showCorners
            anchors.top: bg?.top
            anchors.topMargin: Sizes.frameThickness
            color:bg.color

            anchors.left: !isRight ? bg?.right : undefined
            anchors.right: isRight ? bg?.left : undefined

            corner: isRight ? RoundCorner.TopRight : RoundCorner.TopLeft
        }

        RoundCorner {
            id: c2
            anchors.bottom: bg?.bottom
            anchors.bottomMargin: Sizes.frameThickness
            color:bg.color

            corner: isRight ? RoundCorner.BottomRight : RoundCorner.BottomLeft
            visible: bg.showCorners
            anchors.left: !isRight ? bg?.right : undefined
            anchors.right: isRight ? bg?.left : undefined
        }
    }

    component Ws:StyledRect {
        id: root
        required property var bar
        property bool showClock: false
        radius: Rounding.verylarge
        color: _bg_event_area.containsMouse ? Colors.colLayer0Hover : "transparent"
        implicitWidth: parent.width * 0.75
        implicitHeight: columnLayout.implicitHeight + Padding.verylarge

        ColumnLayout {
            id: columnLayout
            z: 99
            anchors.centerIn: parent
            spacing: Padding.small

            Repeater {
                model: Math.min(Math.max(...Hyprland.workspaces.values.map(ws => ws.id), 2), 10)

                Rectangle {
                    readonly property bool isActive: Hyprland.monitorFor(root.bar.screen).activeWorkspace?.id === (index + 1)
                    readonly property bool isOccupied: Hyprland.workspaces.values.some(ws => ws.id === (index + 1))

                    implicitHeight: isActive ? 40 : 10
                    implicitWidth: 10
                    radius: Rounding.small

                    opacity: isActive ? 1.0 : (isOccupied ? 0.6 : 0.2)
                    color: isActive ? Colors.colPrimary : Colors.colSecondary

                    Behavior on implicitHeight {
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
            onWheel: event =>  HyprlandService.focusWs(`${event.angleDelta.y < 0 ? '+1' : '-1'}`)
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
