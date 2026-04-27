pragma Singleton
pragma ComponentBehavior: Bound
import qs.common
import Quickshell
import Quickshell.Io
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
    Component.onCompleted: loadFromConfig()

    function saveToConfig() {
        Mem.states.services.todo.tasks = root.list;
        debounceSync.restart();
    }

    function loadFromConfig() {
        const saved = Mem.states.services.todo.tasks;
        if (saved.length > 0 && saved[0].hasOwnProperty('done')) {
            root.list = saved.map(item => ({
                        content: item.content,
                        status: item.done ? status_done : status_todo,
                        due: item.due ?? -1
                    }));
            saveToConfig();
        } else {
            root.list = saved;
        }
    }

    function addTask(desc, status = status_todo, date = -1) {
        list.push({
            content: desc,
            status: status,
            due: date
        });
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
        if (index >= 0 && index < list.length && list[index].status < status_done)
            setStatus(index, list[index].status + 1);
    }

    function previousStatus(index) {
        if (index >= 0 && index < list.length && list[index].status > status_todo)
            setStatus(index, list[index].status - 1);
    }

    function deleteItem(index) {
        if (index >= 0 && index < list.length) {
            list.splice(index, 1);
            root.list = list.slice(0);
            saveToConfig();
            NoonUtils.playSound("task_completed");
        }
    }

    function removeDone() {
        root.list = list.filter(item => item.status !== status_done);
        saveToConfig();
    }

    function getTasksByStatus(status) {
        return list.filter(item => item.status === status);
    }

    function getProgress() {
        return list.length === 0 ? 0 : list.filter(i => i.status === status_done).length / list.length;
    }

    function formatTasks() {
        if (!list || list.length === 0)
            return "No tasks currently";
        let output = "Current tasks:\n\n";
        for (let s = status_todo; s <= status_done; s++) {
            const tasks = getTasksByStatus(s);
            if (tasks.length > 0) {
                output += `## ${statusNames[s]} (${tasks.length})\n`;
                tasks.forEach(task => {
                    output += `${list.indexOf(task)}. ${task.content}\n`;
                });
                output += "\n";
            }
        }
        return output;
    }

    Timer {
        id: debounceSync
        interval: 1000
        onTriggered: {
            syncProc.running = true;
        }
    }
    Process {
        id: syncProc
        command: ["uv", "--directory", Directories.venv, "run", Directories.scriptsDir + "/gtasks_sync.py"]
        onStarted: console.log(command.join(" "))
    }
}
