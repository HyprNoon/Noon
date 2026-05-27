import QtQuick

import qs.common
import qs.common.widgets
import qs.common.functions

ShaderRect {
    id: root
    property var window
    property bool pinned: false
    property bool pill: false
    property bool expanded: false

    clip: true
    enableBorders: true
    implicitWidth: Sizes.sidebar.widgetSize
    implicitHeight: Sizes.sidebar.widgetSize
    radius: pill ? 99 : Rounding.verylarge

    Symbol {
        z: 999
        font.pixelSize: 20
        visible: pinned
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: Padding.large
        opacity: 0.6
        color: Colors.colOnLayer0
        text: "push_pin"
        rotation: 45
    }
}
