import QtQuick
import qs.common
import qs.common.functions

ShaderEffect {
    property real time: 0
    property color bgColor: Colors.colPrimary
    property color lineColor: Colors.colLayer0
    property real speed: 0.06
    property real scale: 2.8
    property real complexity: 2
    property real lineCount: 10.0
    property real lineWidth: 0.08
    property real lineSharpness: 1.0
    property real aspect: width / height
    property real alphaBase: 0.26
    property real alphaMin: 0.0
    property real alphaMax: 1.0

    NumberAnimation on time {
        from: 0
        to: 100
        duration: 40000
        loops: Animation.Infinite
        running: true
    }

    blending: true
    vertexShader: Qt.resolvedUrl("shaders/topo.vert.qsb")
    fragmentShader: Qt.resolvedUrl("shaders/topo.frag.qsb")
}
