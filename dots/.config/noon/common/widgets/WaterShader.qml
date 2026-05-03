import QtQuick
import qs.common
import qs.common.functions

ShaderEffect {
    property real time: 0
    property color colorA: Colors.colLayer0
    property color colorB: Colors.colPrimaryContainer
    property color colorC: Colors.colPrimaryFixed
    property real speed: 0.22
    property real scale: 1.8
    property real waveHeight: 0.4
    property real causticSharpness: 1.4
    property real layers: 3.0
    property real edgeWidth: 0.15
    property real edgeIntensity: 0.45
    property real edgePower: 2.0
    property real aspect: width / height
    property real alphaBase: 0.88
    property real alphaMin: 0.0
    property real alphaMax: 0.92

    NumberAnimation on time {
        from: 0
        to: 100
        duration: 45000
        loops: Animation.Infinite
        running: true
    }
    blending: true
    vertexShader: Qt.resolvedUrl("shaders/water.vert.qsb")
    fragmentShader: Qt.resolvedUrl("shaders/water.frag.qsb")
}
