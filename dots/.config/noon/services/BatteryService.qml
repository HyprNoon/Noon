pragma Singleton
pragma ComponentBehavior: Bound
import qs.common
import Quickshell
import Quickshell.Services.UPower
import QtQuick

Singleton {
    id: root
    property bool available: UPower.displayDevice.isLaptopBattery
    property var chargeState: UPower.displayDevice.state
    property bool isCharging: chargeState === UPowerDeviceState.Charging
    property bool isPluggedIn: isCharging || chargeState == UPowerDeviceState.PendingCharge
    property real percentage: UPower.displayDevice?.percentage ?? 1
    readonly property bool allowAutomaticSuspend: Mem.options.battery.automaticSuspend
    property bool isLow: available && (percentage <= Mem.options.battery.low / 100)
    property bool isCritical: available && (percentage <= Mem.options.battery.critical / 100)
    property bool isSuspending: available && (percentage <= Mem.options.battery.suspend / 100)

    property bool isLowAndNotCharging: isLow && !isCharging
    property bool isCriticalAndNotCharging: isCritical && !isCharging
    property bool isSuspendingAndNotCharging: allowAutomaticSuspend && isSuspending && !isCharging

    property real energyRate: UPower.displayDevice.changeRate
    property real timeToEmpty: UPower.displayDevice.timeToEmpty
    property real timeToFull: UPower.displayDevice.timeToFull
    readonly property string materialIcon: {
        if (!root.available)
            return;
        if (root.isPluggedIn)
            return "electric_bolt";

        const p = root.percentage * 100;
        const prefix = "battery_";

        if (p <= 2)
            return `battery_alert`;
        if (p <= 5)
            return `${prefix}0_bar`;
        if (p <= 14)
            return `${prefix}1_bar`;
        if (p <= 28)
            return `${prefix}2_bar`;
        if (p <= 42)
            return `${prefix}3_bar`;
        if (p <= 56)
            return `${prefix}4_bar`;
        if (p <= 70)
            return `${prefix}5_bar`;
        if (p <= 95)
            return `${prefix}6_bar`;

        return root.isPluggedIn ? "battery_charging_full" : "battery_full";
    }
    Connections {
        target: PowerProfiles
        function onDegradationReasonChanged() {
            const reason = PowerProfiles.degradationReason;
            if (reason === PerformanceDegradationReason.HighTemperature)
                NoonUtils.toast({
                    id: 3,
                    content: "High Temperature",
                    icon: "emergency_heat",
                    status: "warn"
                });
            if (reason === PerformanceDegradationReason.LapDetected)
                NoonUtils.toast({
                    id: 3,
                    content: "Move the laptop away from your body",
                    icon: "heat",
                    status: "warn"
                });
        }
    }

    onIsLowAndNotCharging: if (isLowAndNotCharging)
        NoonUtils.playSound("power_low")
    onIsChargingChanged: if (isCharging) {
        NoonUtils.playSound("power_plugged");
        NoonUtils.toast({
            id: 3,
            content: "Charging",
            icon: "battery_charging_full",
            status: "success"
        });
    } else {
        NoonUtils.playSound("power_unplugged");
        NoonUtils.toast({
            id: 3,
            content: "Discharging",
            icon: "battery_error"
        });
    }
    onIsLowAndNotChargingChanged: {
        if (available && isLowAndNotCharging)
            NoonUtils.toast({
                id: 3,
                content: "Low Battery Plug in your device",
                icon: "battery_error",
                status: "warn"
            });
    }

    onIsCriticalAndNotChargingChanged: {
        if (available && isCriticalAndNotCharging)
            NoonUtils.toast({
                id: 3,
                content: "Critical Battery Percentage",
                icon: "battery_error",
                status: "error"
            });
    }

    onIsSuspendingAndNotChargingChanged: {
        if (available && isSuspendingAndNotCharging) {
            NoonUtils.execDetached(`systemctl suspend`);
        }
    }
}
