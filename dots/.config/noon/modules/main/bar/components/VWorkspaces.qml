import qs.store
import qs.services
import qs.common
import qs.common.widgets
import qs.common.functions

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects

BarGroup {
    id: root
    property var bar

    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(bar?.screen)
    readonly property Toplevel activeWindow: ToplevelManager.activeToplevel
    readonly property int workspaceGroup: Math.floor((monitor?.activeWorkspace?.id - 1) / shownWs)
    readonly property int workspaceIndexInGroup: (monitor.activeWorkspace?.id - 1) % shownWs

    // Workspace configuration
    property int shownWs: Mem.options.bar.workspaces.shownWs
    property list<bool> workspaceOccupied: []

    // Visual properties - centralized
    readonly property int workspaceButtonHeight: 26
    readonly property real baseIconSize: workspaceButtonHeight * 0.65
    readonly property real shrinkedIconSize: workspaceButtonHeight * 0.5
    readonly property real shrinkedIconMargin: -6
    readonly property int buttonMargin: 2
    readonly property real previewScale: 0.2
    readonly property size previewMaxSize: Qt.size((bar.screen?.width ?? 1920) * previewScale, (bar.screen?.height ?? 1080) * previewScale)
    readonly property real previewIconScale: 0.15
    vertical: true
    Layout.preferredHeight: columnLayout.implicitHeight
    color: Colors.colLayer1
    function updateWorkspaceOccupied() {
        workspaceOccupied = Array.from({
            length: shownWs
        }, (_, i) => Hyprland.workspaces.values.some(ws => ws.id === workspaceGroup * shownWs + i + 1));
    }

    function findToplevelForWindow(hyprlandWindow) {
        if (!hyprlandWindow?.address)
            return null;

        return ToplevelManager.toplevels.values.find(toplevel => {
            if (!toplevel.HyprlandToplevel)
                return false;
            return `0x${toplevel.HyprlandToplevel.address}` === hyprlandWindow.address;
        }) ?? null;
    }

    Component.onCompleted: updateWorkspaceOccupied()

    Connections {
        target: Hyprland.workspaces
        function onValuesChanged() {
            updateWorkspaceOccupied();
        }
    }

    WheelHandler {
        onWheel: event => HyprlandService.focusWs(`r${event.angleDelta.y < 0 ? '+' : '-'}1`)
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.BackButton
        onPressed: event => {
            if (event.button === Qt.BackButton) {
                HyprlandService.focusWs("special");
            }
        }
    }

    // Background workspace indicators
    ColumnLayout {
        id: columnLayout
        z: 1
        spacing: 0
        anchors.centerIn: parent

        Repeater {
            model: shownWs

            StyledRect {
                readonly property int workspaceId: workspaceGroup * shownWs + index + 1
                readonly property bool isOccupied: HyprlandService.windowList.some(w => w.workspace?.id === workspaceId)

                readonly property bool adjacentOccupiedAbove: {
                    if (index === 0)
                        return false;
                    const aboveWorkspaceId = workspaceGroup * shownWs + (index - 1) + 1;
                    return HyprlandService.windowList.some(w => w.workspace?.id === aboveWorkspaceId);
                }

                readonly property bool adjacentOccupiedBelow: {
                    if (index === shownWs - 1)
                        return false;
                    const belowWorkspaceId = workspaceGroup * shownWs + (index + 1) + 1;
                    return HyprlandService.windowList.some(w => w.workspace?.id === belowWorkspaceId);
                }

                z: 1
                Layout.alignment: Qt.AlignHCenter
                implicitHeight: workspaceButtonHeight
                implicitWidth: 34 * 0.8
                color: Colors.colLayer3Hover
                opacity: isOccupied ? 1 : 0
                topRadius: adjacentOccupiedAbove ? 0 : Rounding.full
                bottomRadius: adjacentOccupiedBelow ? 0 : Rounding.full
            }
        }
    }

    Rectangle {
        readonly property real computedHeight: Math.abs(idx1 - idx2) * workspaceButtonHeight + workspaceButtonHeight - margin * 2
        readonly property real computedY: Math.min(idx1, idx2) * workspaceButtonHeight + margin

        z: 2
        property real margin: buttonMargin
        property real idx1: workspaceIndexInGroup
        property real idx2: workspaceIndexInGroup

        implicitWidth: workspaceButtonHeight - margin * 2
        implicitHeight: computedHeight
        anchors.horizontalCenter: parent.horizontalCenter
        y: computedY
        radius: Rounding.full
        color: Colors.colPrimary

        Behavior on margin {
            Anim {}
        }
        Behavior on idx1 {
            Anim {
                duration: Animations.durations.small
            }
        }
        Behavior on idx2 {
            Anim {
                duration: Animations.durations.large
            }
        }
    }

    // Workspace buttons with icons and popups
    ColumnLayout {
        z: 3
        spacing: 0
        anchors.fill: parent

        Repeater {
            model: root.shownWs

            Button {
                id: button
                readonly property int workspaceValue: root.workspaceGroup * root.shownWs + index + 1
                readonly property string displayText: WorkspaceLabelManager.getDisplayText(workspaceValue)
                readonly property string currentMode: WorkspaceLabelManager.currentMode
                readonly property bool isActive: monitor.activeWorkspace?.id === workspaceValue

                readonly property var biggestWindow: {
                    const windows = HyprlandService.windowList.filter(w => w.workspace?.id === workspaceValue);
                    return windows.reduce((maxWin, win) => {
                        const maxArea = (maxWin?.size?.[0] ?? 0) * (maxWin?.size?.[1] ?? 0);
                        const winArea = (win?.size?.[0] ?? 0) * (win?.size?.[1] ?? 0);
                        return winArea > maxArea ? win : maxWin;
                    }, null);
                }

                readonly property var windowToplevel: root.findToplevelForWindow(biggestWindow)
                readonly property string appIconSource: biggestWindow?.class ? NoonUtils.iconPath(DesktopEntries?.byId(biggestWindow?.class)?.icon) : ""
                readonly property bool showNumber: Mem.options.bar.workspaces.alwaysShowNumbers || Globals.superHeld || !biggestWindow
                readonly property int positionMultiplier: Mem.options.bar.behavior.position === "left" ? -1 : 1

                Layout.fillWidth: true
                height: workspaceButtonHeight
                onPressed: HyprlandService.focusWs(workspaceValue)

                background: Item {
                    implicitHeight: workspaceButtonHeight

                    Symbol {
                        readonly property color textColor: button.isActive ? Colors.colOnPrimary : (root.workspaceOccupied[index] ? Colors.colOnSecondaryContainer : Colors.colOnLayer1Inactive)

                        fill: 1
                        opacity: button.showNumber ? 0.8 : 0
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: button.currentMode === "custom" ? -2 : 0
                        font.family: WorkspaceLabelManager.getFontFamily(button.currentMode)
                        font.weight: WorkspaceLabelManager.getFontWeight(button.currentMode)
                        font.pixelSize: WorkspaceLabelManager.getFontPixelSize(button.currentMode, button.displayText)
                        text: button.displayText
                        color: textColor
                        horizontalAlignment: Qt.AlignCenter

                        Behavior on opacity {
                            Anim {}
                        }
                    }

                    StyledIconImage {
                        id: mainAppIcon

                        readonly property real offsetMultiplier: button.showNumber ? 2 * root.shrinkedIconMargin : 0

                        anchors {
                            centerIn: parent
                            verticalCenterOffset: button.showNumber ? -offsetMultiplier : 0
                            horizontalCenterOffset: button.showNumber ? offsetMultiplier * button.positionMultiplier : 0
                        }
                        asynchronous: true
                        source: button.appIconSource
                        implicitSize: button.showNumber ? root.shrinkedIconSize : root.baseIconSize
                        tint: 0.4
                        opacity: button.biggestWindow ? (button.showNumber ? 1 : 1) : 0
                        visible: opacity > 0

                        Behavior on opacity {
                            Anim {}
                        }
                        Behavior on anchors.verticalCenterOffset {
                            Anim {}
                        }
                        Behavior on anchors.horizontalCenterOffset {
                            Anim {}
                        }
                        Behavior on implicitSize {
                            Anim {}
                        }

                        MouseArea {
                            id: iconHoverArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                }

                CurrentAppPopUp {
                    hoverTarget: iconHoverArea
                    workspaceId: button.workspaceValue
                }
            }
        }
    }
}
