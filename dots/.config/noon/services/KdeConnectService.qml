pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Io
import Qt.labs.platform

import qs.common
import qs.common.utils
import qs.common.widgets
import qs.common.functions

Singleton {
    id: root

    readonly property int selectedDeviceIndex: Mem.states.services.kdeconnect.selectedDeviceIndex ?? 0
    readonly property var devices: store.connectedDevices
    readonly property var store: Mem.states.services.kdeconnect
    readonly property var selectedDeviceName: store.connectedDevices[selectedDeviceIndex]?.name ?? ""
    readonly property int selectedDeviceId: store.connectedDevices[selectedDeviceIndex]?.id ?? -1
    readonly property list<string> baseCmd: ["kdeconnect-cli", "--device"]

    function _cmdD(id, ...args) {
        const cmd = [...baseCmd, id, ...args];
        NoonUtils.execDetached(cmd);
        console.log(cmd);
    }

    function spitErr(msg, stat = "error") {
        NoonUtils.toast({
            id: 2,
            title: "KDE Connect",
            message: msg,
            icon: "phone",
            status: stat
        });
    }

    function _cmd(id, ...args) {
        mainProc.running = false;
        mainProc.command = [...baseCmd, id, ...args];
        mainProc.running = true;
    }

    function sendFiles(id, files) {
        if (!files)
            return;

        const rawList = Array.from(files);
        const deviceName = root.devices.find(d => d.id === id)?.name ?? "";

        for (const file of rawList) {
            const cleanPath = FileUtils.trimFileProtocol(file);
            _cmdD(id, "--share", cleanPath);
        }

        NoonUtils.toast({
            id: 2,
            title: "KDE Connect",
            icon: "phone",
            message: "Sending to " + deviceName
        });
    }

    function getDevices() {
        if (!devicesFetcher.running)
            devicesFetcher.running = true;
    }

    function shareFiles(id) {
        if (!id)
            return;
        filePickerDialog.device = id;
        filePickerDialog.open();
    }

    function ringDevice(id) {
        if (id)
            _cmdD(id, ["--ring"]);
    }

    function sendClipboard(id) {
        if (id)
            _cmdD(id, ["--send-clipboard"]);
    }

    Process {
        id: devicesFetcher
        command: ["kdeconnect-cli", "--list-devices", "--id-name-only"]
        stdout: SplitParser {
            onRead: line => {
                var devices = [];
                const parts = line.trim().split(' ');
                devices.push({
                    id: parts[0],
                    name: parts[1]
                });
                root.store.connectedDevices = devices;
            }
        }
    }

    FileDialog {
        id: filePickerDialog
        title: "Select files to send"
        fileMode: FileDialog.OpenFiles
        property string device: ""

        onAccepted: {
            if (!device) {
                root.spitErr("No device given");
                return;
            }
            root.sendFiles(device, filePickerDialog.files);
        }
        onRejected: console.log("File selection canceled")
    }
}
