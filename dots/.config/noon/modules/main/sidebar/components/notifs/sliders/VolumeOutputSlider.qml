import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import qs.common
import qs.common.widgets
import qs.services

Item {
    id: root
    Layout.fillWidth: true
    Layout.preferredHeight: 45

    property var sink: AudioService.sink
    property real maxValue: 1

    Symbol {
        z: 2
        text: volumeSlider.value <= 0.01 ? "volume_off" : "volume_up"
        color: Colors.colOnPrimary
        font.pixelSize: 18
        fill: 1
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: volumeSlider.left
        anchors.leftMargin: Padding.verylarge
        animateChange: true
    }

    StyledSlider {
        id: volumeSlider
        anchors.fill: parent
        from: 0
        to: root.maxValue
        stepSize: 0.01
        z: 1
        scale: 1.05
        highlightColor: Colors.colPrimary
        trackColor: Colors.colSecondaryContainer
        handleColor: Colors.m3.m3onSecondaryContainer
        value: sink?.audio?.volume ?? 0
        onValueChanged: if (sink?.audio)
            sink.audio.volume = value
    }
}
