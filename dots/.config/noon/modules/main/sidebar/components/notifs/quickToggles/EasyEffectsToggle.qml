import QtQuick
import Quickshell
import qs.common
import qs.common.utils
import qs.common.widgets
import qs.services

QuickToggleButton {
    id: root

    toggled: Mem.options.services.easyEffects
    buttonName: "EasyEffects"
    buttonIcon: "graphic_eq"
    onClicked: {
        if (toggled) {
            toggled = !toggled;
            NoonUtils.execDetached(["pkill", "easyeffects"]);
        } else {
            toggled = !toggled;
            NoonUtils.execDetached(["easyeffects", "--service-mode"]);
        }
    }

    Process {
        id: fetchAvailability

        running: true
        command: ["bash", "-c", "command -v easyeffects"]
        onExited: (exitCode, exitStatus) => {
            root.visible = exitCode === 0;
        }
    }

    Process {
        id: fetchActiveState

        running: true
        command: ["pidof", "easyeffects"]
        onExited: (exitCode, exitStatus) => {
            root.toggled = exitCode === 0;
        }
    }
}
