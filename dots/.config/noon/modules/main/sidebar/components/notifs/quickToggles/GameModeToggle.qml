import Quickshell
import qs.common
import qs.common.functions
import qs.common.widgets
import qs.services

QuickToggleButton {
    buttonName: "GameMode"
    dialogName: "GameMode"
    buttonIcon: "stadia_controller"
    releaseAction: () => {
        Globals.common.openGameUI = true;
    // GameLauncherService.setGameMode(!toggled);
    }
}
