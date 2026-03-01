import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.services

Item {
    id: root
    Layout.fillWidth: true
    Layout.preferredHeight: 45

    property var focusedScreen: MonitorsInfo.focused
    property var brightnessMonitor: BrightnessService.getMonitorForScreen(focusedScreen)

    StyledSlider {
        id: brightnessSlider
        anchors.fill: parent
        from: 0
        to: 1
        stepSize: 0.01
        scale: 1.05
        showBackgroundDot: false
        value: brightnessMonitor.brightness
        onValueChanged: if (brightnessMonitor) {
            brightnessMonitor.setBrightness(value);
        }

        Connections {
            target: brightnessMonitor ? brightnessMonitor : null
            ignoreUnknownSignals: true

            function onBrightnessChanged() {
                if (brightnessMonitor)
                    brightnessSlider.value = brightnessMonitor.brightness;
            }
        }
    }

    Symbol {
        text: "light_mode"
        z: 0
        color: Colors.colOnPrimary
        fill: 1
        font.pixelSize: 18
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: brightnessSlider.left
        anchors.leftMargin: Padding.verylarge
    }
}
