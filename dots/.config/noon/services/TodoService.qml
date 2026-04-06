pragma Singleton
pragma ComponentBehavior: Bound
import qs.common
import Quickshell
import Quickshell.Hyprland
import Qt.labs.platform
import QtQuick

Singleton {
    id: root

    property var list: []

    readonly property int status_todo: 0
    readonly property int status_in_progress: 1
    readonly property int status_final_touches: 2
    readonly property int status_done: 3
    readonly property int status_all: 4
    readonly property var statusNames: ["Not Started", "In Progress", "Final Touches", "Finished"]
    readonly property var statusLabels: ["todo", "in_progress", "final_touches", "done"]

    function saveToConfig() {
        Mem.states.services.todo.tasks = root.list;
    }

    function loadFromConfig() {
        const savedTasks = Mem.states.services.todo.tasks;
        if (savedTasks.length > 0 && savedTasks[0].hasOwnProperty('done')) {
            root.list = migrateOldFormat(savedTasks);
            saveToConfig();
        } else {
            root.list = savedTasks;
        }
    }

    function removeDone() {
        list = list.filter(item => item.status !== status_done);
    }

    function addTask(desc, status = status_todo, date = -1) {
        const newTask = {
            content: desc,
            status: status,
            due: date
        };
        list.push(newTask);
        root.list = list.slice(0);
        saveToConfig();
        NoonUtils.playSound("task_added");
    }

    function editItem(index, newContent) {
        if (index >= 0 && index < list.length && newContent.trim() !== "") {
            list[index].content = newContent.trim();
            root.list = list.slice(0);
            saveToConfig();
            return true;
        }
        return false;
    }

    function setStatus(index, status) {
        if (index >= 0 && index < list.length && status >= status_todo && status <= status_done) {
            list[index].status = status;
            root.list = list.slice(0);
            saveToConfig();
        }
    }

    function nextStatus(index) {
        if (index >= 0 && index < list.length) {
            const currentStatus = list[index].status;
            if (currentStatus < status_done)
                setStatus(index, currentStatus + 1);
        }
    }

    function previousStatus(index) {
        if (index >= 0 && index < list.length) {
            const currentStatus = list[index].status;
            if (currentStatus > status_todo)
                setStatus(index, currentStatus - 1);
        }
    }

    function deleteItem(index) {
        if (index >= 0 && index < list.length) {
            list.splice(index, 1);
            root.list = list.slice(0);
            saveToConfig();
            NoonUtils.playSound("task_completed");
        }
    }

    function refresh() {
        loadFromConfig();
    }

    function getStatusName(status) {
        return statusNames[status] || "Unknown";
    }

    function getTasksByStatus(status) {
        return list.filter(item => item.status === status);
    }

    function getTaskCount() {
        return list.length;
    }

    function getTaskCountByStatus(status) {
        return list.filter(item => item.status === status).length;
    }

    function getProgress() {
        return list.length === 0 ? 0 : getTaskCountByStatus(status_done) / list.length;
    }

    function getItemContent(index) {
        return index >= 0 && index < list.length ? list[index].content : "";
    }

    function getItemStatus(index) {
        return index >= 0 && index < list.length ? list[index].status : status_todo;
    }

    function migrateOldFormat(oldList) {
        return oldList.map(item => {
            if (item.hasOwnProperty('done')) {
                return {
                    content: item.content,
                    status: item.done ? status_done : status_todo
                };
            }
            return {
                content: item.content,
                status: item.status ?? status_todo
            };
        });
    }

    function formatTasks() {
        if (!TodoService.list || TodoService.list.length === 0) {
            return "No tasks currently";
        }

        let output = "Current tasks:\n\n";

        for (let status = TodoService.status_todo; status <= TodoService.status_done; status++) {
            const tasks = TodoService.getTasksByStatus(status);
            if (tasks.length > 0) {
                output += `## ${TodoService.getStatusName(status)} (${tasks.length})\n`;
                tasks.forEach((task, idx) => {
                    const globalIndex = TodoService.list.indexOf(task);
                    output += `${globalIndex}. ${task.content}\n`;
                });
                output += "\n";
            }
        }

        return output;
    }

    Component.onCompleted: {
        loadFromConfig();
    }
}
