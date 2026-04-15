pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.common
import qs.common.widgets
import qs.common.utils
import qs.common.functions
import qs.services

/*
    For now lets pretend manifest alr inside the folder and each one is viable
*/
Singleton {
    id: root

    property var sidebarPlugins: {}
    onSidebarPluginsChanged: console.log(JSON.stringify(sidebarPlugins))
    Process {
        id: getSidebarPluginsProc
        running: true
        command: ["bash", Directories.scriptsDir + "/plugins_helper.sh", Directories.plugins.sidebar.toString().replace("file://", ""), "list"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.sidebarPlugins = JSON.parse(text.trim());
                } catch (e) {
                    console.warn("[Plugins] Failed to parse:", e, "\nRaw:", text);
                }
            }
        }
    }
}
