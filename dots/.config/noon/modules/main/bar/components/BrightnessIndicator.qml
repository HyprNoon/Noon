import QtQuick
import Quickshell
import qs.common
import qs.common.widgets
import qs.services
import qs.store

BarProgressIndicator {
    id: root

    property var brightnessMonitor: BrightnessService.getMonitorForScreen(focusedScreen)
    value: brightnessMonitor.brightness
    icon: BrightnessService.iconMaterial

    Connections {
        target: BrightnessService
        function onBrightnessChanged() {
            if (root.brightnessMonitor && root.brightnessMonitor.ready) {
                root.expanded = true;
            }
        }
    }

    WheelHandler {
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onWheel: event => {
            let step = 0.05;
            if (event.angleDelta.y < 0)
                root.brightnessMonitor.setBrightness(root.brightnessMonitor.brightness - step);
            else if (event.angleDelta.y > 0)
                root.brightnessMonitor.setBrightness(root.brightnessMonitor.brightness + step);

            root.expanded = true;
        }
    }
}
