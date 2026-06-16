import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import qs.common
import qs.common.widgets

Item {
    id: root
    required property var bar

    readonly property int maxWorkspaces: 5
    readonly property int workspaceGroup: Math.floor((monitor.activeWorkspace?.id - 1) / root.maxWorkspaces)
    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(bar.screen)
    Layout.fillHeight: true
    Layout.preferredWidth: row.implicitWidth

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 2

        Repeater {
            model: root.maxWorkspaces
            delegate: Rectangle {
                id: item

                property int wsId: workspaceGroup * root.maxWorkspaces + index + 1
                property bool isActive: root.monitor.activeWorkspace?.id === item.wsId
                implicitHeight: root.height
                implicitWidth: root.height
                color: isActive ? Colors.colPrimary : Colors.colLayer3
                opacity: isActive ? 1.0 : 0.4
                StyledText {
                    color: isActive ? Colors.colOnPrimary : Colors.colOnLayer3
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 2
                    text: item.wsId
                    font.bold: true
                    font.pixelSize: Fonts.sizes.large
                    font.family: Fonts.family.monospace
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: HyprlandService.focusWs(item.wsId)
                }
            }
        }
    }
}
