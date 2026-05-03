import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.common
import qs.common.widgets
import qs.common.functions

LazyLoader {
    id: root

    property Item hoverTarget
    default property Item contentItem
    property bool extraVisibilityCondition: true
    property var window: root.hoverTarget.QsWindow
    active: hoverTarget && hoverTarget.containsMouse && extraVisibilityCondition

    component: PopupWindow {
        id: popupWindow

        color: "transparent"
        implicitWidth: popupBackground.implicitWidth + Padding.massive * 2
        implicitHeight: popupBackground.implicitHeight + Padding.massive * 2

        anchor {
            window: root.window
            adjustment: PopupAdjustment.SlideY
            gravity: Edges.Bottom | Edges.Right
            edges: Edges.Bottom | Edges.Right
            rect {
                x: root.hoverTarget.mapToItem(null, root.hoverTarget.width, 0).x
                y: root.hoverTarget.mapToItem(null, 0, 0).y
            }
        }

        StyledRectangularShadow {
            target: popupBackground
        }

        Rectangle {
            id: popupBackground
            anchors {
                fill: parent
                margins: Padding.massive
            }
            implicitWidth: root.contentItem.implicitWidth + Padding.massive
            implicitHeight: root.contentItem.implicitHeight + Padding.massive
            border.width: 1
            border.color: Colors.colOutline
            color: ColorUtils.applyAlpha(Colors.colLayer0, 1 - Colors.transparency)
            radius: Rounding.verylarge
            children: [root.contentItem]
        }
    }
}
