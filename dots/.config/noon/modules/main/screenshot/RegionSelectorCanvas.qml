import QtQuick
import qs.common

Item {
    id: root

    property bool active: false

    signal regionCommitted(real x, real y, real w, real h)

    property real startX: 0
    property real startY: 0
    property real endX: 0
    property real endY: 0
    property bool dragging: false

    readonly property real selX: Math.min(startX, endX)
    readonly property real selY: Math.min(startY, endY)
    readonly property real selW: Math.abs(endX - startX)
    readonly property real selH: Math.abs(endY - startY)

    visible: root.active
    enabled: root.active

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.CrossCursor
        enabled: root.active

        onPressed: mouse => {
            root.startX = mouse.x;
            root.startY = mouse.y;
            root.endX = mouse.x;
            root.endY = mouse.y;
            root.dragging = true;
        }

        onPositionChanged: mouse => {
            if (root.dragging) {
                root.endX = mouse.x;
                root.endY = mouse.y;
            }
        }

        onReleased: {
            root.dragging = false;
            if (root.selW > 4 && root.selH > 4)
                root.regionCommitted(root.selX, root.selY, root.selW, root.selH);
        }
    }

    Rectangle {
        visible: root.dragging && root.selW > 2 && root.selH > 2
        x: root.selX
        y: root.selY
        width: root.selW
        height: root.selH
        color: "transparent"
        radius: Rounding.normal
        border.color: Colors.colPrimary
        border.width: 2
    }
}
