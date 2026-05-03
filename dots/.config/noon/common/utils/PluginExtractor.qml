import QtQuick
import Quickshell
import qs.common
import qs.common.widgets
import qs.common.functions
import qs.services
import qs.store

Process {
    id: root
    property var plugins
    required property string group

    function refresh() {
        running = false;
        running = true;
    }

    running: PluginsManager?.enablePlugins
    command: ["bash", Directories.scriptsDir + "/plugins_helper.sh", "list", group]
    stdout: StdioCollector {
        onStreamFinished: {
            try {
                root.plugins = JSON.parse(text.trim());
            } catch (e) {
                console.warn("[Plugins] Failed to parse:", e, "\nRaw:", text);
            }
        }
    }
}
