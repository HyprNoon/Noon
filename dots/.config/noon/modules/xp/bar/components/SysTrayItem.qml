import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import qs.common
import qs.common.widgets
import qs.store

MouseArea {
    id: root
    required property SystemTrayItem item
    property bool targetMenuOpen: false

    signal menuOpened(qsWindow: var)
    signal menuClosed

    hoverEnabled: true
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    implicitWidth: 20
    implicitHeight: 20
    onPressed: event => {
        switch (event.button) {
        case Qt.LeftButton:
            item.activate();
            break;
        case Qt.RightButton:
            if (item.hasMenu) {
                menu.active = !menu.active;
                if (menu.active)
                    menu.open();
            }
            break;
        }
        event.accepted = true;
    }
    onEntered: {
        tooltip.text = item.tooltipTitle.length > 0 ? item.tooltipTitle : (item.title.length > 0 ? item.title : item.id);
        if (item.tooltipDescription.length > 0)
            tooltip.text += " • " + item.tooltipDescription;
    }

    Loader {
        id: menu
        function open() {
            menu.active = true;
        }
        active: false
        sourceComponent: SysTrayMenu {
            Component.onCompleted: this.open()
            trayItemMenuHandle: root.item.menu
            anchor {
                item: root
                edges: Edges.Bottom
                gravity: Edges.Bottom
            }

            onMenuOpened: window => root.menuOpened(window)
            onMenuClosed: {
                root.menuClosed();
                menu.active = false;
            }
        }
    }

    StyledIconImage {
        id: trayIcon
        tint: 0.5
        colorize: Mem?.options.appearance.icons.tint
        source: root.item.icon
        anchors.centerIn: parent
        implicitSize: root.width
    }

    PopupToolTip {
        id: tooltip
        extraVisibleCondition: root.containsMouse
        alternativeVisibleCondition: extraVisibleCondition
        anchorEdges: {
            switch (Mem.options.bar.behavior.position) {
            case "top":
                return Edges.Bottom;  // Changed from Edges.bottom
            case "bottom":
                return Edges.Top;     // Changed from Edges.top
            case "left":
                return Edges.Right;   // Changed from Edges.right
            case "right":
                return Edges.Left;    // Changed from Edges.left
            }
        }
    }
}
