import QtQuick
import qs.common
import qs.common.widgets

StyledRect {
    property bool expanded: false
    implicitWidth: implicitSize
    implicitSize: Sizes.sidebar.widgetSize
    color: Colors.colLayer1
    radius: Rounding.verylarge
    enableBorders: true
}
