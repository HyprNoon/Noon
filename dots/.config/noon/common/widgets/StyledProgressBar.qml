import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.common
import qs.common.widgets
import qs.services

/**
 * Material 3 progress bar. See https://m3.material.io/components/progress-indicators/overview
 */
ProgressBar {
    id: root

    property real valueBarWidth: 120
    property real valueBarHeight: 4
    property real valueBarGap: 12 // 8
    property color indicatorColor: Colors.colOnLayer0
    property color highlightColor: Colors.colPrimary ?? "#685496"
    property color trackColor: Colors.m3.m3secondaryContainer ?? "#F1D3F9"
    property bool sperm: false // If true, the progress bar will have a wavy fill effect
    property bool animateSperm: true
    property real spermAmplitudeMultiplier: sperm ? 0.5 : 0
    property real spermFrequency: 6
    property real spermFps: 60
    property real rounding: Rounding.full
    property bool showProgressIndicator: true
    property bool vertical: false // If true, progress bar grows vertically to the top
    property bool showDot: false // If true, a dot will be displayed at the end of the progress bar
    Behavior on spermAmplitudeMultiplier {
        Anim {}
    }

    Behavior on value {
        Anim {}
    }

    background: Rectangle {
        anchors.fill: parent
        color: "transparent"
        radius: root.rounding
        implicitHeight: vertical ? valueBarWidth : valueBarHeight
        implicitWidth: vertical ? valueBarHeight : valueBarWidth
    }

    contentItem: Item {
        anchors.fill: parent

        Canvas {
            id: wavyFill

            height: vertical ? parent.height : parent.height * 6
            width: vertical ? parent.width * 6 : parent.width
            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);
                var progress = root.visualPosition;
                if (vertical) {
                    // Vertical mode - draw from bottom to top
                    var fillHeight = progress * parent.height;
                    var amplitude = parent.width * root.spermAmplitudeMultiplier;
                    var frequency = root.spermFrequency;
                    var phase = Date.now() / 400;
                    var centerX = width / 2;
                    ctx.strokeStyle = root.highlightColor;
                    ctx.lineWidth = parent.width;
                    ctx.lineCap = root.rounding === 0 ? "butt" : "round";
                    ctx.beginPath();
                    for (var y = parent.height - ctx.lineWidth / 2; y >= parent.height - fillHeight; y -= 1) {
                        var waveX = centerX + amplitude * Math.sin(frequency * 2 * Math.PI * (parent.height - y) / parent.height + phase);
                        if (y === parent.height - ctx.lineWidth / 2)
                            ctx.moveTo(waveX, y);
                        else
                            ctx.lineTo(waveX, y);
                    }
                    ctx.stroke();
                } else {
                    // Original horizontal mode - unchanged
                    var fillWidth = progress * width;
                    var amplitude = parent.height * root.spermAmplitudeMultiplier;
                    var frequency = root.spermFrequency;
                    var phase = Date.now() / 400;
                    var centerY = height / 2;
                    ctx.strokeStyle = root.highlightColor;
                    ctx.lineWidth = parent.height;
                    ctx.lineCap = "round";
                    ctx.beginPath();
                    for (var x = ctx.lineWidth / 2; x <= fillWidth; x += 1) {
                        var waveY = centerY + amplitude * Math.sin(frequency * 2 * Math.PI * x / width + phase);
                        if (x === 0)
                            ctx.moveTo(x, waveY);
                        else
                            ctx.lineTo(x, waveY);
                    }
                    ctx.stroke();
                }
            }

            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: vertical ? undefined : parent.verticalCenter
                top: vertical ? parent.top : undefined
                bottom: vertical ? parent.bottom : undefined
            }

            Connections {
                function onValueChanged() {
                    wavyFill.requestPaint();
                }

                function onHighlightColorChanged() {
                    wavyFill.requestPaint();
                }

                function onVerticalChanged() {
                    wavyFill.requestPaint();
                }

                target: root
            }

            Timer {
                interval: 1000 / root.spermFps
                running: root.animateSperm
                repeat: root.sperm
                onTriggered: wavyFill.requestPaint()
            }
        }

        Rectangle {
            id: gapIndicator
            visible: root.showProgressIndicator
            z: 9999
            radius: root.rounding
            color: root.indicatorColor

            implicitWidth: vertical ? root.width * 2.25 : 4
            implicitHeight: vertical ? 4 : root.height * 2.25

            anchors.centerIn: parent
            anchors.horizontalCenterOffset: vertical ? 0 : (-parent.width / 2) + (root.visualPosition * parent.width) + (valueBarGap * 1.5)
            anchors.verticalCenterOffset: !vertical ? 0 : (parent.height / 2) - (root.visualPosition * parent.height) - (valueBarGap * 1.5)
        }
        Rectangle {
            id: remaining
            // Right remaining part fill (horizontal) / Top remaining part fill (vertical)
            radius: root.rounding
            color: root.trackColor
            visible: !vertical
            anchors.right: parent.right
            width: (1 - root.visualPosition) * parent.width - valueBarGap * 2
            height: parent.height
        }

        Rectangle {
            // Top remaining part fill (vertical mode only)
            radius: root.rounding
            color: root.trackColor
            visible: vertical
            width: parent.width
            height: (1 - root.visualPosition) * parent.height - valueBarGap

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }
        }

        Rectangle {
            visible: root.showDot
            // Stop point (horizontal mode)
            anchors.right: vertical ? undefined : parent.right
            anchors.verticalCenter: vertical ? undefined : parent.verticalCenter
            anchors.rightMargin: vertical ? 0 : 6
            anchors.horizontalCenter: vertical ? parent.horizontalCenter : undefined
            anchors.top: vertical ? parent.top : undefined
            anchors.topMargin: vertical ? 6 : 0
            width: valueBarHeight / 1.5
            height: width
            radius: root.rounding
            color: root.highlightColor
        }
    }
}
