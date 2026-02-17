import QtQuick

import qs.common
import qs.common.widgets
import qs.common.functions

StyledRect {
    id: root

    property bool pill: false
    property bool expanded: false
    readonly property string bgMode: Mem.options.desktop.widgets.mode

    clip: true
    enableBorders: true
    implicitWidth: Sizes.sidebar.widgetSize
    implicitHeight: Sizes.sidebar.widgetSize
    radius: pill ? 99 : Rounding.verylarge
    color: bgMode === "col" ? Colors.colLayer1 : "transparent"

    gradient: Gradient {
        orientation: Gradient.Vertical

        GradientStop {
            position: 1
            color: manageColor(Colors.colLayer0, 0.1)
        }
        GradientStop {
            position: 0.75
            color: manageColor(Colors.colLayer1, 0.25)
        }
        GradientStop {
            position: 0
            color: manageColor(Colors.colOutlineVariant, 0.9)
        }
    }

    function manageColor(color, opacity) {
        if (bgMode === "grad")
            return ColorUtils.transparentize(color, opacity);
        else
            return Colors.colLayer0;
    }

    Behavior on radius {
        Anim {}
    }
}
