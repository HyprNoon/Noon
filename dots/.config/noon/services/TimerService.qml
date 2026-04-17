pragma Singleton
pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import qs.common

Singleton {
    id: root

    // Direct binding to JsonAdapter
    property var timers: Mem.states.services.timers.timers
    property int nextTimerId: Mem.states.services.timers.nextTimerId

    signal timerFinished(int timerId, string name)

    readonly property list<var> presets: [
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
    function reload() {
        tick();
    }

    function tick() {
        const now = Date.now();
        const updated = [];
        let changed = false;

        for (let i = 0; i < timers.length; i++) {
            const timer = timers[i];
            if (!timer.isRunning) {
                updated.push(timer);
                continue;
            }

            const elapsed = Math.floor((now - timer.startTime) / 1000);
            const remaining = Math.max(0, timer.originalDuration - elapsed);

            if (remaining === 0) {
                NoonUtils.playSound("record_stopped");
                NoonUtils.toast(`'Timer Complete , ${timer.name} finished!'`, "timer", "success");
                timerFinished(timer.id, timer.name);
                changed = true;
            } else {
                updated.push({
                    id: timer.id,
                    name: timer.name,
                    originalDuration: timer.originalDuration,
                    remainingTime: remaining,
                    isRunning: true,
                    startTime: timer.startTime,
                    preset: timer.preset,
                    icon: timer.icon
                });
                changed = true;
            }
        }

        if (changed) {
            Mem.states.services.timers.timers = updated;
        }
    }
    function addAndStartTimer(name, duration) {
        const id = addTimer(name, duration, false);
        Qt.callLater(() => startTimer(id));
        return id;
    }
    function addTimer(name: string, duration: int, isPreset: bool, autoStart = false) {
        const newTimer = {
            id: nextTimerId,
            name: name,
            originalDuration: duration,
            remainingTime: duration,
            isRunning: autoStart,
            startTime: autoStart ? Date.now() : 0,
            preset: isPreset,
            icon: root.presets.find(p => p.duration === duration)?.icon ?? "timer"
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
        const updated = timers.map(t => {
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
                icon: t.icon
            };
        });

        Mem.states.services.timers.timers = updated;
        NoonUtils.playSound("record_started");
    }

    function pauseTimer(timerId) {
        const updated = timers.map(t => {
            if (t.id !== timerId)
                return t;

            let remaining = t.remainingTime;
            if (t.isRunning && t.startTime > 0) {
                const elapsed = Math.floor((Date.now() - t.startTime) / 1000);
                remaining = Math.max(0, t.originalDuration - elapsed);
            }

            return {
                id: t.id,
                name: t.name,
                originalDuration: t.originalDuration,
                remainingTime: remaining,
                isRunning: false,
                startTime: 0,
                preset: t.preset,
                icon: t.icon
            };
        });

        Mem.states.services.timers.timers = updated;
    }

    function resetTimer(timerId) {
        const updated = timers.map(t => {
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
                icon: t.icon
            };
        });

        Mem.states.services.timers.timers = updated;
    }

    function updateTimer(timerId, newDuration) {
        const timer = timers.find(t => t.id === timerId);
        if (!timer)
            return;

        const wasRunning = timer.isRunning;
        if (wasRunning)
            pauseTimer(timerId);

        const updated = timers.map(t => {
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

        Mem.states.services.timers.timers = updated;
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
        let total = 0;
        let match;

        while ((match = regex.exec(input)) !== null) {
            const val = parseInt(match[1]);
            const unit = match[2];
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
    Timer {
        interval: 1000
        repeat: true
        running: timers.some(t => t?.isRunning)
        onTriggered: tick()
    }

    // Ai Helpers
    function formatTimers() {
        if (TimerService.timers.length === 0) {
            return "No timers currently";
        }

        let output = "Current timers:\n\n";

        TimerService.timers.forEach(timer => {
            const status = timer.isRunning ? "Running" : timer.isPaused ? "Paused" : "Stopped";

            const remaining = TimerService.formatTime(timer.remainingTime);
            const total = TimerService.formatTime(timer.originalDuration);
            const progress = (total - remaining) / total;

            output += `ID: ${timer.id}\n`;
            output += `Name: ${timer.name}\n`;
            output += `Status: ${status}\n`;
            output += `Time: ${remaining} / ${total} (${progress}% complete)\n`;
            output += `Icon: ${timer.icon}\n`;
            output += `\n`;
        });

        return output;
    }
}
