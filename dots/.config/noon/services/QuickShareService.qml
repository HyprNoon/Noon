pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import qs.common

Singleton {
    id: root

    // ── Public read-only properties ──────────────────────────────────────────
    readonly property bool backendReady: _s.backendReady
    readonly property bool receiving: _s.receiving
    readonly property string lastError: _s.lastError
    readonly property var discoveredDevices: _s.discoveredDevices
    readonly property real receiveProgress: _s.receiveProgress

    // Populated once the backend starts advertising.
    readonly property QtObject receiveInfo: _receiveInfo

    QtObject {
        id: _receiveInfo
        property string endpointName: ""
        property string ip: ""
        property int port: 0
        property string qrData: ""
        property string authToken: ""

        readonly property bool valid: ip !== "" && port > 0
    }

    // Populated when an incoming transfer request arrives and cleared on accept/reject.
    readonly property QtObject pendingTransfer: _pendingTransfer

    QtObject {
        id: _pendingTransfer
        property string pin: ""
        // true while we are waiting for user to accept or reject
        readonly property bool active: pin !== ""
    }

    // ── Signals ──────────────────────────────────────────────────────────────
    signal transferRequest(string pin)
    signal transferComplete(var files, string outputDir)
    signal transferRejected
    signal sendComplete(string fileName)
    signal deviceFound(int index, string name, string category)
    signal discoverDone(int total)
    signal error(string message)
    signal receiveInfoReady

    // ── Public API ───────────────────────────────────────────────────────────
    function startReceiving(outputDir) {
        _cmd({
            cmd: "startReceiving",
            outputDir: outputDir || ""
        });
    }

    function stopReceiving() {
        _clearReceiveInfo();
        _cmd({
            cmd: "stopReceiving"
        });
    }

    function acceptTransfer() {
        _pendingTransfer.pin = "";
        _cmd({
            cmd: "acceptTransfer"
        });
    }

    function rejectTransfer() {
        _pendingTransfer.pin = "";
        _cmd({
            cmd: "rejectTransfer"
        });
    }

    function sendFile(deviceIndex, path) {
        _cmd({
            cmd: "sendFile",
            deviceIndex: deviceIndex,
            path: path
        });
    }

    function discoverDevices() {
        _s.discoveredDevices = [];
        _cmd({
            cmd: "discoverDevices"
        });
    }

    function ping() {
        _cmd({
            cmd: "ping"
        });
    }

    // ── Internal helpers ─────────────────────────────────────────────────────
    function _cmd(obj) {
        if (!_proc.running) {
            console.warn("QuickShare: backend not running");
            return;
        }
        _proc.write(JSON.stringify(obj) + "\n");
    }

    function _clearReceiveInfo() {
        _receiveInfo.endpointName = "";
        _receiveInfo.ip = "";
        _receiveInfo.port = 0;
        _receiveInfo.qrData = "";
        _receiveInfo.authToken = "";
    }

    function _onEvent(raw) {
        var o;
        try {
            o = JSON.parse(raw);
        } catch (e) {
            return;
        }

        switch (o.event) {
        case "ready":
            _s.backendReady = true;
            break;
        case "receiving":
            _s.receiving = true;
            _receiveInfo.endpointName = o.endpointName || "";
            _receiveInfo.ip = o.ip || "";
            _receiveInfo.port = o.port || 0;
            _receiveInfo.authToken = o.authToken || "";
            if (o.qrData) {
                _receiveInfo.qrData = o.qrData;
            } else if (_receiveInfo.ip && _receiveInfo.port) {
                var name = encodeURIComponent(_receiveInfo.endpointName);
                _receiveInfo.qrData = "nearby://" + _receiveInfo.ip + ":" + _receiveInfo.port + (name ? "?name=" + name : "");
            }
            if (_receiveInfo.valid)
                root.receiveInfoReady();
            break;
        case "stopped":
            _s.receiving = false;
            _pendingTransfer.pin = "";
            _clearReceiveInfo();
            break;
        case "transferRequest":
            _pendingTransfer.pin = o.pin || "";
            root.transferRequest(o.pin || "");
            break;
        case "transferComplete":
            _s.receiveProgress = 1.0;
            root.transferComplete(o.files || [], o.outputDir || "");
            break;
        case "transferRejected":
            root.transferRejected();
            break;
        case "receiveProgress":
            _s.receiveProgress = o.progress !== undefined ? o.progress : -1;
            break;
        case "deviceFound":
            var devs = _s.discoveredDevices.slice();
            devs.push({
                index: o.index,
                name: o.name,
                category: o.category || "unknown"
            });
            _s.discoveredDevices = devs;
            root.deviceFound(o.index, o.name || "", o.category || "unknown");
            break;
        case "discoverDone":
            root.discoverDone(o.total || 0);
            break;
        case "error":
            _s.lastError = o.message || "";
            root.error(_s.lastError);
            break;
        case "pong":
            break;
        default:
            console.warn("QuickShare: unknown event:", o.event);
            break;
        }
    }

    // ── Private state ────────────────────────────────────────────────────────
    QtObject {
        id: _s
        property bool backendReady: false
        property bool receiving: false
        property string lastError: ""
        property var discoveredDevices: []
        property real receiveProgress: -1
    }

    // ── Backend process ──────────────────────────────────────────────────────
    Process {
        id: _proc
        readonly property string scriptPath: Directories.scriptsDir + "/pyquickshare_service.py"
        command: ["uv", "--directory", Directories.venv, "run", scriptPath]
        running: true
        stdinEnabled: true

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: line => root._onEvent(line.trim())
        }
        stderr: SplitParser {
            splitMarker: "\n"
            onRead: line => console.log("[qs]", line)
        }
        onExited: code => {
            _s.backendReady = false;
            _s.receiving = false;
            _pendingTransfer.pin = "";
            _clearReceiveInfo();
            if (code !== 0)
                _restart.restart();
        }
    }

    Timer {
        id: _restart
        interval: 3000
        onTriggered: _proc.running = true
    }
}
