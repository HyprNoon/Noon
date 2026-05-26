import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.common.utils
import qs.services
import Qt.labs.folderlistmodel

Item {
    id: moviesPage

    property alias currentIndex: grid.currentIndex
    property alias count: grid.count

    readonly property int columns: Math.max(2, Math.floor(width / 200))

    StyledGridView {
        id: grid
        anchors.fill: parent
        anchors.margins: Padding.massive
        cellWidth: 200
        cellHeight: 260
        clip: true
        currentIndex: -1

        model: FolderListModel {
            id: folderModel
            showDirs: false
            showFiles: true
            nameFilters: NameFilters.video
            folder: Qt.resolvedUrl(Directories.standard.videos)
        }

        delegate: MovieItem {
            required property var modelData
            required property int index

            isSelected: grid.currentIndex === index
            implicitWidth: 200
            implicitHeight: 260
        }

        StyledText {
            anchors.centerIn: parent
            text: "No movies found"
            font.pixelSize: Fonts.sizes.normal
            font.family: Fonts.family.variable
            color: Colors.colOnSurfaceVariant
            visible: grid.count === 0
        }
    }
}
