pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import qs.common

Singleton {
    id: root
    readonly property var cursors: Mem.store.services.cursors?.availableCursors ?? []

    function reload() {
        if (!getProc.running) {
            Mem.store.services.cursors.availableCursors = [];
            getProc.running = true;
        }
    }

    Process {
        id: getProc
        running: Mem.store.services.cursors.availableCursors.length === 0
        command: ["bash", "-c", Directories.scriptsDir + "/get_cursors.sh"]
        stdout: SplitParser {
            onRead: line => {
                var current = Mem.store.services.cursors.availableCursors;
                current.push(line);
                Mem.store.services.cursors.availableCursors = current;
            }
        }
    }
}
