pragma Singleton
pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import qs.common

Singleton {
    id: root

    property var alarms: Mem.states.services.timers.alarms
    property bool hasAlarms: alarms.length > 0
    property int timeUntilNext: getTimeUntil()

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: {
            checkAlarms();
            root.timeUntilNext = root.getTimeUntil();
        }
    }

    function checkAlarms() {
        const now = new Date();
        const updated = [];
        let changed = false;

        for (let i = 0; i < alarms.length; i++) {
            const alarm = alarms[i];
            const alarmTime = new Date(alarm.time);

            if (alarm.active && !alarm.ringed && now >= alarmTime) {
                updated.push({
                    time: alarm.time,
                    message: alarm.message,
                    active: alarm.active,
                    ringed: true,
                    remindInterval: alarm.remindInterval,
                    lastRemind: now.toISOString()
                });
                NoonUtils.wake(alarm.message);
                changed = true;
            } else if (alarm.ringed && alarm.remindInterval) {
                const lastRemind = new Date(alarm.lastRemind || alarm.time);
                const elapsed = Math.floor((now - lastRemind) / 1000);
                if (elapsed >= alarm.remindInterval) {
                    updated.push({
                        time: alarm.time,
                        message: alarm.message,
                        active: alarm.active,
                        ringed: true,
                        remindInterval: alarm.remindInterval,
                        lastRemind: now.toISOString()
                    });
                    NoonUtils.wake(alarm.message);
                    changed = true;
                } else {
                    updated.push(alarm);
                }
            } else {
                updated.push(alarm);
            }
        }

        if (changed) {
            Mem.states.services.timers.alarms = updated;
        }
    }

    function addTimer(timeStr, message, remindInterval) {
        const alarmTime = parseTimeString(timeStr);
        if (!alarmTime) {
            console.error("Invalid time string:", timeStr);
            return;
        }

        const newAlarm = {
            time: alarmTime.toISOString(),
            message: message || "Alarm",
            active: true,
            ringed: false,
            remindInterval: remindInterval || null,
            lastRemind: null
        };

        Mem.states.services.timers.alarms = alarms.concat([newAlarm]);
    }

    function toggleAlarm(index, setActive) {
        const updated = alarms.map((a, idx) => {
            if (idx !== index)
                return a;
            return {
                time: a.time,
                message: a.message,
                active: setActive,
                ringed: a.ringed,
                remindInterval: a.remindInterval,
                lastRemind: a.lastRemind
            };
        });
        Mem.states.services.timers.alarms = updated;
    }

    function removeAlarm(index) {
        Mem.states.services.timers.alarms = alarms.filter((a, idx) => idx !== index);
    }

    function clearAll() {
        Mem.states.services.timers.alarms = [];
    }

    function parseTimeString(timeStr) {
        if (!timeStr)
            return null;

        const now = new Date();
        let alarmTime = new Date();

        if (timeStr.includes("T") || timeStr.includes("-")) {
            alarmTime = new Date(timeStr);
        } else if (timeStr.includes(":")) {
            const isPM = timeStr.toLowerCase().includes("pm");
            const isAM = timeStr.toLowerCase().includes("am");
            const timeOnly = timeStr.replace(/[ap]m/gi, "").trim();
            const [hours, minutes] = timeOnly.split(":").map(Number);
            let hour = hours;
            if (isPM && hour !== 12)
                hour += 12;
            if (isAM && hour === 12)
                hour = 0;
            alarmTime.setHours(hour, minutes || 0, 0, 0);
            if (alarmTime <= now) {
                alarmTime.setDate(alarmTime.getDate() + 1);
            }
        } else if (/^\d+$/.test(timeStr)) {
            const minutes = parseInt(timeStr);
            alarmTime = new Date(now.getTime() + minutes * 60000);
        } else {
            const regex = /(\d+)([hms])/g;
            let totalMs = 0;
            let match;
            while ((match = regex.exec(timeStr)) !== null) {
                const value = parseInt(match[1]);
                const unit = match[2];
                if (unit === "h")
                    totalMs += value * 3600000;
                else if (unit === "m")
                    totalMs += value * 60000;
                else if (unit === "s")
                    totalMs += value * 1000;
            }
            if (totalMs > 0) {
                alarmTime = new Date(now.getTime() + totalMs);
            } else {
                return null;
            }
        }

        return alarmTime;
    }

    function formatTime(isoTime) {
        const date = new Date(isoTime);
        const h = date.getHours() % 12 || 12;
        const m = date.getMinutes() < 10 ? "0" + date.getMinutes() : date.getMinutes();
        return `${h}:${m} ${date.getHours() >= 12 ? "PM" : "AM"}`;
    }

    function getTimeUntil() {
        const now = new Date();
        const active = alarms.filter(a => a.active && !a.ringed && new Date(a.time) > now);
        if (active.length === 0)
            return -1;
        const next = active.reduce((n, a) => {
            return new Date(a.time) < new Date(n.time) ? a : n;
        });
        return Math.floor((new Date(next.time) - now) / 1000);
    }

    function formatUntil(seconds) {
        if (seconds < 0)
            return "Passed";
        if (seconds < 60)
            return `${seconds}s`;
        const min = Math.floor(seconds / 60);
        if (min < 60)
            return `${min}min`;
        return `${Math.floor(min / 60)}h ${min % 60}min`;
    }

    function reload() {
        root.alarmsChanged();
        root.timeUntilNext = root.getTimeUntil();
    }

    function describeAlarms() {
        if (alarms.length === 0)
            return "No alarms set.";
        let text = "Alarms:\n";
        for (let i = 0; i < alarms.length; i++) {
            const a = alarms[i];
            const active = a.active ? "Active" : "Inactive";
            const ringed = a.ringed ? " (Rung)" : "";
            text += `${i + 1}. ${formatTime(a.time)}: ${a.message} (${active}${ringed})\n`;
        }
        if (timeUntilNext >= 0) {
            text += `\nNext alarm in: ${formatUntil(timeUntilNext)}`;
        }
        return text;
    }
}
