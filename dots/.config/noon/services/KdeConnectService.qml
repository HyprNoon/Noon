pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import qs.common
import qs.common.utils
import QtQuick

Singleton {
    id: root

    enum State {
        Unreachable,
        Reachable,
        Paired
    }

    property var devices: []
    property bool isRefreshing: false
    property bool daemonRunning: false

    readonly property string selectedDeviceId: Mem.states.services?.kdeconnect?.selectedDeviceId

    signal error(string message)

    FilePicker {
        id: filePicker
        title: "Select file to share via KDE Connect"
        multipleSelection: true
        fileFilters: [filePicker.filterPresets.ALL]

        onFileSelected: files => {
            if (!root.selectedDeviceId) {
                root.error("No device selected");
                return;
            }
            const arr = Array.isArray(files) ? files : [files];
            arr.forEach(f => root._run(["--device", root.selectedDeviceId, "--share", f]));
        }
        onError: msg => root.error(msg)
    }

    property var _queue: []
    property var _current: null

    function _run(args, onSuccess, onFailure) {
        _queue.push({
            args,
            onSuccess: onSuccess ?? null,
            onFailure: onFailure ?? null
        });
        if (!_proc.running)
            _next();
    }

    function _next() {
        if (_queue.length === 0)
            return;
        _current = _queue.shift();
        _proc._out = "";
        _proc._err = "";
        _proc.command = ["kdeconnect-cli"].concat(_current.args);
        _proc.running = true;
    }

    function _parseDevices(output) {
        if (!output?.trim())
            return [];
        return output.split('\n').filter(l => l.startsWith('- ')).map(l => {
            const m = l.match(/^-\s+(.+):\s+([a-f0-9]+)\s+\((.+)\)$/);
            if (!m)
                return null;
            const s = m[3];
            const state = s.includes("paired and reachable") ? KdeConnectService.State.Paired : s.includes("reachable") ? KdeConnectService.State.Reachable : KdeConnectService.State.Unreachable;
            return {
                id: m[2],
                name: m[1],
                state
            };
        }).filter(Boolean);
    }

    Process {
        id: _proc

        property string _out: ""
        property string _err: ""

        running: false

        stdout: SplitParser {
            onRead: line => _proc._out += line + "\n"
        }
        stderr: SplitParser {
            onRead: line => _proc._err += line + "\n"
        }

        onExited: (code, _status) => {
            const cb = root._current;
            root._current = null;
            if (code === 0) {
                cb?.onSuccess?.(_out.trim());
            } else {
                const msg = _err.trim();
                cb?.onFailure?.(msg);
                if (msg)
                    root.error(msg);
            }
            root._next();
        }
    }

    function refresh() {
        if (isRefreshing)
            return;
        isRefreshing = true;
        _run(["-l"], out => {
            isRefreshing = false;
            daemonRunning = true;
            devices = _parseDevices(out);
        }, () => {
            isRefreshing = false;
            daemonRunning = false;
        });
    }

    function getDevice(deviceId) {
        return devices.find(d => d.id === deviceId) ?? null;
    }

    function selectDevice(deviceId) {
        Mem.states.services.kdeconnect.selectedDeviceId = deviceId;
    }

    function pairDevice(deviceId) {
        if (!deviceId) {
            error("Device ID is required");
            return;
        }
        _run(["--device", deviceId, "--pair"], () => refresh());
    }

    function unpairDevice(deviceId) {
        if (!deviceId) {
            error("Device ID is required");
            return;
        }
        _run(["--device", deviceId, "--unpair"], () => refresh());
    }

    function ringDevice(deviceId) {
        const id = deviceId ?? selectedDeviceId;
        if (!id) {
            error("No device selected");
            return;
        }
        _run(["--device", id, "--ring"]);
    }

    function shareFile(path, deviceId) {
        const id = deviceId ?? selectedDeviceId;
        if (!id) {
            error("No device selected");
            return;
        }
        if (!path) {
            filePicker.open();
        } else {
            _run(["--device", id, "--share", path]);
            NoonUtils.toast({
                id: 8,
                content: "Sharing..",
                icon: "share"
            });
        }
    }

    function sendClipboard(deviceId) {
        const id = deviceId ?? selectedDeviceId;
        if (!id) {
            error("No device selected");
            return;
        }
        _run(["--device", id, "--send-clipboard"]);
    }
}
