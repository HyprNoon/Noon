import QtQuick
import Quickshell
import qs.common
import qs.common.utils
import qs.services
import qs.store

IpcHandler {
    target: "xp"

    function toggle_run() {
        Globals.xp.showRun = !Globals.xp.showRun;
    }
    function toggle_settings() {
        Globals.xp.showControlPanel = !Globals.xp.showControlPanel;
    }
    function toggle_start_menu() {
        Globals.xp.showStartMenu = !Globals.xp.showStartMenu;
    }
}
