import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import qs.common

SwipeView {
    id: root
    property int radius
    spacing: Padding.normal
    clip: true
    layer.enabled: clip && radius > 0
    layer.effect: OpacityMask {
        maskSource: Rectangle {
            width: root?.width
            height: root?.height
            radius: Rounding.verylarge
        }
    }
}
