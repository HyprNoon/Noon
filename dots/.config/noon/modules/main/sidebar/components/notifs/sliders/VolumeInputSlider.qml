import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import qs.common
import qs.common.widgets
import qs.services

Item {
    id: root
    visible: Mem.options.sidebar.appearance.showVolumeInputSlider ?? false
    Layout.fillWidth: true
    Layout.preferredHeight: 45

    property var source: AudioService.source
    property real maxValue: 1

    Symbol {
        z: 2
        text: volumeSlider.value <= 0.01 ? "mic_off" : "mic"
        animateChange: true
        fill: 1
        color: Colors.m3.m3onPrimary
        font.pixelSize: 18
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: volumeSlider.left
        anchors.leftMargin: Padding.verylarge
    }

    StyledSlider {
        id: volumeSlider
        anchors.fill: parent
        from: 0
        to: root.maxValue
        stepSize: 0.01
        z: 1
        highlightColor: Colors.colPrimary
        scale: 1.05
        trackColor: Colors.colSecondaryContainer
        handleColor: Colors.m3.m3onSecondaryContainer
        value: source?.audio?.volume ?? 0
        onValueChanged: {
            if (source?.audio)
                source.audio.volume = value;
        }
    }
}
