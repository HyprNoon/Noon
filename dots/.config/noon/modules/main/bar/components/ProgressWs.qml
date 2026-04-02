import QtQuick
import qs.store
import qs.common
import qs.common.functions
import qs.common.widgets

BarGroup {
    id: root
    property var bar

    readonly property real defaultSize: maxWorkspaces * Padding.veryhuge
    readonly property int maxWorkspaces: Mem.options.bar.workspaces.shownWs || 6
    readonly property int workspaceIndexInGroup: (MonitorsInfo.monitorFor(bar.screen).activeWorkspace?.id - 1) % maxWorkspaces

    clip: false
    implicitWidth: defaultSize
    implicitHeight: defaultSize

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.BackButton
        onWheel: event => {
            if (event.angleDelta.y < 0)
                Hyprland.dispatch(`workspace r+1`);
            else if (event.angleDelta.y > 0)
                Hyprland.dispatch(`workspace r-1`);
        }
    }

    ClippedProgressBar {
        id: workspaceProgress
        anchors.fill: parent
        anchors.margins: Padding.verysmall
        vertical: parent.vertical
        value: (workspaceIndexInGroup + 1) / maxWorkspaces
        highlightColor: Colors.colPrimary
        trackColor: Colors.colLayer3
        showEndPoint: root.vertical
        Behavior on value {
            Anim {
                duration: Animations.durations.large
            }
        }
        StyledText {
            z: 0
            anchors.centerIn: parent
            property string value: WorkspaceLabelManager.getDisplayTextForMode(root.workspaceIndexInGroup + 1, "words").trim()
            text: StringUtils.capitalizeFirstLetter(value)
            color: Colors.colLayer3
            font.weight: 900
            font.pixelSize: Fonts.sizes.small
            font.family: Fonts.family.monospace
            rotation: parent.vertical ? 270 : 0
            animateChange: true
        }
    }
}
