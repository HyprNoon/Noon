import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import Qt5Compat.GraphicalEffects
import Qt.labs.folderlistmodel
import qs.common
import qs.common.widgets
import qs.common.utils
import qs.store

Item {
    id: canvas
    z: 99999

    property var dragLeader: null

    function beginGroupDrag(leader) {
        canvas.dragLeader = leader;
        for (var i = 0; i < rep.count; i++) {
            var it = rep.itemAt(i);
            if (it && it !== leader && it.selected)
                it.captureOffsetFromLeader(leader);
        }
    }

    function endGroupDrag() {
        canvas.dragLeader = null;
    }

    FolderListModel {
        id: appsModel
        folder: Directories.standard.home + "/Desktop"
        nameFilters: ["*.desktop"]
        showDirs: false
        showFiles: true
        sortField: {
            switch (root.sortMode) {
            case 1:
                return FolderListModel.Name;
            case 2:
                return FolderListModel.Time;
            case 3:
                return FolderListModel.Type;
            default:
                return FolderListModel.Name;
            }
        }
    }

    function refresh() {
        appsModel.folder = "";
        appsModel.folder = Directories.standard.home + "/Desktop";
    }

    function deselectAll() {
        for (var i = 0; i < rep.count; i++) {
            var it = rep.itemAt(i);
            if (it)
                it.selected = false;
        }
    }

    function updateRubberSelection() {
        for (var i = 0; i < rep.count; i++) {
            var it = rep.itemAt(i);
            if (it)
                it.selected = root.iconInRubber(it.x, it.y);
        }
    }

    MouseArea {
        id: bgMouse
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        preventStealing: true

        onPressed: function (mouse) {
            if (mouse.button === Qt.RightButton)
                return;
            canvas.deselectAll();
            root.rubberX1 = mouse.x;
            root.rubberY1 = mouse.y;
            root.rubberX2 = mouse.x;
            root.rubberY2 = mouse.y;
            root.rubberActive = true;
        }

        onPositionChanged: function (mouse) {
            if (!root.rubberActive)
                return;
            root.rubberX2 = mouse.x;
            root.rubberY2 = mouse.y;
            canvas.updateRubberSelection();
        }

        onReleased: function (mouse) {
            if (mouse.button === Qt.RightButton)
                return;
            root.rubberActive = false;
        }

        onClicked: function (mouse) {
            if (mouse.button === Qt.RightButton)
                contextMenu.popup();
        }
    }

    Rectangle {
        visible: root.rubberActive
        x: root.rubberLeft
        y: root.rubberTop
        width: root.rubberRight - root.rubberLeft
        height: root.rubberBottom - root.rubberTop
        color: Colors.t(Colors.colSecondaryContainer, 0.7)
        border.color: Colors.colSecondary
        border.width: 1
        radius: 3
        z: 99998
    }

    DesktopTrashIcon {
        id: trashIcon
        x: canvas.width - width - 10
        y: canvas.height - height - 10
        z: 100
        iconSize: root.iconSize
        iconW: root.iconW
        iconH: root.iconH
        iconPad: root.iconPad
        labelSize: root.labelSize
        labelWidth: root.labelWidth
        labelLines: root.labelLines
        externalHovered: root.trashHovered
    }

    DesktopContextMenu {
        id: contextMenu
        onRefreshRequested: canvas.refresh()
        onSnapAllRequested: root.snapAllToGrid()
        onArrangeRequested: root.arrangeIcons()
    }

    Repeater {
        id: rep
        model: appsModel
        delegate: DesktopIcon {}
    }
}
