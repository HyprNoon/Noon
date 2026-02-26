import qs.common
import qs.services

QuickToggleButton {
    dialogName: "Bluetooth"
    toggled: BluetoothService.available > 0
    buttonIcon: BluetoothService.currentDeviceIcon
    buttonName: BluetoothService.filterConnectedDevices(BluetoothService.pairedDevices).length > 0 ? (BluetoothService.filterConnectedDevices(BluetoothService.pairedDevices)[0].name || "Connected") : "Bluetooth"
    buttonSubtext: BluetoothService.enabled ? "Enabled" : "Disabled"
    onClicked: BluetoothService.togglePower()
}
