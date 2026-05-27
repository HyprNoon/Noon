import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets
import qs.common
import qs.common.widgets
import qs.services

StyledPopup {
    id: popup

    active: hoverTarget && hoverTarget.containsMouse
    property alias workspaceId: root.targetWorkspaceId
    contentMargins: Padding.normal
    Item {
        id: root

        property int targetWorkspaceId: 1
        readonly property var monitor: MonitorsInfo.focused
        readonly property var monitorData: HyprlandService.monitors.find(m => m.name === monitor?.name) ?? null

        readonly property real monitorWidth: monitorData ? (monitorData.transform % 2 === 1 ? monitorData.height : monitorData.width) : 1920
        readonly property real monitorHeight: monitorData ? (monitorData.transform % 2 === 1 ? monitorData.width : monitorData.height) : 1080

        readonly property real scaleX: implicitWidth / monitorWidth
        readonly property real scaleY: implicitHeight / monitorHeight

        implicitWidth: 470
        implicitHeight: 264

        StyledRect {
            anchors.fill: parent
            color: Colors.colLayer1
            radius: Rounding.verylarge
            clip: true

            Repeater {
                model: ScriptModel {
                    id: clientModel
                    readonly property var filteredWindows: ToplevelManager?.toplevels ? ToplevelManager.toplevels.values.filter(t => {
                        const win = HyprlandService.windowByAddress[`0x${t.HyprlandToplevel.address}`];
                        return win && win.workspace && win.workspace.id === root.targetWorkspaceId;
                    }) : []
                    values: clientModel.filteredWindows
                }

                delegate: StyledRect {
                    id: winRect
                    required property var modelData

                    readonly property string address: `0x${modelData.HyprlandToplevel.address}`
                    readonly property var winData: HyprlandService.windowByAddress[address]

                    x: ((winData?.at[0] ?? 0) - (root.monitorData?.x ?? 0)) * root.scaleX
                    y: ((winData?.at[1] ?? 0) - (root.monitorData?.y ?? 0)) * root.scaleY
                    width: Math.max(1, (winData?.size[0] ?? 0) * root.scaleX)
                    height: Math.max(1, (winData?.size[1] ?? 0) * root.scaleY)

                    color: Colors.colLayer2
                    radius: Rounding.normal
                    enableBorders: true
                    clip: true

                    StyledScreencopyView {
                        anchors.fill: parent
                        paintCursor: false
                        constraintSize: Qt.size(winRect.width, winRect.height)
                        captureSource: winRect.modelData
                        live: true
                    }

                    StyledIconImage {
                        mipmap: true
                        _source: AppSearch.guessIcon(winRect.winData?.class)
                        implicitSize: Math.min(winRect.width, winRect.height) * 0.25
                        anchors.centerIn: parent
                    }
                }
            }
        }
    }
}
