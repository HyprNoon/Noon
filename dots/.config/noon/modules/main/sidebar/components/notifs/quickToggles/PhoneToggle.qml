import Quickshell
import qs.common
import qs.services

QuickToggleButton {
    buttonName: KdeConnectService?.selectedDeviceName || "Offline"
    dialogName: "Phone"
    buttonSubtext: KdeConnectService?.selectedDeviceStatus || "No Reachable Devices"
    toggled: KdeConnectService?.selectedDeviceName.length > 0
    buttonIcon: toggled ? "phonelink" : "phonelink_off"
}
