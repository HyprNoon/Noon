pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import qs.common
import qs.common.utils

/*
    Simple Get - Set For System icons
*/
Singleton {
    id: root

    readonly property var availableIconThemes: Mem.store.services.icons.availableIconThemes ?? []
    readonly property var availableIconThemeIds: availableIconThemes.map(theme => theme.id)
    readonly property list<string> baseCmd: ["python3", Directories.scriptsDir + "/icons_service.py"]
    readonly property string currentIconTheme: Mem.options.desktop.icons.currentIconTheme
    onCurrentIconThemeChanged: setIconTheme(currentIconTheme)

    function setIconTheme(id) {
        if (id)
            NoonUtils.execDetached([...baseCmd, "set", id]);
    }

    function reload() {
        if (!fetcher.running)
            fetcher.running = true;
    }

    Fetcher {
        id: fetcher
        running: availableIconThemes.length === 0
        onDataChanged: Mem.store.services.icons.availableIconThemes = data
        command: [...baseCmd, "list"]
    }
}
