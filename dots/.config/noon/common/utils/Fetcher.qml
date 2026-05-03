import QtQuick
import Quickshell
import Quickshell.Io

Process {
    id: root
    property var data: null
    running: true
    stdout: StdioCollector {
        onStreamFinished: {
            const out = text.trim();
            try {
                root.data = JSON.parse(out);
            } catch (e) {
                console.error(e);
            }
        }
    }
}
