import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import qs.common
import qs.common.widgets
import qs.services

StyledRect {
    id: root
    property string searchQuery: ""
    property bool expanded: false
    property int editIndex: -1

    signal searchFocusRequested
    signal contentFocusRequested
    signal dismiss
    clip: true
    radius: Rounding.verylarge
    color: Colors.colLayer1
    onContentFocusRequested: list.forceActiveFocus()
    Component.onCompleted: TodoService.removeDone()
    ScrollEdgeFade {
        target: list
        vertical: true
    }

    StyledListView {
        id: list
        hint: false
        anchors.topMargin: Padding.large
        anchors.fill: parent
        clip: true
        highlightFollowsCurrentItem: true
        highlightMoveDuration: 300
        animateAppearance: true
        animateMovement: true
        popin: true
        reuseItems: false
        spacing: Padding.normal
        model: ScriptModel {
            id: filteredModel
            // Handles Duplicates
            values: TodoService.list.filter(task => task?.content.toLowerCase().includes(root.searchQuery.toLowerCase())).filter((task, idx, arr) => arr.findIndex(t => t.content === task.content) === idx)
        }
        delegate: TodoItem {
            required property var modelData
            required property int index
            readonly property bool isSelected: list.focus && index === list.currentIndex
            taskData: modelData
            anchors.right: parent?.right
            anchors.left: parent?.left
        }

        Keys.onPressed: event => {
            // Get based on content
            const selectedItem = TodoService.list.find(item => item.content === filteredModel.values[list.currentIndex].content);
            const selectedItemIndex = TodoService.list.indexOf(selectedItem);
            if (event.modifiers === Qt.ControlModifier && selectedItemIndex > -1) {
                switch (event.key) {
                case Qt.Key_N:
                    addDialog.show = true;
                    event.accepted = true;
                    break;
                case Qt.Key_E:
                    selectedItem.isEditing = !selectedItem.isEditing;
                    event.accepted = true;
                    break;
                case Qt.Key_Right:
                    if (selectedItem.status < 3)
                        TodoService.setStatus(selectedItemIndex, (selectedItem.status + 5) % 4);
                    event.accepted = true;
                    break;
                case Qt.Key_Left:
                    if (selectedItem.status > 0 && selectedItem.status <= 3)
                        TodoService.setStatus(selectedItemIndex, (selectedItem.status + 3) % 4);
                    event.accepted = true;
                    break;
                case Qt.Key_Delete:
                    TodoService.deleteItem(selectedItemIndex);
                    event.accepted = true;
                    break;
                }
            }
            if (event.key === Qt.Key_Slash && root.focus) {
                root.searchFocusRequested();
            } else if (event.key === Qt.Key_Up) {
                if (currentIndex <= 0) {
                    currentIndex = -1;
                    root.searchFocusRequested();
                } else {
                    currentIndex--;
                }
            } else if (event.key === Qt.Key_Down) {
                if (currentIndex < count - 1) {
                    currentIndex++;
                }
            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                if (currentIndex >= 0) {
                    TodoService.setStatus(selectedItemIndex, 3);
                }
            } else if (event.key === Qt.Key_Escape) {
                root.dismiss();
            } else
                return;

            event.accepted = true;
        }
    }

    PagePlaceholder {
        shown: filteredModel.values.length === 0
        anchors.centerIn: parent
        icon: "add_task"
        shape: MaterialShape.Clover8Leaf
        title: "No Current Tasks"
    }

    NewTodoItemDialog {
        id: addDialog
    }
}
