import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import qs.common
import qs.services
import "./../common"
import qs.common.widgets

StyledIconImage {
    id: root
    property var bar
    readonly property Component _clipboard_popup: GClipboardPopup {}

    _source: "edit-paste-symbolic"
    implicitSize: 16
    colorize: true
    tint: 0.15
    tintColor: Colors.colSubtext

    anchors {
        top: parent.top
        bottom: parent.bottom
    }

    Connections {
        target: Globals.nobuntu.clipboard
        function onShowChanged() {
            _popup_loader.active = Globals.nobuntu.clipboard.show;
        }
    }

    Loader {
        id: _popup_loader
        active: false
        asynchronous: true
        sourceComponent: _clipboard_popup
        onLoaded: {
            _popup_loader.item.bar = bar;
            _popup_loader.item.visible = true;
        }
        onActiveChanged: if (active && _popup_loader.item) {
            _popup_loader.item.visible = true;
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        propagateComposedEvents: true
        onPressed: event => {
            if (event.button == Qt.LeftButton) {
                _popup_loader.active = !_popup_loader.active;
            } else if (event.button == Qt.RightButton) {
                _clipboard_context_menu.popup();
            }
        }
    }
}
