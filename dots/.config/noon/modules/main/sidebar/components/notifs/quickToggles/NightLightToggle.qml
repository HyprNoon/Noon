import Quickshell
import qs.common
import qs.common.widgets
import qs.services

QuickToggleButton {
    id: nightLightButton
    dialogName: "Temp"
    buttonSubtext: Mem.states.services.nightLight.temperature + "K"
    buttonName: "Night Light"
    buttonIcon: "nightlight"
    toggled: Mem.states.services.nightLight.enabled
    onClicked: Mem.states.services.nightLight.enabled = !Mem.states.services.nightLight.enabled
}
