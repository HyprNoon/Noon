import QtQuick
import qs.common
import qs.common.functions

ShaderEffect {
    property real time: 0
    property color colorA: Colors.colPrimaryActive
    property color colorB: Colors.colSecondaryContainer
    property color colorC: Colors.colLayer0
    property real speed: 0.14
    property real scale: 1.8
    property real complexity: 2.0
    property real flowSharpness: 2
    property real aspect: width / height
    property real alphaBase: 0.24
    property real alphaFlowBoost: 0.28
    property real alphaMin: 0.35
    property real alphaMax: 0.92
    property real edgeWidth: 4
    property real edgeIntensity: 0.56
    property real edgePower: 2.5

    NumberAnimation on time {
        from: 0
        to: 100
        duration: 40000
        loops: Animation.Infinite
        running: true
    }

    blending: true
    vertexShader: Qt.resolvedUrl("shaders/silk.vert.qsb")
    fragmentShader: Qt.resolvedUrl("shaders/silk.frag.qsb")
}
