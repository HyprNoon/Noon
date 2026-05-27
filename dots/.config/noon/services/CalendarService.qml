pragma Singleton
pragma ComponentBehavior: Bound
import qs.common
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property var list: store.events
    readonly property var store: Mem.todo
    readonly property bool useGoogleCalendar: false

    Component.onCompleted: Qt.callLater(pull)

    function addEvent(desc, start, time, duration = 60, end = start) {
        store.events.push({
            content: desc,
            start: start,
            end: end,
            time: time,
            duration: duration
        });
        Qt.callLater(push);
    }

    function editEvent(index, newContent) {
        if (index < 0 || !newContent)
            return;
        store.events[index].content = newContent.trim();
        Qt.callLater(push);
    }

    function deleteEvent(index) {
        if (index >= 0 && index < list.length) {
            store.events.splice(index, 1).slice(0);
            Qt.callLater(push);
        }
    }

    function getEventsByDate(date) {
        return list.filter(e => e.start === date);
    }

    function formatEvents() {
        if (!list || list.length === 0)
            return "No Upcoming Events";
        let output = "Upcoming events:\n\n";
        list.forEach((event, i) => {
            output += `${i}. ${event.content} — ${event.start} ${event.time} (${event.duration}min)\n`;
        });
        return output;
    }

    function push() {
        if (useGoogleCalendar)
            _cmd("push");
    }
    function pull() {
        if (useGoogleCalendar)
            _cmd("pull");
    }

    function _cmd(action) {
        if (mainProc.running)
            mainProc.running = false;
        mainProc.command = ["uv", "--directory", Directories.venv, "run", Directories.scriptsDir + "/gcalendar_service.py", action];
        mainProc.running = true;
    }

    Process {
        id: mainProc
        onStarted: console.log(JSON.stringify("CALENDAR", mainProc.environment))
        stdout: StdioCollector {
            onStreamFinished: console.log("CALENDAR", text)
        }
        environment: {
            "NOON_CALENDAR_ID": AuthManager.integrations.calendar.authId,
            "NOON_CALENDAR_SECRET": AuthManager.integrations.calendar.secret
        }
    }
}
