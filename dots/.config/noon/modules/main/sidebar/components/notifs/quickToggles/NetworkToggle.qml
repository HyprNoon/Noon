import qs.common
import qs.common.widgets
import qs.common.functions
import qs.services

QuickToggleButton {
    dialogName: "Wifi"
    buttonName: NetworkService.manager.wifiStatus.length > 0 && NetworkService.manager.wifiEnabled ? NetworkService.manager.networkName || StringUtils.capitalizeFirstLetter(NetworkService.manager.wifiStatus) : "Disconnected"
    buttonSubtext: NetworkService.manager.wifiEnabled ? "enabled" : "disabled"
    toggled: NetworkService.manager.networkName.length > 0 && NetworkService.manager.networkName !== "lo"
    buttonIcon: NetworkService.manager.materialSymbol
    onClicked: NetworkService.manager.toggleWifi()
}
