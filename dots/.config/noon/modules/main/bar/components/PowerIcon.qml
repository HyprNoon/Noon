import QtQuick
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

MaterialShapeWrappedSymbol {
    fill: 1
    readonly property bool enabled: BatteryService.available && PowerService.controller !== "none"
    readonly property var aMap: [
        {
            name: "Power Saver",
            icon: "eco",
            color: Colors.colTertiary,
            sColor: Colors.colOnTertiary,
            shape: MaterialShape.Cookie4Sided
        },
        {
            name: "Balanced",
            icon: "balance",
            color: Colors.colSecondary,
            sColor: Colors.colOnSecondary,
            shape: MaterialShape.Cookie6Sided
        },
        {
            name: "Performance",
            icon: "bolt",
            color: Colors.colPrimary,
            sColor: Colors.colOnPrimary,
            shape: MaterialShape.Cookie9Sided
        }
    ]

    readonly property var currentModeData: aMap.filter(mode => mode.name === PowerService.modeName)[0]

    implicitSize: 32
    animateChange: true
    text: !enabled ? getCurrentDesktopIcon() : currentModeData.icon
    shape: !enabled ? MaterialShape.Cookie9Sided : currentModeData.shape
    color: !enabled ? Colors.colPrimary : currentModeData.color
    colSymbol: !enabled ? Colors.colOnPrimary : currentModeData.sColor

    function getCurrentDesktopIcon() {
        const activeApp = MonitorsInfo.topLevel?.appId;

        if (activeApp === null)
            return "deployed_code";

        const rules = [
            {
                pattern: /brave|firefox|zen|chromium|chrome|opera|vivaldi/i,
                icon: "globe"
            },
            {
                pattern: /dolphin|nautilus|files|thunar|nemo|pcmanfm|ranger/i,
                icon: "folder"
            },
            {
                pattern: /steam|heroic|lutris|gamescope|bottles/i,
                icon: "joystick"
            },
            {
                pattern: /kitty|ghostty|alacritty|foot|wezterm|konsole|xterm/i,
                icon: "terminal_2"
            },
            {
                pattern: /code|zeditor|zed|antigravity|cursor|windsurf/i,
                icon: "data_object"
            },
        ];

        return rules.find(({
                pattern
            }) => pattern.test(activeApp))?.icon ?? "deployed_code";
    }

    MouseArea {
        id: mouse
        enabled: root.enabled
        hoverEnabled: true
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: PowerService.cycleMode()
    }
}
