import qs.store
import qs.services
import qs.common
import qs.common.widgets
import qs.common.functions
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell.Wayland

Item {
    id: root

    property bool expanded: false

    readonly property var monitor: MonitorsInfo.focused
    readonly property var monitorData: HyprlandService.monitors.find(m => m.name === monitor?.name) ?? null
    readonly property var windowByAddress: HyprlandService.windowByAddress
    readonly property int activeWorkspaceId: HyprlandService.activeWorkspace?.id ?? 1

    readonly property real viewScale: 0.185
    readonly property real workspaceSpacing: Padding.small

    readonly property real workspaceImplicitWidth: {
        if (!monitorData || !monitor)
            return width / 2;
        const rotated = monitorData.transform % 2 === 1;
        return (rotated ? monitorData.height : monitorData.width) * viewScale;
    }
    readonly property real workspaceImplicitHeight: workspaceImplicitWidth * 9 / 16

    readonly property int rowsNumber: Math.max(Math.floor(height / workspaceImplicitHeight), 1)
    readonly property int columnsNumber: Math.max(Math.floor(width / workspaceImplicitWidth), 1)
    readonly property int workspacesShown: rowsNumber * columnsNumber
    readonly property int workspaceGroup: Math.floor((activeWorkspaceId - 1) / workspacesShown)

    property int draggingFromWorkspace: -1
    property int draggingTargetWorkspace: -1

    property int workspaceZ: 0
    property int windowZ: 1
    property int windowDraggingZ: 99999

    function workspaceNumber(row, col) {
        const base = workspaceGroup * workspacesShown;
        return expanded ? base + row * columnsNumber + col + 1 : base + col * rowsNumber + row + 1;
    }

    function rowIndex(wsId) {
        const local = (wsId - 1) % workspacesShown;
        return expanded ? Math.floor(local / columnsNumber) : local % rowsNumber;
    }

    function colIndex(wsId) {
        const local = (wsId - 1) % workspacesShown;
        return expanded ? local % columnsNumber : Math.floor(local / rowsNumber);
    }

    function dispatch(lua) {
        Hyprland.dispatch(lua);
    }

    GridLayout {
        id: workspaceGrid
        anchors.centerIn: parent
        z: root.workspaceZ
        rowSpacing: root.workspaceSpacing
        columnSpacing: root.workspaceSpacing
        columns: root.columnsNumber
        rows: root.rowsNumber

        Repeater {
            model: root.workspacesShown

            delegate: Rectangle {
                required property int index

                readonly property int rowIdx: Math.floor(index / root.columnsNumber)
                readonly property int colIdx: index % root.columnsNumber
                readonly property int wsValue: root.workspaceNumber(rowIdx, colIdx)
                property bool hoveredWhileDragging: false

                width: root.workspaceImplicitWidth
                height: root.workspaceImplicitHeight
                radius: Rounding.verylarge

                color: hoveredWhileDragging ? ColorUtils.mix(ColorUtils.transparentize(Colors.m3.m3secondaryContainer, 0.86), Colors.colLayer1Hover, 0.1) : ColorUtils.transparentize(Colors.m3.m3secondaryContainer, 0.86)

                border.width: 2
                border.color: hoveredWhileDragging ? Colors.colLayer2Hover : "transparent"

                StyledText {
                    anchors.centerIn: parent
                    text: WorkspaceLabelManager.getDisplayText(parent.wsValue)
                    font.family: WorkspaceLabelManager.useJapanese ? "Noto Sans CJK JP" : "Rubik"
                    font.weight: WorkspaceLabelManager.useJapanese ? Font.Light : Font.DemiBold
                    font.pixelSize: 40
                    color: ColorUtils.transparentize(Colors.colOnLayer1, 0.8)
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton
                    onClicked: {
                        if (root.draggingTargetWorkspace === -1)
                            root.dispatch(`hl.dsp.focus({ workspace = ${parent.wsValue} })`);
                    }
                }

                DropArea {
                    anchors.fill: parent
                    onEntered: {
                        root.draggingTargetWorkspace = parent.wsValue;
                        if (root.draggingFromWorkspace !== parent.wsValue)
                            parent.hoveredWhileDragging = true;
                    }
                    onExited: {
                        parent.hoveredWhileDragging = false;
                        if (root.draggingTargetWorkspace === parent.wsValue)
                            root.draggingTargetWorkspace = -1;
                    }
                }
            }
        }
    }

    Item {
        id: windowSpace
        anchors.fill: workspaceGrid
        clip: true

        Repeater {
            model: ScriptModel {
                values: ToplevelManager?.toplevels.values.filter(t => {
                    const win = root.windowByAddress[`0x${t.HyprlandToplevel.address}`];
                    const id = win?.workspace?.id;
                    return id > 0 && id > root.workspaceGroup * root.workspacesShown && id <= (root.workspaceGroup + 1) * root.workspacesShown;
                }).sort((a, b) => {
                    const wa = root.windowByAddress[`0x${a.HyprlandToplevel.address}`];
                    const wb = root.windowByAddress[`0x${b.HyprlandToplevel.address}`];
                    return ((wb?.size[0] ?? 0) * (wb?.size[1] ?? 0)) - ((wa?.size[0] ?? 0) * (wa?.size[1] ?? 0));
                })
            }

            delegate: OverviewWindow {
                id: window
                required property var modelData

                readonly property string address: `0x${modelData.HyprlandToplevel.address}`
                readonly property var winData: root.windowByAddress[address]
                readonly property int wsId: winData?.workspace?.id ?? -1
                readonly property bool atInitPos: initX === x && initY === y

                windowData: winData
                toplevel: modelData
                monitorData: root.monitorData
                viewScale: root.viewScale
                availableWorkspaceWidth: root.workspaceImplicitWidth
                availableWorkspaceHeight: root.workspaceImplicitHeight
                restrictToWorkspace: Drag.active || atInitPos
                xOffset: (root.workspaceImplicitWidth + root.workspaceSpacing) * root.colIndex(wsId)
                yOffset: (root.workspaceImplicitHeight + root.workspaceSpacing) * root.rowIndex(wsId)
                z: atInitPos ? root.windowZ : root.windowDraggingZ

                Drag.hotSpot.x: targetWindowWidth / 2
                Drag.hotSpot.y: targetWindowHeight / 2

                Timer {
                    id: updatePos
                    interval: 50
                    onTriggered: {
                        const wd = window.winData;
                        const md = window.monitorData;
                        if (wd?.at?.length >= 2 && md?.reserved?.length >= 4) {
                            window.x = Math.round(Math.max((wd.at[0] - (md.x ?? 0) - md.reserved[3]) * root.viewScale, 0) + window.xOffset);
                            window.y = Math.round(Math.max((wd.at[1] - (md.y ?? 0) - md.reserved[0]) * root.viewScale, 0) + window.yOffset);
                        }
                    }
                }

                MouseArea {
                    id: dragArea
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                    drag.target: parent

                    onEntered: window.hovered = true
                    onExited: window.hovered = false

                    onPressed: mouse => {
                        root.draggingFromWorkspace = window.wsId;
                        window.pressed = true;
                        window.Drag.active = true;
                        window.Drag.source = window;
                        window.Drag.hotSpot.x = mouse.x;
                        window.Drag.hotSpot.y = mouse.y;
                    }

                    onReleased: {
                        const target = root.draggingTargetWorkspace;
                        window.pressed = false;
                        window.Drag.active = false;
                        root.draggingFromWorkspace = -1;

                        if (target !== -1 && window.wsId !== -1 && target !== window.wsId) {
                            root.dispatch(`hl.dsp.window.move({ workspace = ${target}, window = "address:${window.address}", silent = true })`);
                            updatePos.restart();
                        } else {
                            window.x = window.initX;
                            window.y = window.initY;
                        }
                    }

                    onClicked: event => {
                        if (!window.winData)
                            return;
                        if (event.button === Qt.LeftButton)
                            root.dispatch(`hl.dsp.exec_raw("focuswindow address:${window.address}")`);
                        else if (event.button === Qt.MiddleButton)
                            root.dispatch(`hl.dsp.window.close({ window = "address:${window.address}" })`);
                        event.accepted = true;
                    }

                    StyledToolTip {
                        extraVisibleCondition: false
                        alternativeVisibleCondition: dragArea.containsMouse && !window.Drag.active
                        content: window.winData ? `${window.winData.title ?? ""}\n[${window.winData.class ?? ""}]${window.winData.xwayland ? " [XWayland]" : ""}\n` : ""
                    }
                }
            }
        }

        Rectangle {
            id: focusedWorkspaceIndicator

            x: (root.workspaceImplicitWidth + root.workspaceSpacing) * root.colIndex(root.activeWorkspaceId)
            y: (root.workspaceImplicitHeight + root.workspaceSpacing) * root.rowIndex(root.activeWorkspaceId)
            z: root.windowZ

            width: root.workspaceImplicitWidth
            height: root.workspaceImplicitHeight
            radius: Rounding.verylarge
            color: "transparent"
            border.width: 2
            border.color: Colors.colSecondary

            Behavior on x {
                Anim {}
            }
            Behavior on y {
                Anim {}
            }
        }
    }
}
