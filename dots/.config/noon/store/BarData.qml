pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import qs.common
import qs.common.utils

Singleton {
    readonly property var bars: barsModel.getArray("fileBaseName")
    readonly property QtObject settings: Mem.options.bar
    readonly property string position: settings.behavior.position
    readonly property bool isVertical: ["left", "right"].includes(position)
    readonly property list<string> appearanceModes: ["float", "sharp", "concave", "convex"]
    readonly property list<string> positions: ["left", "right", "bottom", "top"]
    readonly property list<string> layoutProps: ["fillHeight", "fillWidth", "preferredWidth", "preferredHeight", "topMargin", "bottomMargin", "leftMargin", "rightMargin", "margins", "implicitWidth", "implicitHeight", "width", "height", "minimumWidth", "minimumHeight", "maximumWidth", "maximumHeight"]
    readonly property int currentBarExclusiveSize: isVertical ? settings.appearance.width : settings.appearance.height

    // Bar Modules
    readonly property var contentTable: {
        "spacer": "Spacer",
        "power": "PowerIcon",
        "workspaces": "VWorkspaces",
        "unicodeWs": "UnicodeWs",
        "progressWs": "ProgressWs",
        "systemStatusIcons": "SystemStatusIcons",
        "materialStatusIcons": "StatusIcons",
        "inlineTray": "SysTray",
        "utilButtons": "UtilButtons",
        "title": "VTitle",
        "timers": "Timers",
        "resources": "Resources",
        "circBattery": "MinimalBattery",
        "weather": "WeatherIndicator",
        "media": "VMedia",
        "clock": "VClockWidget",
        "keyboard": "KeyboardLayout",
        "logo": "Logo",
        "battery": "VBatteryIndicator",
        "separator": "HSeparator",
        "space": "Spacer",
        "volume": "VolumeIndicator",
        "tray": "Tray",
        "brightness": "BrightnessIndicator"
    }

    // Horizontal-specific module substitutions
    readonly property var horizontalSubstitutions: {
        "workspaces": "Workspaces",
        "title": "ActiveWindow",
        "media": "Media",
        "battery": "BatteryIndicator",
        "clock": "ClockWidget",
        "separator": "VerticalSeparator"
    }

    // Helper for check and set bar pos
    function setPosition(pos) {
        if (positions.indexOf(pos) > -1)
            settings.behavior.position = pos;
    }

    // Toggle Between Vertical and Horizontal
    function toggleLayout() {
        const pairs = {
            "left": "top",
            "right": "bottom",
            "bottom": "right",
            "top": "left"
        };
        setPosition(pairs[position]);
    }

    function swapPosition() {
        const pairs = {
            "left": "right",
            "right": "left",
            "top": "bottom",
            "bottom": "top"
        };
        setPosition(pairs[position]);
    }

    function cyclePosition() {
        const positions = ["top", "left", "bottom", "right"];
        const currentPosition = settings.behavior.position;
        const position = (positions.indexOf(currentPosition) + 1) % 4;
        setPosition(positions[position]);
    }

    FolderListModel {
        id: barsModel
        nameFilters: ["*.qml"]
        folder: Qt.resolvedUrl(Directories.shellDir + "/modules/main/bar/layouts")
        showDirs: false
        showFiles: true
    }
}
