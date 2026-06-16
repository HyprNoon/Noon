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
    property string currentPath: Globals.applications.editor.currentPath
    property bool expanded: false
    property alias model: itemsModel

    anchors {
        fill: parent
        margins: Padding.normal
    }

    signal edit(var filePath)

    function getIcon(path) {
        if (!path)
            return "draft";
            const ext = "*." + FileUtils.getEscapedFileExtension(path).toLowerCase();
            switch (ext) {
                case "*.json":
                return "data_object";
                default:
                    return "draft"
            }
    }

    StyledListView {
        id: listView
        anchors.fill: parent
        radius: Rounding.verylarge
        clip: true
        model: root.model
        delegate: StyledDelegateItem {
            expanded: root.expanded
            required property var modelData
            property var index
            shape: MaterialShape.Shape.Cookie8Sided
            title: modelData.fileName
            subtext: modelData.filePath
            materialIcon: root.getIcon(subtext)
            releaseAction: () => {
                root.edit(modelData.filePath);
            }
        }
    }
    FolderListModel {
        id: itemsModel
        folder: root.currentPath
        nameFilters: NameFilters.code
        showDirs: false
        showFiles: true
        sortField: FolderListModel.Name
    }
}
