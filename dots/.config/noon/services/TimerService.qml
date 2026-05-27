pragma Singleton
pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import qs.common

Singleton {
    id: root

    property var timers: Mem.states.services.timers.timers
    property int nextTimerId: Mem.states.services.timers.nextTimerId

    signal timerFinished(int timerId, string name)
    readonly property list<var> stdPresets: [
        {
            "duration": 1500,
            "icon": "timer",
            "name": "Pomodoro"
        },
        {
            "duration": 300,
            "icon": "coffee",
            "name": "Short Break"
        },
        {
            "duration": 900,
            "icon": "bed",
            "name": "Long Break"
        },
        {
            "duration": 5400,
            "icon": "mindfulness",
            "name": "Deep Work"
        },
        {
            "duration": 1800,
            "icon": "fitness_center",
            "name": "Exercise"
        },
        {
            "duration": 600,
            "icon": "self_improvement",
            "name": "Meditation"
        },
        {
            "duration": 900,
            "icon": "flash_on",
            "name": "Quick Task"
        },
        {
            "duration": 3600,
            "icon": "groups",
            "name": "Meeting"
        }
    ]
    readonly property list<var> presets: [...Mem.options.services.timers.customPresets, ...stdPresets]

    Timer {
        interval: 1000
        repeat: true
        running: timers.some(t => t?.isRunning)
        onTriggered: tick()
    }

    function reload() {
        tick();
    }

    function tick() {
        const now = Date.now();
        const updated = [];
        let changed = false;

        for (let i = 0; i < timers.length; i++) {
            const t = timers[i];
            if (!t.isRunning) {
                updated.push(t);
                continue;
            }

            const elapsed = Math.floor((now - t.startTime) / 1000);
            const remaining = Math.max(0, t.originalDuration - elapsed);

            if (remaining === 0) {
                NoonUtils.playSound("record_stopped");
                NoonUtils.wake(`${t.name} is Done !`);
                timerFinished(t.id, t.name);
                changed = true;
            } else {
                updated.push({
                    id: t.id,
                    name: t.name,
                    originalDuration: t.originalDuration,
                    remainingTime: remaining,
                    isRunning: true,
                    startTime: t.startTime,
                    preset: t.preset,
                    wakeTime: t.wakeTime,
                    icon: t.icon
                });
                changed = true;
            }
        }

        if (changed)
            Mem.states.services.timers.timers = updated;
    }

    function addAndStartTimer(name, duration) {
        const id = addTimer(name, duration, false);
        Qt.callLater(() => startTimer(id));
        return id;
    }

    function addTimer(name, duration, isPreset, autoStart = false, wakeTime = null) {
        const newTimer = {
            id: nextTimerId,
            name: name,
            originalDuration: duration,
            remainingTime: duration,
            isRunning: autoStart,
            startTime: autoStart ? Date.now() : 0,
            preset: isPreset,
            wakeTime: wakeTime,
            icon: root.presets.find(p => p.duration === duration)?.icon ?? (wakeTime ? "alarm" : "timer")
        };
        Mem.states.services.timers.nextTimerId = nextTimerId + 1;
        Mem.states.services.timers.timers = timers.concat([newTimer]);
        if (autoStart)
            NoonUtils.playSound("record_started");
        return newTimer.id;
    }

    function removeTimer(timerId) {
        Mem.states.services.timers.timers = timers.filter(t => t.id !== timerId);
    }

    function startTimer(timerId) {
        Mem.states.services.timers.timers = timers.map(t => {
            if (t.id !== timerId || t.remainingTime <= 0)
                return t;
            return {
                id: t.id,
                name: t.name,
                originalDuration: t.originalDuration,
                remainingTime: t.remainingTime,
                isRunning: true,
                startTime: Date.now() - (t.originalDuration - t.remainingTime) * 1000,
                preset: t.preset,
                wakeTime: t.wakeTime,
                icon: t.icon
            };
        });
        NoonUtils.playSound("record_started");
    }

    function pauseTimer(timerId) {
        Mem.states.services.timers.timers = timers.map(t => {
            if (t.id !== timerId)
                return t;
            let remaining = t.remainingTime;
            if (t.isRunning && t.startTime > 0) {
                remaining = Math.max(0, t.originalDuration - Math.floor((Date.now() - t.startTime) / 1000));
            }
            return {
                id: t.id,
                name: t.name,
                originalDuration: t.originalDuration,
                remainingTime: remaining,
                isRunning: false,
                startTime: 0,
                preset: t.preset,
                wakeTime: t.wakeTime,
                icon: t.icon
            };
        });
    }

    function resetTimer(timerId) {
        Mem.states.services.timers.timers = timers.map(t => {
            if (t.id !== timerId)
                return t;
            return {
                id: t.id,
                name: t.name,
                originalDuration: t.originalDuration,
                remainingTime: t.originalDuration,
                isRunning: false,
                startTime: 0,
                preset: t.preset,
                wakeTime: t.wakeTime,
                icon: t.icon
            };
        });
    }

    function updateTimer(timerId, newDuration) {
        const timer = timers.find(t => t.id === timerId);
        if (!timer)
            return;
        const wasRunning = timer.isRunning;
        if (wasRunning)
            pauseTimer(timerId);
        Mem.states.services.timers.timers = timers.map(t => {
            if (t.id !== timerId)
                return t;
            return {
                id: t.id,
                name: t.name,
                originalDuration: newDuration,
                remainingTime: newDuration,
                isRunning: false,
                startTime: 0,
                preset: t.preset,
                icon: t.icon
            };
        });
        if (wasRunning)
            Qt.callLater(() => startTimer(timerId));
    }

    function formatTime(seconds) {
        const h = Math.floor(seconds / 3600);
        const m = Math.floor((seconds % 3600) / 60);
        const s = seconds % 60;
        return h > 0 ? `${h}:${String(m).padStart(2, '0')}:${String(s).padStart(2, '0')}` : `${m}:${String(s).padStart(2, '0')}`;
    }

    function parseTimeString(input) {
        if (!input)
            return 0;
        input = String(input).trim().toLowerCase();
        const regex = /(\d+)([hms])/g;
        let total = 0, match;
        while ((match = regex.exec(input)) !== null) {
            const val = parseInt(match[1]), unit = match[2];
            if (unit === "h")
                total += val * 3600;
            else if (unit === "m")
                total += val * 60;
            else if (unit === "s")
                total += val;
        }
        if (total === 0 && /^\d+$/.test(input))
            total = parseInt(input) * 60;
        return total;
    }

    function wake(timeStr, name) {
        const target = parseWakeTime(timeStr);
        if (!target || isNaN(target.getTime())) {
            console.warn("TimerService.wake: invalid time string:", timeStr);
            return -1;
        }
        const now = Date.now();
        const duration = Math.max(60, Math.floor((target.getTime() - now) / 1000));
        return addTimer(name || "Wake Alarm", duration, false, true, target.toISOString());
    }

    function formatWakeTime(isoTime) {
        const date = new Date(isoTime);
        const h = date.getHours() % 12 || 12;
        const m = String(date.getMinutes()).padStart(2, '0');
        return `${h}:${m} ${date.getHours() >= 12 ? "PM" : "AM"}`;
    }

    function parseWakeTime(timeStr) {
        if (!timeStr)
            return null;
        const now = new Date();
        let target = new Date();
        const cleaned = String(timeStr).trim().toLowerCase();

        if (cleaned.includes(":")) {
            const isPM = cleaned.includes("pm");
            const isAM = cleaned.includes("am");
            const timeOnly = cleaned.replace(/[ap]m/gi, "").trim();
            const parts = timeOnly.split(":");
            const hours = parseInt(parts[0]);
            const minutes = parts.length > 1 ? parseInt(parts[1]) : 0;
            if (isNaN(hours))
                return null;

            let hour = hours;
            if (isPM && hour !== 12)
                hour += 12;
            if (isAM && hour === 12)
                hour = 0;
            target.setHours(hour, isNaN(minutes) ? 0 : minutes, 0, 0);
            if (target <= now)
                target.setDate(target.getDate() + 1);
            return target;
        }

        return null;
    }

    function formatTimers() {
        if (TimerService.timers.length === 0)
            return "No timers currently";
        let output = "Current timers:\n\n";
        TimerService.timers.forEach(timer => {
            const status = timer.isRunning ? "Running" : "Stopped";
            const remaining = TimerService.formatTime(timer.remainingTime);
            const total = TimerService.formatTime(timer.originalDuration);
            output += `ID: ${timer.id}\n`;
            output += `Name: ${timer.name}\n`;
            output += `Status: ${status}\n`;
            output += `Time: ${remaining} / ${total}\n`;
            output += `Icon: ${timer.icon}\n\n`;
        });
        return output;
    }
}
