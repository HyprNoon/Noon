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
    readonly property var store: Mem.todo
    readonly property var statusNames: ["Not Started", "In Progress", "Final Touches", "Finished"]
    readonly property var statusLabels: ["todo", "in_progress", "final_touches", "done"]
    readonly property bool useGoogleTasks: false
    Component.onCompleted: Qt.callLater(pull)

    function _extractTags(text) {
        var tags = [];
        var cleaned = text.replace(/#(\w+)/g, function(_, tag) {
            if (tags.indexOf(tag) === -1)
                tags.push(tag);
            return "";
        });
        return { tags: tags, content: cleaned.replace(/\s+/g, " ").trim() };
    }

    function _insertTask(desc, status, date, children, tags) {
        return {
            content: desc,
            status: status,
            due: date,
            children: children || [],
            tags: tags || []
        };
    }

    function addTask(desc, status = TodoService.Status.Todo, date = DateTimeService.request("d/M"), children = []) {
        var trimmed = desc.trim();
        if (trimmed.length === 0)
            return;
        var parsed = _extractTags(trimmed);
        var cleanDesc = parsed.content;
        var tags = parsed.tags;
        var updated = store.tasks.slice();
        var match = cleanDesc.match(/\[([0-9]+)-([0-9]+)\]/);
        if (match) {
            var start = parseInt(match[1], 10);
            var end = parseInt(match[2], 10);
            for (var i = start; i <= end; i++) {
                updated.push(_insertTask(cleanDesc.replace(/\[[0-9]+-[0-9]+\]/, i), status, date, children, tags));
            }
        } else {
            updated.push(_insertTask(cleanDesc, status, date, children, tags));
        }
        store.tasks = updated;
        Qt.callLater(push);
    }

    function editItem(index, newContent) {
        if (index < 0 || index >= store.tasks.length || !newContent)
            return;
        var parsed = _extractTags(newContent);
        store.tasks[index].content = parsed.content;
        store.tasks[index].tags = parsed.tags;
        Qt.callLater(push);
    }

    function setStatus(index, status) {
        if (index < 0 || index >= store.tasks.length || status < 0)
            return;
        store.tasks[index].status = status;
        Qt.callLater(push);
    }

    function nextStatus(index) {
        if (index > -1 && index < list.length && list[index].status < TodoService.Status.Done) {
            setStatus(index, list[index].status + 1);
        }
    }

    function previousStatus(index) {
        if (index > -1 && index < list.length && list[index].status > TodoService.Status.Todo) {
            setStatus(index, list[index].status - 1);
        }
    }

    function deleteItem(index) {
        if (index < 0 || index >= store.tasks.length)
            return;
        var updated = store.tasks.slice();
        updated.splice(index, 1);
        store.tasks = updated;
        Qt.callLater(push);
    }

    function removeDone() {
        store.tasks = store.tasks.filter(item => item.status !== TodoService.Status.Done);
    }

    function getTasksByStatus(status) {
        return list.filter(item => item.status === status);
    }

    function getTasksByTag(tag) {
        return list.filter(item => item.tags && item.tags.indexOf(tag) !== -1);
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
                    var tagStr = task.tags && task.tags.length > 0 ? " [" + task.tags.join(", ") + "]" : "";
                    output += `${list.indexOf(task)}. ${task.content}${tagStr}\n`;
                });
                output += "\n";
            }
        }
        return output;
    }

    function push() {
        if (useGoogleTasks)
            _cmd("push");
    }

    function pull() {
        if (useGoogleTasks)
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
