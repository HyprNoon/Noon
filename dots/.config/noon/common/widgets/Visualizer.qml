import Noon.Utils
import QtQuick
import qs.common
import qs.common.utils
import qs.common.functions
import qs.common.widgets
import qs.services
import Quickshell

StyledRect {
    id: root

    anchors.fill: parent

    property bool active: false
    property alias mode: waves.visualizerType
    property color visualizerColor: ColorUtils.transparentize(Colors.colPrimary, 0.35)
    property real maxVisualizerValue: 5000
    clip: radius > 0
    color: "transparent"

    CavaWatcher {
        id: cavaWatcher
        smoothing: 0
        active: root.active
    }

    WaveVisualizer {
        id: waves
        anchors.fill: parent
        visualizerType: root.mode
        points: cavaWatcher.data
        maxVisualizerValue: root.maxVisualizerValue
        color: root.visualizerColor
        live: root.active
    }
}
