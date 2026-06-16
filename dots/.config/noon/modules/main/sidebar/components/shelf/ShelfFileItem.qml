import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.utils
import qs.common.widgets
import qs.common.functions
import qs.services
import qs.store

StyledRect {
    id: root
    property bool showPreview: false
    property string path
    property bool isOnline: path.toString().startsWith("https:") || path.startsWith("http:")
    property string icon: getIcon(path)
    color: Colors.colLayer2
    radius: Rounding.large
    border.color: eventArea.drag.active ? Colors.colPrimary : "transparent"
    border.width: 2
    function getIcon(path) {
        if (!path)
            return "draft";

        const ext = "*." + FileUtils.getEscapedFileExtension(path).toLowerCase();

        if (NameFilters.picture.indexOf(ext) !== -1) {
            return "image";
        } else if (NameFilters.video.indexOf(ext) !== -1) {
            return "play_arrow";
        } else if (NameFilters.audio.indexOf(ext) !== -1) {
            return "music_note";
        } else if (NameFilters.document.indexOf(ext) !== -1) {
            return "docs";
        } else if (NameFilters.archive.indexOf(ext) !== -1) {
            return "archive";
        } else if (path.startsWith("https:") || path.startsWith("http:")) {
            return "globe";
        }
        return "draft";
    }

    GridLayout {
        anchors.centerIn: parent
        columns: 1
        Loader {
            Layout.alignment: Qt.AlignHCenter
            sourceComponent: root.isOnline ? favIconComponent : symbolComponent

            Component {
                id: symbolComponent
                Symbol {
                    id: symbol
                    text: root.icon
                    fill: eventArea.drag.active ? 0 : 1
                    font.pixelSize: 32
                    Layout.alignment: Qt.AlignHCenter
                }
            }
            Component {
                id: favIconComponent
                Favicon {
                    displayText: title.text
                    url: root.path
                }
            }
        }
        StyledText {
            id: title
            text: {
                if (root.isOnline) {
                    StringUtils.getDomain(root.path);
                } else
                    decodeURIComponent(FileUtils.getEscapedFileNameWithoutExtension(root.path));
            }
            color: Colors.colOnLayer2
            font.pixelSize: Fonts.sizes.small
            elide: Text.ElideRight
            wrapMode: Text.Wrap
            maximumLineCount: 2
            Layout.fillWidth: true
            Layout.maximumWidth: root.width - Padding.verysmall
            horizontalAlignment: Text.AlignHCenter
        }
    }

    MouseArea {
        id: eventArea
        anchors.fill: parent
        drag.target: dragProxy
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        hoverEnabled: true
        onEntered: showPreview.restart()
        onExited: {
            showPreview.stop();
            root.showPreview = false;
        }
        onPressed: event => {
            switch (event.button) {
            case Qt.LeftButton:
                dragProxy.Drag.mimeData = {
                    "text/uri-list": path
                };
                break;
            case Qt.RightButton:
                contextMenu.popup();
                break;
            }
        }

        onReleased: {
            dragProxy.Drag.drop();
            dragProxy.x = 0;
            dragProxy.y = 0;
        }
    }
    Timer {
        id: showPreview
        interval: Mem.options.sidebar.shelf.previewDelay
        onTriggered: root.showPreview = true
    }
    ShelfPreviewArea {
        type: root.icon
        path: root.path
        extraVisibleCondition: root.showPreview && supportedPreviews.includes(type) && eventArea.containsMouse && path.length > 0
    }
    Rectangle {
        id: dragProxy
        width: 60
        height: 60
        color: Colors.colPrimary
        radius: Rounding.small
        opacity: 0.7
        visible: eventArea.drag.active

        Drag.active: eventArea.drag.active
        Drag.supportedActions: Qt.CopyAction | Qt.MoveAction
        Drag.dragType: Drag.Automatic

        Symbol {
            text: root.icon
            anchors.centerIn: parent
            font.pixelSize: 28
            color: Colors.colOnPrimary
        }
    }
    StyledMenu {
        id: contextMenu
        content: [
            {
                "text": "Open",
                "materialIcon": "open_in_new",
                "action": () => {
                    NoonUtils.openFile(path);
                    if (!Globals.main.sidebar.pinned) {
                        NoonUtils.callIpc("sidebar hide");
                    }
                }
            },
            {
                "visible": root.isOnline && Mem.options.sidebar.content.web,
                "text": "Open In Sidebar",
                "materialIcon": "globe",
                "action": () => {
                    NoonUtils.setSidebarUrl(path);
                    NoonUtils.callIpc("sidebar reveal Web");
                }
            },
            {
                "visible": root.isOnline,
                "text": "Save in Notes",
                "materialIcon": "stylus",
                "action": () => {
                    NotesService.note(path + " \n---");
                    NoonUtils.callIpc("sidebar reveal Notes");
                }
            },
            {
                "text": "Forget",
                "materialIcon": "delete",
                "action": () => {
                    if (root.index !== undefined) {
                        Mem.states.sidebar.shelf.filePaths.splice(root.index, 1);
                    }
                }
            },
            {
                "text": "Download With Dlp",
                "materialIcon": "download",
                "visible": NoonUtils.checkIfDlp(root.path),
                "action": () => {
                    NoonUtils.runDownloader(path);
                    if (!Globals.main.sidebar.pinned) {
                        NoonUtils.callIpc("sidebar hide");
                    }
                }
            },
        ]
    }
}
