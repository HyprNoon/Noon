import QtQuick
import qs.common
import qs.common.functions

ShaderEffect {
    property real time: 0

    property color topColor: Colors.m3.m3surfaceContainer
    property color midColor: Colors.m3.m3secondaryContainer
    property color bottomColor: Colors.m3.m3primaryContainer

    property real topSplit: 0.38

    property real bloomIntensity: 0.52
    property real bloomHeight: 0.58

    property real stripeAngle: 22.0
    property real stripeSpeed: 0.012
    property real stripeCount: 4.0
    property real stripeSpread: 1.4
    property real stripeWidth: 0.22
    property real stripeIntensity: 0.28
    property real stripeSharpness: 1.6

    property real cyanDepthIntensity: 0.10
    property real edgeGlowIntensity: 0.08
    property real edgeGlowPower: 4.0

    property real glassTopDensity: 1.18
    property real glassBottomDensity: 0.82

    property real saturation: 0.92

    property real alphaBase: !Colors.transparent ? 1 : 0.34
    property real alphaBloomBoost: 0.08
    property real alphaStripeBoost: 0.06
    property real alphaMin: !Colors.transparency ? 1 : 0.18
    property real alphaMax: !Colors.transparency ? 1 : 0.38

    NumberAnimation on time {
        from: 0
        to: 100
        duration: 60000
        loops: Animation.Infinite
        running: true
    }

    blending: true
    vertexShader: Qt.resolvedUrl("shaders/aero.vert.qsb")
    fragmentShader: Qt.resolvedUrl("shaders/aero.frag.qsb")
}
