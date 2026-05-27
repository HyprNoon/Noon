import QtQuick
import QtQuick.Effects
import qs.common

RectangularShadow {
    required property var target
    property bool show: true
    property real transparency: 0.2
    z: -9999
    blur: 35
    spread: 0
    // offset: Qt.vector2d(10, 10)
    // visible: show && target.visible
    visible: !Colors.transparent
    anchors.fill: target
    color: Colors.t(Colors.colShadow, transparency)
    radius: Rounding.verylarge
    opacity: show ? (target?.opacity ?? 1) : 0
    cached: true
    Behavior on opacity {
        NumberAnimation {
            duration: 100
        }
    }
}
