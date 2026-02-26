import Quickshell
import Quickshell.Wayland
import qs.common
import qs.common.utils

PanelWindow {
    id: root

    property string shell: "noon"
    required property string name
    property bool kbFocus: false
    reloadableId: name
    color: "transparent"
    exclusiveZone: 0
    WlrLayershell.namespace: shell + ":" + name
    WlrLayershell.keyboardFocus: (root.kbFocus === true) ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None
    aboveWindows: true
}
