pragma Singleton
pragma ComponentBehavior: Bound
import Noon.Services
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.common.widgets
import qs.services

Singleton {
    id: root

    property QtObject main
    property QtObject xp
    property QtObject nobuntu
    property QtObject applications
    property QtObject toasts
    property var web_session

    property bool superPressed: false
    readonly property var topLevel: ToplevelManager.activeToplevel
    readonly property bool superHeld: superHeldShortcut.pressed

    CustomShortcut {
        id: superHeldShortcut
        name: "superHeld"
        onPressed: GlobalStates.superPressed = !GlobalStates.superPressed
    }
    function handle_init(mode) {
        KeyringStorage.reload();
        NightLightService.reload();
        ClipboardService.init();
        Hyprland.dispatch("submap " + Mem.options.desktop.hyprland.tilingLayout);
        switch (mode) {
        case "main":
            TimerService.reload();
            AlarmService.reload();
            AmbientSoundsService.reload();
            NoonUtils.playSound("device_unlocked");
            break;
        case "nobuntu":
            NoonUtils.playSound("device_unlocked");
            break;
        case "xp":
            NoonUtils.playSound("init", "xp");
            break;
        }
        console.log("Initialized " + mode);
    }
    applications: QtObject {
        property QtObject mediaplayer: QtObject {
            property bool show: false
            property var queue: []
        }
        property QtObject reader: QtObject {
            property bool show: false
            property string currentPath: Qt.resolvedUrl(Directories.standard.documents)

            property var document_page_view
        }
        property QtObject editor: QtObject {
            property bool show: false
            property string currentPath: Qt.resolvedUrl(Directories.shellConfigs)
            property string currentFile: ""
        }
    }
    toasts: QtObject {
        property ListModel data: ListModel {}
    }
    main: QtObject {
        id: main
        property var sidebar
        property var lock
        property bool locked: false
        property bool exposeView: false
        property bool showOsdValues: false
        property bool showBeam: false
        property bool showScreenshot: false
        property bool canNotify: sidebar?.hoverMode ?? true

        property QtObject dmenu: QtObject {
            property var items
            property var action
        }
        property QtObject sysDialogs: QtObject {
            property string mode
            property var pendingData
        }

        property QtObject dialogs: QtObject {
            property string current: ""
        }
    }
    xp: QtObject {
        id: xp

        property bool locked: false

        property bool showRun: false
        property bool showStartMenu: false
        property bool showControlPanel: false
    }
    nobuntu: QtObject {
        id: nobuntu

        property QtObject db: QtObject {
            property bool show: false
        }

        property QtObject clipboard: QtObject {
            property bool show: false
        }

        property QtObject overview: QtObject {
            property bool show: false
        }

        property QtObject notifs: QtObject {
            property bool show: false
        }
    }
}
