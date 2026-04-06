import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

Item {
    id: root

    width: bg.implicitWidth + Padding.massive
    height: bg.implicitHeight + Padding.massive
    required property var contentItem

    StyledRect {
        id: bg
        anchors.centerIn: parent
        implicitWidth: 420
        implicitHeight: 80
        color: Colors.colLayer2
        clip: true
        radius: Rounding.full
        children: root.contentItem
        Component.onCompleted: {
            if (contentItem)
                contentItem.anchors.fill = bg;
        }
    }

    StyledRectangularShadow {
        target: bg
        intensity: 0.5
    }
}
