import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import Quickshell.Services.SystemTray

RippleButtonWithIcon {
    id: root

    property var bar
    readonly property string pos: Mem.options.bar.behavior.position
    property bool verticalMode: pos === "left" || pos === "right"
    property bool reveal: false
    materialIcon: {
        let dic = {
            "top": "down",
            "right": "left",
            "left": "right",
            "bottom": "up"
        };
        return `keyboard_arrow_${dic[pos]}`;
    }
    visible: SystemTray.items.length > 1
    implicitSize: 28
    buttonRadius: Rounding.small
    releaseAction: () => reveal = !reveal
    colBackground: Colors.colLayer2
    toggled: reveal
    TrayGroup {
        panel: bar
        shown: reveal
        hoverTarget: root.eventArea
    }
}
