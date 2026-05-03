import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import qs.common
import qs.common.widgets

BarGroup {
    id: root
    property var bar

    readonly property int maxWorkspaces: Mem.options.bar.workspaces.shown || 6
    readonly property int workspaceGroup: Math.floor((monitor.activeWorkspace?.id - 1) / 10)
    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(bar.screen)
    implicitHeight: grid.implicitHeight + Padding.massive
    readonly property string mode: Mem.options.bar.workspaces.unicodeMode || "unicode"
    readonly property var modeMap: {
        "unicode": unicodeComp,
        "rect": rectComp
    }
    MouseArea {
        anchors.fill: parent
        onWheel: event => {
            const dir = event.angleDelta.y < 0 ? "+1" : "-1";
            Hyprland.dispatch(`hl.dsp.focus({ workspace = "r${dir}" })`);
        }
    }

    GridLayout {
        id: grid
        anchors.centerIn: parent
        columns: root.vertical ? 1 : maxWorkspaces
        rows: root.vertical ? maxWorkspaces : 1
        columnSpacing: Padding.small
        rowSpacing: Padding.small

        Repeater {
            model: maxWorkspaces
            StyledLoader {
                sourceComponent: modeMap[root.mode]
                onLoaded: if (ready) {
                    item.wsId = Qt.binding(() => workspaceGroup * maxWorkspaces + index + 1);
                    item.isActive = Qt.binding(() => monitor.activeWorkspace?.id === item.wsId);
                    item.isVertical = Qt.binding(() => root.vertical);
                }
            }
        }
    }
    readonly property Component unicodeComp: StyledText {
        property int wsId: -1
        property bool isActive: false
        property bool isVertical: false
        width: root.width
        height: 18
        font.family: Fonts.family.iconNerd
        font.pixelSize: 22
        color: isActive ? Colors.colPrimary : Colors.colOnLayer0
        opacity: isActive ? 1.0 : 0.4
        horizontalAlignment: Text.AlignHCenter
        text: Mem.options.bar.workspaces.unicodeChar
        MouseArea {
            anchors.fill: parent
            onClicked: Hyprland.dispatch(`workspace ${dot.wsId}`)
        }
    }
    readonly property Component rectComp: StyledRect {
        property int wsId: -1
        property bool isActive: false
        property bool isVertical: false
        implicitWidth: root.width * 0.75
        implicitHeight: isActive ? width * 2 : width
        radius: Rounding.large

        color: isActive ? Colors.colPrimary : Colors.colLayer3
        opacity: isActive ? 1.0 : 0.4

        MouseArea {
            anchors.fill: parent
            onClicked: Hyprland.dispatch(`workspace ${dot.wsId}`)
        }
    }
}
