import QtQuick
import Quickshell
import Quickshell.Services.Mpris
import qs.common
import qs.common.utils
import qs.common.functions
import "mediaplayer"
import "editor"
import "reader"
import "settings"

IpcHandler {
    id: ipc
    target: "apps"

    function settings() {
        createAppWindow("settings/Settings.qml");
    }

    function pdf() {
        createAppWindow("reader/PDFReader.qml");
    }

    function editor() {
        createAppWindow("editor/Editor.qml");
    }

    function edit(file) {
        Globals.applications.editor.currentFile = file;
        createAppWindow("editor/Editor.qml");
    }

    function media() {
        createAppWindow("mediaplayer/MediaPlayer.qml");
    }

    function createAppWindow(path) {
        var component = Qt.createComponent(Qt.resolvedUrl(path));
        if (component.status === Component.Ready) {
            component.createObject(root);
        } else if (component.status === Component.Error) {
            console.error("Error loading component:", component.errorString());
        }
    }
}
