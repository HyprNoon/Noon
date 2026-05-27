pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import qs.common
import qs.common.utils

Singleton {
    id: root

    readonly property string folderPath: Directories.standard.documents + "/Notes/"
    property string fileName: Mem.states.services.notes?.currentFile ?? "noon_notes.md"
    property string filePath: folderPath + fileName
    property string content: ""
    property bool isDirty: false
    property string lastSaved: ""
    property bool isLoaded: false
    property string _pendingNote: ""

    FileView {
        id: noteFile
        path: root.filePath

        onLoaded: {
            root.content = noteFile.text();
            root.isDirty = false;
            root.isLoaded = true;
            if (root._pendingNote)
                root.note(root._pendingNote);
        }

        onLoadFailed: error => {
            if (error == FileViewError.FileNotFound) {
                root.content = "";
                root.isLoaded = true;
                save();
            }
        }

        onSaved: {
            root.isDirty = false;
            root.lastSaved = new Date().toISOString();
        }
    }

    function createNote(name) {
        if (!name?.trim())
            return;
        openNote(name.trim());
        root.content = "";
        root.isLoaded = false;
        root.isDirty = false;
        noteFile.setText("");
        noteFile.reload();
    }

    function openNote(name) {
        if (name)
            Mem.states.services.notes.currentFile = name.trim();
    }

    function save() {
        noteFile.setText(root.content);
    }

    function note(text) {
        if (!text?.trim())
            return;
        if (!root.isLoaded) {
            root._pendingNote = text;
            noteFile.reload();
            return;
        }
        root.content += text.trim() + "\n";
        root.isDirty = true;
        save();
    }

    Component.onCompleted: noteFile.reload()
}
