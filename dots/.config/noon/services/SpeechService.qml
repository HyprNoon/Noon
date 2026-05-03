pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import qs.services
import qs.common
import qs.common.functions
import qs.common.utils

Singleton {
    id: root
    readonly property var opts: optsView.data
    readonly property bool isListening: mainProc.running
    property string speech: ""

    function listen() {
        speech = "";
        _cmd(false, "--stt");
    }

    function say(text: string) {
        if (!text)
            return;
        _cmd(false, text);
    }

    function _cmd(detached, ...args) {
        if (!args.length)
            return;
        mainProc.command = ["uv", "--directory", Directories.venv, "run", Directories.scriptsDir + "/speech_service.py", "--config", FileUtils.trimFileProtocol(optsView.filePath), ...args];
        if (detached) {
            mainProc.startDetached();
        } else {
            mainProc.running = false;
            mainProc.running = true;
        }
    }

    Component.onCompleted: {
        _cmd(true, "--tts-load");
    }

    Process {
        id: mainProc
        stdout: SplitParser {
            onRead: line => {
                const cleanedLine = line.split(',')[1];
                root.speech += cleanedLine + "\n";
            }
        }
    }

    ConfigFileView {
        id: optsView
        fileName: "tts_config"
        state: false

        JsonAdapter {
            property string model: ""
            property string device: ""
            property real volume: 1
            property string whisper_model: "base"
            property string language: "en"
        }
    }
}
