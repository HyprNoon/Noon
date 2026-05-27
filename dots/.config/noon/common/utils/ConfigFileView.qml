import QtQuick
import Quickshell
import Quickshell.Io
import qs.common

FileView {
    id: root

    property string fileName
    property bool state: true
    property string parentDir: ""
    readonly property alias data: root.adapter
    readonly property Timer reloadTimer: Timer {
        interval: 20
        onTriggered: root.reload()
    }

    signal contentChanged

    preload: true
    printErrors: true
    watchChanges: true

    path: {
        const parent = state ? Directories.standard.state : Directories.shellConfigs;
        return parent + "/" + parentDir + fileName + ".json";
    }

    onFileChanged: {
        contentChanged();
        reloadTimer.restart();
    }

    onAdapterUpdated: {
        root.writeAdapter();
        contentChanged();
    }

    onLoadFailed: error => {
        if (error === FileViewError.FileNotFound)
            root.writeAdapter();
    }
    adapter: children[0] ?? null
}
