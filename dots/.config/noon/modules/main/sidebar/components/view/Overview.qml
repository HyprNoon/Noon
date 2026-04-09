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
    readonly property var windowByAddress: HyprlandService?.windowByAddress

    readonly property real windowOffset: 0.10
    readonly property real viewScale: 0.185
    readonly property real workspaceSpacing: Padding.small
    readonly property real wsWidthMultiplier: 1
    readonly property bool monitorIsFocused: Hyprland.focusedMonitor?.id === monitor?.id
    readonly property color activeBorderColor: Colors.colSecondary

    property int draggingFromWorkspace: -1
    property int draggingTargetWorkspace: -1

    property int workspaceZ: 0
    property int windowZ: 1
    property int windowDraggingZ: 99999

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
    readonly property int workspaceGroup: Math.floor(((activeWorkspaceId) - 1) / workspacesShown)

    // Use monitorData for active workspace since it's the reliable Hyprland IPC source
    readonly property int activeWorkspaceId: monitorData?.activeWorkspace?.id ?? 1

    function getWorkspaceNumber(row, col) {
        const base = workspaceGroup * workspacesShown;
        return expanded ? base + row * columnsNumber + col + 1 : base + col * rowsNumber + row + 1;
    }

    function getRowIndex(wsId) {
        const local = (wsId - 1) % workspacesShown;
        return expanded ? Math.floor(local / columnsNumber) : local % rowsNumber;
    }

    function getColIndex(wsId) {
        const local = (wsId - 1) % workspacesShown;
        return expanded ? local % columnsNumber : Math.floor(local / rowsNumber);
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
                property int rowIndex: Math.floor(index / root.columnsNumber)
                property int colIndex: index % root.columnsNumber
                property int workspaceValue: root.getWorkspaceNumber(rowIndex, colIndex)
                property bool hoveredWhileDragging: false

                width: root.workspaceImplicitWidth
                height: root.workspaceImplicitHeight
                radius: Rounding.verylarge
                border.width: 2
                border.color: hoveredWhileDragging ? Colors.colLayer2Hover : "transparent"
                color: hoveredWhileDragging ? ColorUtils.mix(ColorUtils.transparentize(Colors.m3.m3secondaryContainer, 0.86), Colors.colLayer1Hover, 0.1) : ColorUtils.transparentize(Colors.m3.m3secondaryContainer, 0.86)

                StyledText {
                    anchors.centerIn: parent
                    text: WorkspaceLabelManager.getDisplayText(workspaceValue)
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
                            Hyprland.dispatch(`workspace ${workspaceValue}`);
                    }
                }

                DropArea {
                    anchors.fill: parent
                    onEntered: {
                        root.draggingTargetWorkspace = workspaceValue;
                        if (root.draggingFromWorkspace !== workspaceValue)
                            hoveredWhileDragging = true;
                    }
                    onExited: {
                        hoveredWhileDragging = false;
                        if (root.draggingTargetWorkspace === workspaceValue)
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
                    const areaA = (wa?.size[0] ?? 0) * (wa?.size[1] ?? 0);
                    const areaB = (wb?.size[0] ?? 0) * (wb?.size[1] ?? 0);
                    return areaB - areaA;
                })
            }

            delegate: OverviewWindow {
                id: window
                required property var modelData
                property string address: `0x${modelData.HyprlandToplevel.address}`
                property int wsCol: windowData?.workspace?.id !== undefined ? root.getColIndex(windowData.workspace.id) : 0
                property int wsRow: windowData?.workspace?.id !== undefined ? root.getRowIndex(windowData.workspace.id) : 0
                property bool atInitPosition: initX === x && initY === y
                windowData: root.windowByAddress[address]
                toplevel: modelData
                monitorData: root.monitorData
                viewScale: root.viewScale
                availableWorkspaceWidth: root.workspaceImplicitWidth
                availableWorkspaceHeight: root.workspaceImplicitHeight
                restrictToWorkspace: Drag.active || atInitPosition
                xOffset: (root.workspaceImplicitWidth + root.workspaceSpacing) * wsCol
                yOffset: (root.workspaceImplicitHeight + root.workspaceSpacing) * wsRow
                z: atInitPosition ? root.windowZ : root.windowDraggingZ

                Drag.hotSpot.x: targetWindowWidth / 2
                Drag.hotSpot.y: targetWindowHeight / 2

                Timer {
                    id: updatePos
                    interval: 50
                    onTriggered: {
                        const wd = window.windowData;
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

                    onEntered: hovered = true
                    onExited: hovered = false

                    onPressed: mouse => {
                        root.draggingFromWorkspace = window.windowData?.workspace.id;
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
                        if (target !== -1 && window.windowData?.workspace?.id !== undefined && target !== window.windowData.workspace.id) {
                            Hyprland.dispatch(`movetoworkspacesilent ${target}, address:${window.windowData.address}`);
                            updatePos.restart();
                        } else {
                            window.x = window.initX;
                            window.y = window.initY;
                        }
                    }

                    onClicked: event => {
                        if (!window.windowData)
                            return;
                        if (event.button === Qt.LeftButton)
                            Hyprland.dispatch(`focuswindow address:${window.windowData.address}`);
                        else if (event.button === Qt.MiddleButton)
                            Hyprland.dispatch(`closewindow address:${window.windowData.address}`);
                        event.accepted = true;
                    }

                    StyledToolTip {
                        extraVisibleCondition: false
                        alternativeVisibleCondition: dragArea.containsMouse && !window.Drag.active
                        content: window.windowData ? `${window.windowData.title ?? ""}\n[${window.windowData.class ?? ""}] ${window.windowData.xwayland ? "[XWayland] " : ""}\n` : ""
                    }
                }
            }
        }

        Rectangle {
            id: focusedWorkspaceIndicator
            property int activeRow: root.getRowIndex(root.activeWorkspaceId)
            property int activeCol: root.getColIndex(root.activeWorkspaceId)

            x: (root.workspaceImplicitWidth + root.workspaceSpacing) * activeCol
            y: (root.workspaceImplicitHeight + root.workspaceSpacing) * activeRow
            z: root.windowZ
            width: root.workspaceImplicitWidth
            height: root.workspaceImplicitHeight
            color: "transparent"
            radius: Rounding.verylarge
            border.width: 2
            border.color: root.activeBorderColor

            Behavior on x {
                Anim {}
            }
            Behavior on y {
                Anim {}
            }
        }
    }
}
