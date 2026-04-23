import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.common
import qs.common.widgets
import qs.services

Button {
    property color colBackground: Colors.colLayer3
    property color colBackgroundHover: Colors.colLayer3Hover
    property color colBackgroundActive: Colors.colLayer3Active

    property int buttonRadius: Rounding.full
    implicitWidth: 40
    implicitHeight: 40

    background: StyledRect {
        anchors.fill: parent
        radius: buttonRadius
        color: parent.pressed ? colBackgroundActive : parent.hovered ? colBackgroundHover : colBackground
    }
}
