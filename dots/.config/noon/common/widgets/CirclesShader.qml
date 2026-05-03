import QtQuick
import qs.common
import qs.common.functions

ShaderEffect {

    property real u_time: 0
    property vector2d u_res: Qt.vector2d(width, height)
    property color colPrimary: parent?.colors.colPrimary
    property color colSecondary: parent?.colors.colSecondaryContainer
    property real baseSpeed: 42
    property real blurSoftness: 0
    property int count: 4

    NumberAnimation on u_time {
        from: 0
        to: 1000000
        duration: 1000000000
        running: true
    }
    blending: true
    fragmentShader: Qt.resolvedUrl("shaders/circles.frag.qsb")
}
