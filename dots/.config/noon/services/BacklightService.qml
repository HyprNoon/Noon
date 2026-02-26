pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import qs.common

Singleton {
    id: root
    readonly property string deviceName: Mem.options.services.backlightDevice
    property int currentLevel: -1
    property int maxLevel: -1

    Component.onCompleted: getProc.running = true

    Process {
        id: getAllProc
        command: ["brightnessctl", "-l", "-m"]

        stdout: SplitParser {
            onRead: data => {
                let lines = data.trim().split('\n');
                let deviceList = [];

                lines.forEach(line => {
                    let parts = line.split(',');
                    if (parts.length >= 5) {
                        deviceList.push({
                            "name": parts[0],
                            "type": parts[1],
                            "current": parseInt(parts[2]),
                            "max": parseInt(parts[4])
                        });
                    }
                });

                Mem.store.services.backlight.devices = deviceList;
            }
        }
    }

    Process {
        id: getProc
        command: ["brightnessctl", "-d", deviceName, "-m"]
        stdout: SplitParser {
            onRead: data => {
                maxLevel = parseInt(data.trim().split(',')[4]);
                currentLevel = parseInt(data.trim().split(',')[2]);
            }
        }
    }

    Process {
        id: setProc
        property int level: -1
        command: ["brightnessctl", "-m", "-d", deviceName, "set", level.toString()]
        stdout: SplitParser {
            onRead: data => {
                currentLevel = data.trim().split(',')[2];
            }
        }
    }

    function refreshDevices() {
        getAllProc.running = true;
    }

    function get() {
        getProc.running = true;
    }

    function set(level) {
        setProc.level = level;
        setProc.running = true;
    }

    function cycle() {
        let nextLevel = (currentLevel + 1) % (maxLevel + 1);
        set(nextLevel);
    }

    function getMaterialIcon() {
        switch (currentLevel) {
        case 0:
            return "backlight_high_off";
        case 1:
            return "backlight_low";
        case 2:
            return "backlight_high";
        default:
            return "backlight_high";
        }
    }
}
