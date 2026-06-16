import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.functions
import qs.common.utils
import qs.common.widgets
import Qt.labs.folderlistmodel

Item {
    id: root
    property string currentPath: Globals.applications.reader.currentPath
    property alias model: itemsModel

    anchors {
        fill: parent
        margins: Padding.normal
    }

    function getIcon(path) {
        if (!path)
            return "docs";
        const ext = "*." + FileUtils.getEscapedFileExtension(path).toLowerCase();
        switch (ext) {
        case "*.pdf":
            return "picture_as_pdf";
        default:
            return "docs";
        }
    }

    StyledListView {
        id: listView
        anchors.fill: parent
        radius: Rounding.verylarge
        clip: true
        model: root.model
        delegate: StyledDelegateItem {
            expanded: Mem.states.applications.reader.sidebar_expanded
            required property var modelData
            property var index
            active: modelData.filePath === Mem.states.applications.reader.currentFile
            shape: MaterialShape.Shape.ClamShell
            title: modelData.fileName
            subtext: modelData.filePath
            materialIcon: root.getIcon(subtext)
            releaseAction: () => {
                Mem.states.applications.reader.currentFile = modelData.filePath;
            }
            altAction: () => {
                contextMenu.popup();
            }
            PDFReaderContextMenu {
                id: contextMenu
                fileData: modelData
            }
        }
    }
    FolderListModel {
        id: itemsModel
        folder: root.currentPath
        nameFilters: NameFilters.document
        showDirs: false
        showFiles: true
        sortField: FolderListModel.Name
    }
}
