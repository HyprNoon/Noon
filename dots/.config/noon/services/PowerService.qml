pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import qs.common

Singleton {
    id: root

    property string icon: "eco"
    property string modeName: "Power Saver"
    property string controller: Mem.states.services?.power?.controller || ""
    property var modes: Mem.states.services?.power?.modes || []
    property string currentMode: Mem.states.services?.power?.mode || "power-saver"

    function cycleMode(reverse = false) {
        const i = modes.indexOf(currentMode);
        if (i === -1)
            return;

        const mode = modes[(i + (reverse ? -1 : 1) + modes.length) % modes.length];
        NoonUtils.execDetached(`${Directories.scriptsDir}/power_service.sh set ${mode}`);
    }

    function getModeDisplayName(mode) {
        return {
            "bat": "Power Saver",
            "power-saver": "Power Saver",
            "balanced": "Balanced",
            "ac": "Performance",
            "performance": "Performance"
        }[mode] || mode;
    }

    function getModeIcon(mode) {
        return {
            "bat": "eco",
            "power-saver": "eco",
            "balanced": "balance",
            "ac": "bolt",
            "performance": "bolt"
        }[mode] || "eco";
    }

    onCurrentModeChanged: {
        modeName = getModeDisplayName(currentMode);
        icon = getModeIcon(currentMode);
        NoonUtils.toast({
            id: 9,
            content: `Power mode changed to ${modeName}`,
            icon: icon
        });
    }
}
