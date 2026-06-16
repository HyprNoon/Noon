pragma Singleton
import QtQuick
import qs.common
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property var entries: []
    readonly property string cacheDir: Directories.services.clipboardCache
    function refresh() {
        if (!listProcess.running)
            listProcess.running = true;
    }

    function copyByIndex(index) {
        if (index < 0 || index >= entries.length)
            return;
        NoonUtils.execDetached(`cliphist decode '${root.entries[index].id}' | wl-copy`);
    }

    function copy(text) {
        if (text)
            NoonUtils.execDetached(["wl-copy", text]);
    }

    function deleteEntry(index) {
        if (index < 0 || index >= entries.length)
            return;
        NoonUtils.execDetached(["cliphist", "delete", entries[index].id]);
    }

    function wipe() {
        NoonUtils.execDetached(["cliphist", "wipe"]);
    }

    function isImage(index) {
        const entry = entries[index];
        if (entry)
            return entry.isImage ?? false;
    }

    function getImagePath(entry) {
        if (entry && entry.isImage && entry.imagePath)
            return entry.imagePath;
        return "";
    }

    function ensureImageCache() {
        var ids = [];
        for (var i = 0; i < root.entries.length; i++) {
            if (root.entries[i].isImage)
                ids.push(root.entries[i].id);
        }
        if (ids.length === 0)
            return;

        var cmds = ids.map(function(id) {
            return `test -f ${root.cacheDir}/${id}.png || cliphist decode '${id}' > ${root.cacheDir}/${id}.png`;
        });
        NoonUtils.execDetached(["bash", "-c",
            "mkdir -p " + root.cacheDir + ";" + cmds.join(";")
        ]);
    }

    Process {
        id: listProcess
        command: ["cliphist", "list"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                var raw = listProcess.stdout.text.trim();
                var list = [];
                if (raw.length > 0) {
                    var lines = raw.split('\n');
                    for (var i = 0; i < lines.length; i++) {
                        var line = lines[i];
                        var tabIdx = line.indexOf('\t');
                        var id = tabIdx >= 0 ? line.substring(0, tabIdx).trim() : line.trim();
                        var text = tabIdx >= 0 ? line.substring(tabIdx + 1) : "";
                        list.push({
                            id: id,
                            index: i,
                            text: text,
                            isImage: text.startsWith("[["),
                            imagePath: text.startsWith("[[") ? root.cacheDir + '/' + id + '.png' : ""
                        });
                    }
                }
                root.entries = list;
                root.ensureImageCache();
            }
        }
    }

    FileView {
        path: Directories.standard.home + "/.cache/cliphist/db"
        watchChanges: true
        onFileChanged: root.refresh()
        Component.onCompleted: root.refresh()
    }
}
