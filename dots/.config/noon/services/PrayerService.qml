pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.common

Singleton {
    id: root

    property string prayerLocation: Mem.options.services.location ?? "Cairo"
    property string calculationMethod: Mem.options.services.prayer.method ?? "Egyptian"
    property string currentCity: ""
    readonly property var currentDate: DateTimeService.clock.date
    property string cachedDate: ""
    property string cachedLocation: ""
    property string cachedMethod: ""

    property var prayerTimes: ({
            "fajr": "...",
            "sunrise": "...",
            "dhuhr": "...",
            "asr": "...",
            "maghrib": "...",
            "isha": "...",
            "date": "...",
            "hijriDate": "..."
        })

    property string nextPrayer: ""
    property string nextPrayerTime: ""
    property int minutesUntilNext: 0
    property string timeUntilNext: ""
    property int hoursUntilNext: 0

    // Remaining time for each individual prayer
    property var remainingTimes: ({
            "Fajr": {
                minutes: 0,
                hours: 0,
                formatted: ""
            },
            "Sunrise": {
                minutes: 0,
                hours: 0,
                formatted: ""
            },
            "Dhuhr": {
                minutes: 0,
                hours: 0,
                formatted: ""
            },
            "Asr": {
                minutes: 0,
                hours: 0,
                formatted: ""
            },
            "Maghrib": {
                minutes: 0,
                hours: 0,
                formatted: ""
            },
            "Isha": {
                minutes: 0,
                hours: 0,
                formatted: ""
            }
        })

    readonly property var prayerNames: ["Fajr", "Sunrise", "Dhuhr", "Asr", "Maghrib", "Isha"]

    // Material You icons for each prayer time
    readonly property var prayerIcons: ({
            "Fajr": "nightlight",
            "Sunrise": "wb_twilight",
            "Dhuhr": "wb_sunny",
            "Asr": "wb_cloudy",
            "Maghrib": "wb_twilight",
            "Isha": "dark_mode"
        })

    // Calculation method codes for Aladhan API
    readonly property var methods: ({
            "University of Islamic Sciences, Karachi": 1,
            "Islamic Society of North America": 2,
            "Muslim World League": 3,
            "Umm Al-Qura University, Makkah": 4,
            "Egyptian": 5,
            "Institute of Geophysics, University of Tehran": 7,
            "Gulf Region": 8,
            "Kuwait": 9,
            "Qatar": 10,
            "Majlis Ugama Islam Singapura, Singapore": 11,
            "Union Organization islamic de France": 12,
            "Diyanet İşleri Başkanlığı, Turkey": 13,
            "Spiritual Administration of Muslims of Russia": 14
        })

    function fail(message) {
        prayerTimes = {
            fajr: "",
            sunrise: "",
            dhuhr: "",
            asr: "",
            maghrib: "",
            isha: "",
            date: "",
            hijriDate: ""
        };
        nextPrayer = "";
        nextPrayerTime = "";
        minutesUntilNext = 0;
        currentCity = message;
    }

    function toMinutes(timeStr) {
        const parts = timeStr.split(":");
        return parseInt(parts[0]) * 60 + parseInt(parts[1]);
    }

    function formatTime(time24) {
        const [h, m] = time24.split(":");
        const hour = parseInt(h);
        const ampm = hour >= 12 ? "PM" : "AM";
        const hour12 = hour === 0 ? 12 : hour > 12 ? hour - 12 : hour;
        return `${hour12}:${m} ${ampm}`;
    }

    function formatRemainingTime(minutes) {
        if (minutes < 0)
            return "Passed";
        if (minutes === 0)
            return "Now";

        const hours = Math.floor(minutes / 60);
        const mins = minutes % 60;

        if (hours === 0)
            return `${mins}m`;
        if (mins === 0)
            return `${hours}h`;
        return `${hours}h ${mins}m`;
    }

    function calculateRemainingTimes() {
        const now = currentDate;
        const currentMinutes = now.getHours() * 60 + now.getMinutes();
        const dayMinutes = 24 * 60;

        const prayers = [
            {
                name: "Fajr",
                time: prayerTimes.fajr
            },
            {
                name: "Sunrise",
                time: prayerTimes.sunrise
            },
            {
                name: "Dhuhr",
                time: prayerTimes.dhuhr
            },
            {
                name: "Asr",
                time: prayerTimes.asr
            },
            {
                name: "Maghrib",
                time: prayerTimes.maghrib
            },
            {
                name: "Isha",
                time: prayerTimes.isha
            }
        ];

        let newRemainingTimes = {};

        for (let prayer of prayers) {
            if (!prayer.time || prayer.time === "...") {
                newRemainingTimes[prayer.name] = {
                    minutes: 0,
                    hours: 0,
                    formatted: "..."
                };
                continue;
            }

            const prayerMinutes = toMinutes(prayer.time);
            let diff = prayerMinutes - currentMinutes;

            // If prayer has passed today, calculate time until tomorrow
            if (diff < 0) {
                diff = dayMinutes + diff;
            }

            const hours = Math.floor(diff / 60);
            const mins = diff % 60;

            newRemainingTimes[prayer.name] = {
                minutes: diff,
                hours: hours,
                formatted: formatRemainingTime(diff)
            };
        }

        remainingTimes = newRemainingTimes;
    }

    function calculateNextPrayer() {
        const now = currentDate;
        const currentMinutes = now.getHours() * 60 + now.getMinutes();

        const prayers = [
            {
                name: "Fajr",
                time: prayerTimes.fajr
            },
            {
                name: "Sunrise",
                time: prayerTimes.sunrise
            },
            {
                name: "Dhuhr",
                time: prayerTimes.dhuhr
            },
            {
                name: "Asr",
                time: prayerTimes.asr
            },
            {
                name: "Maghrib",
                time: prayerTimes.maghrib
            },
            {
                name: "Isha",
                time: prayerTimes.isha
            }
        ];

        for (let prayer of prayers) {
            if (!prayer.time || prayer.time === "...")
                continue;
            const prayerMinutes = toMinutes(prayer.time);
            if (prayerMinutes > currentMinutes) {
                nextPrayer = prayer.name;
                nextPrayerTime = prayer.time;
                minutesUntilNext = prayerMinutes - currentMinutes;
                hoursUntilNext = Math.floor(minutesUntilNext / 60);
                timeUntilNext = formatRemainingTime(minutesUntilNext);
                return;
            }
        }

        // If no prayer found today, next is Fajr tomorrow
        nextPrayer = "Fajr";
        nextPrayerTime = prayerTimes.fajr;
        const fajrMinutes = toMinutes(prayerTimes.fajr);
        minutesUntilNext = (24 * 60) - currentMinutes + fajrMinutes;
        hoursUntilNext = Math.floor(minutesUntilNext / 60);
        timeUntilNext = formatRemainingTime(minutesUntilNext);
    }

    function isPrayerDone(name) {
        return (Mem.states.services.islam.donePrayers || []).includes(name);
    }

    function togglePrayer(name, state) {
        let list = (Mem.states.services.islam.donePrayers || []).filter(i => i !== name);
        if (state)
            list.push(name);
        Mem.states.services.islam.donePrayers = list;
    }
    function getFastingProgress() {
        const now = currentDate.getHours() * 60 + currentDate.getMinutes();
        const start = toMinutes(prayerTimes.fajr), end = toMinutes(prayerTimes.maghrib);
        if (prayerTimes.fajr === "..." || now <= start)
            return 0;
        return now >= end ? 1 : (now - start) / (end - start);
    }

    function loadPrayerTimes() {
        // Check if we already have data for today with same location and method
        const today = currentDate.toDateString();
        if (cachedDate === today && cachedLocation === prayerLocation && cachedMethod === calculationMethod && prayerTimes.fajr !== "...") {
            console.log("Using cached prayer times for today");
            return;
        }

        const methodCode = methods[calculationMethod] || 5;
        const url = `https://api.aladhan.com/v1/timingsByCity?city=${encodeURIComponent(prayerLocation)}&country=&method=${methodCode}`;

        const xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function () {
            if (xhr.readyState !== XMLHttpRequest.DONE)
                return;
            if (xhr.status !== 200)
                return fail("Network error");

            try {
                const response = JSON.parse(xhr.responseText);
                if (response.code !== 200)
                    return fail("API error");

                const data = response.data;
                const timings = data.timings;
                const meta = data.meta;

                // Update city name - use the location query or timezone
                currentCity = prayerLocation;

                // Format prayer times (remove timezone suffix if present)
                const cleanTime = t => t.split(" ")[0];

                prayerTimes = {
                    fajr: cleanTime(timings.Fajr),
                    sunrise: cleanTime(timings.Sunrise),
                    dhuhr: cleanTime(timings.Dhuhr),
                    asr: cleanTime(timings.Asr),
                    maghrib: cleanTime(timings.Maghrib),
                    isha: cleanTime(timings.Isha),
                    date: data.date.readable,
                    hijriDate: `${data.date.hijri.day} ${data.date.hijri.month.en} ${data.date.hijri.year}`
                };

                // Update cache
                cachedDate = currentDate.toDateString();
                cachedLocation = prayerLocation;
                cachedMethod = calculationMethod;

                calculateNextPrayer();
                calculateRemainingTimes();
            } catch (e) {
                console.error("Prayer times parse error:", e);
                fail("Error parsing prayer times");
            }
        };
        xhr.open("GET", url);
        xhr.send();
    }

    // Update next prayer every minute
    Timer {
        interval: 60 * 1000
        running: true
        repeat: true
        onTriggered: {
            calculateNextPrayer();
            calculateRemainingTimes();
        }
    }

    // Refresh prayer times every 6 hours
    Timer {
        interval: 6 * 60 * 60 * 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: loadPrayerTimes()
    }
}
