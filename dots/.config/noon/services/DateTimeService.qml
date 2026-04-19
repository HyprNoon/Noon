pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import qs.common
import qs.common.utils

Singleton {
    id: root
    property string uptime: "0h, 0m"
    readonly property string date: request("dddd, dd/MM")
    readonly property string day: request("dd")
    readonly property string month: request("MMMM")
    readonly property string year: request("yyyy")
    readonly property string minute: request("mm")
    readonly property alias clock: clock
    readonly property bool twelveHour: Mem.options.services.time.use12HourFormat
    readonly property string time: twelveHour ? request("hh:mm ap") : request("HH:mm")
    readonly property string hour: twelveHour ? request("hh AP").split(" ")[0] : request("HH")
    readonly property string dayTime: twelveHour ? request("hh AP").split(" ")[1] : ""
    readonly property string collapsedCalendarFormat: request("dd MMMM yyyy")
    readonly property string arabicDayName: clock.date.toLocaleDateString(Qt.locale("ar_SA"), "dddd")
    readonly property string gnome_format: twelveHour ? request("hh:mm ap") : request("HH:mm")

    function request(format) {
        if (format)
            return Qt.formatDateTime(clock.date, format);
    }

    function getRelativeTime(timestamp) {
        var now = new Date();
        var savedTime = new Date(timestamp);
        var diff = Math.floor((now - savedTime) / 1000); // difference in seconds

        if (diff < 60) {
            return diff + "s ago";
        } else if (diff < 3600) {
            return Math.floor(diff / 60) + "m ago";
        } else if (diff < 86400) {
            return Math.floor(diff / 3600) + "h ago";
        } else {
            // More than a day, show the date
            return Qt.formatDate(savedTime, "MMM d, yyyy");
        }
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Timer {
        id: uptimeRefresh
        interval: 60000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            fileUptime.reload();
            const textUptime = fileUptime.text();
            const uptimeSeconds = parseFloat(textUptime.split(" ")[0]) || 0;

            const days = Math.floor(uptimeSeconds / 86400);
            const hours = Math.floor((uptimeSeconds % 86400) / 3600);
            const minutes = Math.floor((uptimeSeconds % 3600) / 60);

            let parts = [];
            if (days > 0)
                parts.push(`${days}d`);
            if (hours > 0)
                parts.push(`${hours}h`);

            if (minutes > 0 || parts.length === 0)
                parts.push(`${minutes}m`);

            uptime = parts.join(", ");
        }
    }

    FileView {
        id: fileUptime
        path: "/proc/uptime"
    }
}
