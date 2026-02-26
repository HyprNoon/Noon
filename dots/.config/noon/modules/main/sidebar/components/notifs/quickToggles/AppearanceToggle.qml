import qs.common
import qs.services

QuickToggleButton {
    toggled: Mem.states.desktop.appearance.mode === "dark"
    buttonSubtext: Mem.states.desktop.appearance.autoShellMode ? "Dynamic" : "Static"
    buttonIcon: toggled ? "dark_mode" : "light_mode"
    buttonName: toggled ? "Dark" : "Light"
    onClicked: WallpaperService.toggleShellMode()
    dialogName: "Appearance"
}
