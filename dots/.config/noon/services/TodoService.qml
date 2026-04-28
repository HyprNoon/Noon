pragma Singleton
pragma ComponentBehavior: Bound
import qs.common
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    enum Status {
        Todo,
        InProgress,
        FinalTouches,
        Done
    }

    readonly property var list: store.tasks
    readonly property var store: Mem.states.services.todo
    readonly property var statusNames: ["Not Started", "In Progress", "Final Touches", "Finished"]
    readonly property var statusLabels: ["todo", "in_progress", "final_touches", "done"]

    Component.onCompleted: Qt.callLater(pull)

    function addTask(desc, status = TodoService.Status.Todo, date = DateTimeService.request("d/M"), children = []) {
        store.tasks.push({
            content: desc,
            status: status,
            due: date,
            children: []
        });
        Qt.callLater(push);
    }

    function editItem(index, newContent) {
        if (!index || index < 0 || !newContent)
            return;
        store.tasks[index].content = newContent.trim();
        Qt.callLater(push);
    }

    function setStatus(index, status) {
        if (!index || index < 0 || status < 0)
            return;
        store.tasks[index].status = status;
        Qt.callLater(push);
    }

    function nextStatus(index) {
        if (index >= 0 && index < list.length && list[index].status < TodoService.Status.Done) {
            setStatus(index, list[index].status + 1);
        }
    }

    function previousStatus(index) {
        if (index >= 0 && index < list.length && list[index].status > TodoService.Status.Todo) {
            setStatus(index, list[index].status - 1);
        }
    }

    function deleteItem(index) {
        if (index >= 0 && index < list.length) {
            store.tasks.splice(index, 1).slice(0);
            Qt.callLater(push);
        }
    }

    function removeDone() {
        store.tasks = store.tasks.filter(item => item.status !== TodoService.Status.Done);
    }

    function getTasksByStatus(status) {
        return list.filter(item => item.status === status);
    }

    function getProgress() {
        return list.filter(i => i.status === TodoService.Status.Done).length / list.length;
    }

    function formatTasks() {
        if (!list || list.length === 0)
            return "No Current Tasks";
        let output = "Current tasks:\n\n";
        for (let s = TodoService.Status.Todo; s <= TodoService.Status.Done; s++) {
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

    function push() {
        _cmd("push");
    }

    function pull() {
        _cmd("pull");
    }

    function _cmd(action) {
        if (mainProc.running)
            mainProc.running = false;
        mainProc.command = ["uv", "--directory", Directories.venv, "run", Directories.scriptsDir + "/gtasks_sync.py", action];
        mainProc.running = true;
    }

    Process {
        id: mainProc
    }
}
