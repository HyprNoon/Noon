import Quickshell
import Quickshell.Wayland
import qs.common
import qs.common.utils

PanelWindow {
    id: root

    property string shell: "noon"
    required property string name
    property int _margins: 0
    property bool fill: false
    property bool keyboardFocus: false
    property string _layer: "Top"
    WlrLayershell.layer: WlrLayer[_layer]
    reloadableId: name
    color: "transparent"
    exclusiveZone: 0
    WlrLayershell.namespace: shell + ":" + name
    WlrLayershell.keyboardFocus: (root.keyboardFocus === true) ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

    margins {
        top: _margins
        bottom: _margins
        left: _margins
        right: _margins
    }
    anchors {
        top: fill
        bottom: fill
        left: fill
        right: fill
    }
}
