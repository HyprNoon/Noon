import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.common
import qs.common.widgets
import qs.services

Rectangle {
    id: root

    required property ListModel taskListModel
    required property int targetStatus
    property string emptyPlaceholderIcon
    property string emptyPlaceholderText
    property alias listView: listView
    property alias shape: placeHolder.shape
    readonly property var itemApp: ({
            [TodoService.Status.Todo]: {
                icon: "radio_button_unchecked",
                bg: Colors.colLayer2,
                col: Colors.colOnLayer1,
                column: todoColumn
            },
            [TodoService.Status.InProgress]: {
                icon: "work_history",
                bg: Colors.colPrimaryContainer,
                col: Colors.colPrimary,
                column: inProgressColumn
            },
            [TodoService.Status.FinalTouches]: {
                icon: "auto_fix_high",
                bg: Colors.colSecondaryContainer,
                col: Colors.colSecondary,
                column: finalTouchesColumn
            },
            [TodoService.Status.Done]: {
                icon: "check_circle",
                bg: Colors.colSurfaceContainerHigh,
                col: Colors.m3.m3success,
                column: doneColumn
            }
        })

    signal editRequested(int index, string currentContent)

    radius: Rounding.verylarge
    color: Colors.colLayer1

    StyledListView {
        id: listView

        animateMovement: true
        popin: false
        anchors.fill: parent
        anchors.margins: Padding.normal
        clip: true
        hint: false
        model: taskListModel
        spacing: Padding.small

        delegate: Item {
            id: delegateItem

            property bool isDragged: false

            width: listView.width
            height: 65

            StyledRect {
                id: todoItemRectangle

                enableBorders: true
                anchors.fill: parent
                radius: Rounding.large
                color: itemApp[model.status].bg
                opacity: delegateItem.isDragged ? 0 : 1

                MouseArea {
                    id: mouseArea

                    property bool dragging: false
                    property point startPos
                    property var draggedItem: null
                    property int oldIndex: -1
                    property var originalModel: null

                    anchors.fill: parent
                    hoverEnabled: true
                    preventStealing: true
                    onPressed: mouse => startPos = Qt.point(mouse.x, mouse.y)
                    onPositionChanged: mouse => {
                        if (dragging) {
                            var globalPos = mapToItem(overlay, mouse.x, mouse.y);
                            draggedItem.x = globalPos.x - draggedItem.width / 2;
                            draggedItem.y = globalPos.y - draggedItem.height / 2;
                            return;
                        }
                        if (!pressed)
                            return;

                        var delta = Qt.point(mouse.x - startPos.x, mouse.y - startPos.y);
                        if (Math.abs(delta.x) > 10 || Math.abs(delta.y) > 10) {
                            dragging = true;
                            delegateItem.isDragged = true;
                            var taskData = {
                                "content": model.content,
                                "status": model.status,
                                "todoistId": model.todoistId || "",
                                "originalIndex": model.originalIndex
                            };
                            var globalPos = mapToItem(overlay, mouse.x, mouse.y);
                            draggedItem = dragTaskComponent.createObject(overlay, {
                                "x": globalPos.x - listView.width / 2,
                                "y": globalPos.y - 60 / 2,
                                "width": listView.width,
                                "height": 60,
                                "color": itemApp[taskData.status].bg,
                                "taskData": taskData,
                                "symbol": itemApp[taskData.status].icon,
                                "colSymbol": itemApp[taskData.status].col
                            });
                        }
                    }
                    onReleased: mouse => {
                        if (dragging && draggedItem) {
                            dragging = false;

                            var centerX = draggedItem.x + draggedItem.width / 2;
                            var centerY = draggedItem.y + draggedItem.height / 2;
                            var targetList = null;

                            for (let i = 0; i <= Object.keys(itemApp).length; i++) {
                                var column = itemApp[i].column;
                                if (isOver(column, centerX, centerY)) {
                                    targetList = column;
                                    break;
                                }
                            }
                            oldIndex = index;
                            originalModel = taskListModel;

                            var taskData = draggedItem.taskData;

                            if (targetList === null) {
                                delegateItem.isDragged = false;
                            } else if (targetList === root) {
                                // same list, reorder
                                var localX = listView.mapFromItem(overlay, centerX, centerY).x;
                                var localY = listView.mapFromItem(overlay, centerX, centerY).y;
                                var dropIndex = listView.indexAt(localX, localY);
                                if (dropIndex === -1) {
                                    dropIndex = listView.count;
                                } else {
                                    var targetItem = listView.itemAt(localX, localY);
                                    if (targetItem && localY > targetItem.y + targetItem.height / 2)
                                        dropIndex++;
                                }
                                if (dropIndex !== index && dropIndex >= 0) {
                                    if (dropIndex > index)
                                        dropIndex--;

                                    taskListModel.move(index, dropIndex, 1);
                                    syncModelsToTodo();
                                }
                                delegateItem.isDragged = false;
                            } else {
                                taskListModel.remove(index);
                                taskData.status = targetList.targetStatus;
                                var localX = targetList.listView.mapFromItem(overlay, centerX, centerY).x;
                                var localY = targetList.listView.mapFromItem(overlay, centerX, centerY).y;
                                var dropIndex = targetList.listView.indexAt(localX, localY);
                                if (dropIndex === -1) {
                                    dropIndex = targetList.taskListModel.count;
                                } else {
                                    var targetItem = targetList.listView.itemAt(localX, localY);
                                    if (targetItem && localY > targetItem.y + targetItem.height / 2)
                                        dropIndex++;
                                }
                                targetList.taskListModel.insert(dropIndex, taskData);
                                syncModelsToTodo();
                            }
                            draggedItem.destroy();
                        }
                    }
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    spacing: 15

                    Symbol {
                        text: itemApp[model.status].icon
                        color: itemApp[model.status].col
                        font.pixelSize: Fonts.sizes.normal
                    }

                    ColumnLayout {
                        Layout.fillWidth: true

                        RowLayout {
                            spacing: 6
                            Layout.fillWidth: true

                            StyledText {
                                width: 180
                                text: model.content
                                Layout.fillWidth: true
                                truncate: true
                                opacity: model.status === TodoService.Status.Done ? 0.7 : 1
                                font.strikeout: model.status === TodoService.Status.Done
                            }

                            Symbol {
                                visible: model.todoistId?.length > 0
                                text: "cloud_done"
                                fill: 1
                                font.pixelSize: 14
                                color: model.todoistId ? Colors.colPrimary : Colors.colOnLayer1
                                opacity: model.todoistId ? 0.5 : 0.3

                                StyledToolTip {
                                    extraVisibleCondition: todoistIndicatorMouse.containsMouse
                                    content: model.todoistId ? "Synced with Todoist" : "Syncing..."
                                }
                                MouseArea {
                                    id: todoistIndicatorMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                }
                            }
                        }

                        StyledText {
                            Layout.fillWidth: true
                            truncate: true
                            text: TodoService.statusNames[model.status]
                            opacity: model.status === TodoService.Status.Done ? 0.3 : 0.45
                            font.pixelSize: 11
                        }
                    }

                    RowLayout {
                        Layout.rightMargin: 15
                        Layout.fillWidth: true

                        TaskButton {
                            releaseAction: () => root.editRequested(model.originalIndex, model.content)
                            hintText: "Edit"
                            materialIcon: "edit"
                        }

                        TaskButton {
                            releaseAction: () => {
                                TodoService.deleteItem(model.originalIndex);
                                updateTaskModels();
                            }
                            hintText: "Delete Task"
                            materialIcon: "delete_forever"
                        }
                    }
                }
            }
        }
    }

    PagePlaceholder {
        id: placeHolder

        visible: taskListModel.count === 0
        opacity: taskListModel.count === 0 ? 1 : 0
        anchors.centerIn: parent
        icon: emptyPlaceholderIcon
        shape: MaterialShape.Clover4Leaf
        title: expanded ? emptyPlaceholderText : ""
    }
}
