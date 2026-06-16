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
    property var queue: Globals.applications.mediaplayer.queue
    property string path: Qt.resolvedUrl(Directories.standard.videos)
    property bool expanded: false
    property var model: queue.length > 0 ? queue : itemsModel
    anchors {
        fill: parent
        margins: Padding.normal
    }
    signal play(var filePath)

    function getIcon(path) {
        if (!path)
            return "play_arrow";

        const ext = "*." + FileUtils.getEscapedFileExtension(path).toLowerCase();

        if (NameFilters.picture.indexOf(ext) !== -1) {
            return "image";
        } else if (NameFilters.video.indexOf(ext) !== -1) {
            return "play_arrow";
        } else if (NameFilters.audio.indexOf(ext) !== -1) {
            return "music_note";
        }
        return "play_arrow";
    }

    StyledListView {
        id: listView
        anchors.fill: parent
        model: root.model
        clip: true
        radius: Rounding.verylarge
        delegate: StyledDelegateItem {
            expanded: root.expanded
            required property var modelData
            property var index
            shape: MaterialShape.Shape.Bun
            title: modelData?.fileName || encodeURIComponent(FileUtils.getEscapedFileNameWithoutExtension(modelData))
            subtext: modelData?.filePath || modelData
            materialIcon: root.getIcon(subtext)
            releaseAction: () => {
                root.play(modelData.filePath);
            }
        }
    }
    FolderListModel {
        id: itemsModel
        folder: root.path
        nameFilters: NameFilters.video.concat(NameFilters.audio)
        showDirs: false
        showFiles: true
        sortField: FolderListModel.Name
    }
}
