import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import qs.common
import qs.services
import qs.common.widgets

StyledRect {
    id: root

    property var toplevel
    property var windowData
    property var monitorData
    property real viewScale
    property real availableWorkspaceWidth
    property real availableWorkspaceHeight
    property real xOffset: 0
    property real yOffset: 0
    property bool restrictToWorkspace: true
    property bool hovered: false
    property bool pressed: false
    property real initX: ((windowData?.at[0] - (monitorData?.x ?? 0) - (monitorData?.reserved?.[3] ?? 0)) * viewScale) + xOffset
    property real initY: ((windowData?.at[1] - (monitorData?.y ?? 0) - (monitorData?.reserved?.[0] ?? 0)) * viewScale) + yOffset
    readonly property real targetWindowWidth: (windowData?.size[0] ?? 0) * viewScale
    readonly property real targetWindowHeight: (windowData?.size[1] ?? 0) * viewScale

    x: initX
    y: initY
    width: {
        if (!availableWorkspaceWidth || !targetWindowWidth)
            return 0;
        const relX = x - xOffset;
        if (relX >= 0)
            return Math.min(targetWindowWidth, availableWorkspaceWidth);
        return Math.min(targetWindowWidth + relX, availableWorkspaceWidth);
    }
    height: {
        if (!availableWorkspaceHeight || !targetWindowHeight)
            return 0;
        const relY = y - yOffset;
        if (relY >= 0)
            return Math.min(targetWindowHeight, availableWorkspaceHeight);
        return Math.min(targetWindowHeight + relY, availableWorkspaceHeight);
    }
    color: Colors.colLayer1
    radius: Rounding.verylarge
    enableBorders: true
    clip: true

    Behavior on x {
        Anim {}
    }
    Behavior on y {
        Anim {}
    }

    StyledScreencopyView {
        anchors.fill: parent
        paintCursor: false
        constraintSize: Qt.size(parent.width, parent.height)
        captureSource: root.toplevel
        live: true
    }

    StyledIconImage {
        z: 999
        mipmap: true
        _source: AppSearch.guessIcon(root.windowData?.class)
        implicitSize: Math.sqrt(Math.pow(parent.width, 2) + Math.pow(parent.height, 2)) * 0.11
        anchors {
            bottom: parent.bottom
            right: parent.right
            margins: implicitSize * 0.175
        }
    }
}
