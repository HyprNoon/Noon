import qs.common
import qs.services

QuickToggleButton {
    toggled: Mem.looks.mode === "dark"
    buttonSubtext: Mem.looks.autoShellMode ? "Dynamic" : "Static"
    buttonIcon: toggled ? "dark_mode" : "routine"
    buttonName: toggled ? "Dark" : "Light"
    onClicked: WallpaperService.toggleShellMode()
    dialogName: "Appearance"
}
