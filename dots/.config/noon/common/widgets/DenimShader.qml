import QtQuick
import qs.common
import qs.common.functions

ShaderEffect {
    property color colorA: Colors.colLayer0
    property color colorB: Colors.colOnLayer0
    property real scale: 160.0
    property real threadSharpness: 2.8
    property real twillShift: 0.333
    property real fuzzAmount: 0.6
    property real fuzzScale: 8.0
    property real fadeScale: 1.0
    property real fadeStrength: 0.3
    property real edgeWidth: 0.12
    property real edgeIntensity: 0.2
    property real edgePower: 2.0
    property real aspect: width / height
    property real alphaBase: Colors.transparent ? Colors.transparency : 1
    property real alphaMin: 0.0
    property real alphaMax: 0.98
    vertexShader: Qt.resolvedUrl("shaders/denim.vert.qsb")
    fragmentShader: Qt.resolvedUrl("shaders/denim.frag.qsb")
}
