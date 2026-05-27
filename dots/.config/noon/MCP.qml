import QtQuick
import Quickshell
import Quickshell.Services.Mpris
import qs.common
import qs.common.utils
import qs.common.functions
import qs.common.widgets
import qs.services
import qs.store

/*
    Contains Some Ipc helpers for the skills set to work
*/

IpcHandler {
    target: "ai"

    // Create timer with duration in minutes , name and shall it autostart
    function create_timer(duration: int, name: string, autoStart: bool) {
        TimerService.addTimer(name, duration, false, true);
    }
    // Create new todo item with name task state [0:todo,1:wip,2:final touches,3:done] and due data in ("d/M")
    function add_task(taskName: string, taskState: string, state: int, date: string) {
        TodoService.addTask(taskName, state, date);
    }
}
