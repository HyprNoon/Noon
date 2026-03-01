import qs.services
import qs.common
import qs.common.utils
import qs.common.widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

Scope {
    id: root
    property bool showOsdValues: false
    property bool userInteracting: false
    property string protectionMessage: ""
    property var focusedScreen: MonitorsInfo.focused

    Binding {
        target: GlobalStates.main
        property: "showOsdValues"
        value: root.showOsdValues
    }

    function triggerOsd() {
        root.showOsdValues = true;
        if (!userInteracting)
            osdTimeout.restart();
    }

    Timer {
        id: osdTimeout
        interval: Mem.options.osd.timeout
        repeat: false
        running: !userInteracting
        onTriggered: {
            root.showOsdValues = false;
            root.protectionMessage = "";
        }
    }
    Connections {
        target: BrightnessService
        function onBrightnessChanged() {
            root.showOsdValues = false;
        }
    }

    Connections {
        target: AudioService.sink?.audio ?? null
        function onVolumeChanged() {
            if (AudioService.ready)
                root.triggerOsd();
        }
        function onMutedChanged() {
            if (AudioService.ready)
                root.triggerOsd();
        }
    }

    Connections {
        target: AudioService
        function onSinkProtectionTriggered(reason) {
            root.protectionMessage = reason;
            root.triggerOsd();
        }
    }

    Connections {
        target: root
        function onFocusedScreenChanged() {
            if (osdIndicator.item)
                osdIndicator.item.screen = root.focusedScreen;
        }
    }

    OsdValueIndicator {
        id: osdIndicator
        active: showOsdValues && GlobalStates.main.canNotify

        value: AudioService.sink?.audio.volume ?? 0
        icon: AudioService.sink?.audio.muted ? "volume_off" : "volume_up"
        targetScreen: root.focusedScreen
        volumeMode: true
        onInteractionStarted: root.userInteracting = true
        onInteractionEnded: root.userInteracting = false
        onValueModified: function (newValue) {
            if (AudioService.sink?.audio)
                AudioService.sink.audio.volume = newValue;
        }
    }

    IpcHandler {
        target: "osdVolume"
        function trigger() {
            root.triggerOsd();
        }
        function hide() {
            root.showOsdValues = false;
        }
        function toggle() {
            root.showOsdValues = !root.showOsdValues;
        }
    }
}
