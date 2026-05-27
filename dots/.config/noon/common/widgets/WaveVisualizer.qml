import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import qs.common
import qs.common.widgets
import qs.services
import "visualizers.js" as Drawing

Canvas {
    id: root

    enum Type {
        Filled,
        Bars,
        Waveform,
        CapsuleWaves,
        LineGlow
    }

    property list<var> points
    property real maxVisualizerValue: 1000
    property bool live: true
    property color color: Colors.m3.m3primary
    property int visualizerType: WaveVisualizer.Filled

    property real barSpacing: 2
    property real thickBarSpacing: 4
    property real thickBarCornerRadius: 6
    property real animationTime: 0

    readonly property var drawTable: ({
            [WaveVisualizer.Filled]: Drawing.drawFilled,
            [WaveVisualizer.Bars]: Drawing.drawBars,
            [WaveVisualizer.Waveform]: Drawing.drawWaveform,
            [WaveVisualizer.CapsuleWaves]: Drawing.drawCapsuleWaves,
            [WaveVisualizer.LineGlow]: Drawing.drawLineGlow
        })

    anchors.fill: parent

    onPointsChanged: requestPaint()

    onPaint: {
        var ctx = getContext("2d");
        ctx.clearRect(0, 0, width, height);

        if (!root.live || points.length < 2) {
            return;
        }

        var drawFunc = drawTable[visualizerType] || Drawing.drawFilled;
        drawFunc(root, ctx, width, height, points.length, maxVisualizerValue);
    }

    Timer {
        interval: 16
        running: root.live
        repeat: true
        onTriggered: {
            root.animationTime += 0.05;
            root.requestPaint();
        }
    }
}
