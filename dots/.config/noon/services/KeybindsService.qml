pragma Singleton
pragma ComponentBehavior: Bound
import qs.common
import qs.common.functions
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property var store: Mem.store.services.cheats
    readonly property var shellKeybinds: store.shellKeybinds[0]
    readonly property var defaultKeybinds: store.defaultKeybinds[0]
    readonly property var keybinds: ({
            children: [
                {
                    children: (shellKeybinds?.children ?? []).reduce((a, c) => a.concat(c.children ?? []), [])
                },
                {
                    children: (defaultKeybinds?.children ?? []).reduce((a, c) => a.concat(c.children ?? []), [])
                }
            ]
        })

    function reload() {
        getShellKeybinds.running = true;
        getDefaultKeybinds.running = true;
    }

    function applyKeybinds(data, storeKey) {
        try {
            var parsed = JSON.parse(data);
            store[storeKey] = Array.isArray(parsed) ? parsed[0] : parsed;
        } catch (e) {
            console.error(`[Cheats] Error parsing ${storeKey}:`, e);
        }
    }

    Process {
        id: getShellKeybinds
        running: store.shellKeybinds.length === 0
        command: ["python", FileUtils.trimFileProtocol(`${Directories.scriptsDir}/keybinds_service.py`), "--path", FileUtils.trimFileProtocol(`${Directories.shellDir}/hypr/qs_binds.conf`)]
        onStarted: console.log("[Cheats]: Pulling Binds")
        stdout: SplitParser {
            onRead: data => root.applyKeybinds(data, "shellKeybinds")
        }
    }

    Process {
        id: getDefaultKeybinds
        running: true
        command: ["python", FileUtils.trimFileProtocol(`${Directories.scriptsDir}/keybinds_service.py`), "--path", FileUtils.trimFileProtocol(`${Directories.shellDir}/hypr/binds.conf`)]
        stdout: SplitParser {
            onRead: data => root.applyKeybinds(data, "defaultKeybinds")
        }
    }
}
