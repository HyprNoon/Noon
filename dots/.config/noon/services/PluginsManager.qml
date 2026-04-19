pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Qt.labs.platform
import qs.common
import qs.common.utils
import qs.common.functions
import qs.store

Singleton {
    id: root

    property string selectedLocation: ""
    readonly property bool enablePlugins: true
    readonly property alias sidebarPlugins: sidebar?.plugins
    readonly property alias dockPlugins: dock?.plugins
    readonly property alias beamPlugins: beam?.plugins
    readonly property list<string> plugins: allPlugins.map(plugin => plugin.group)
    readonly property var allPlugins: [
        {
            group: "sidebar",
            data: PluginsManager.sidebarPlugins
        },
        {
            group: "dock",
            data: PluginsManager.dockPlugins
        },
        {
            group: "beam",
            data: PluginsManager.beamPlugins
        }
    ]

    PluginExtractor {
        id: dock
        group: "dock"
    }

    PluginExtractor {
        id: beam
        group: "beam"
        onPluginsChanged: BeamData.buildPlugins()
    }

    PluginExtractor {
        id: sidebar
        group: "sidebar"
        onPluginsChanged: SidebarData.rebuildAll()
    }
    function select() {
        selectionDialog.open();
    }
    function selectAndInstall() {
        selectionDialog.open();
        selectionDialog.onAccepted.connect(() => {
            install();
        });
    }

    function disable(group, name) {
        actionProc.command = [Directories.scriptsDir + "/plugins_helper.sh", "disable", group, name];
        actionProc.running = true;
    }
    function enable(group, name) {
        actionProc.command = [Directories.scriptsDir + "/plugins_helper.sh", "enable", group, name];
        actionProc.running = true;
    }
    function install(zip = root.selectedLocation) {
        actionProc.command = [Directories.scriptsDir + "/plugins_helper.sh", "install", zip];
        actionProc.running = true;
    }
    function remove(group, name) {
        actionProc.command = [Directories.scriptsDir + "/plugins_helper.sh", "remove", group, name];
        actionProc.running = true;
    }

    function action(plugin, action) {
        if (!plugin)
            return;
        actionProc.command = [Directories.scriptsDir + "/plugins_helper.sh", action, plugin];
        actionProc.running = true;
    }

    FileDialog {
        id: selectionDialog
        title: "Select Plugin Dir"
        nameFilters: ["*.zip *.tar.gz *.tar", "All files (*)"]
        onAccepted: {
            root.selectedLocation = FileUtils.trimFileProtocol(currentFile);
            NoonUtils.callIpc("sidebar reveal Plugins");
        }
    }

    Process {
        id: actionProc
        onStarted: console.log(command.join())
        onExited: NoonUtils.callIpc("plugins reload")
    }

    IpcHandler {
        target: "plugins"
        function reload(): void {
            dock.refresh();
            sidebar.refresh();
            beam.refresh();
        }
    }
}
