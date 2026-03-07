pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.common
import qs.common.utils

Singleton {
    id: root

    property var surahs: []
    property var currentSurah: null
    property var todaysAyah: null
    property bool loading: false
    property string error: ""

    Component.onCompleted: {
        fetchSurahs();
        fetchTodaysAyah();
    }

    function fetchTodaysAyah() {
        const date = DateTimeService.clock.date;
        const start = new Date(date.getFullYear(), 0, 0);
        const dayOfYear = Math.floor((date - start) / 86400000);
        const ayahNumber = (dayOfYear % 6236) + 1;

        loading = true;
        error = "";
        const xhr = new XMLHttpRequest();
        xhr.open("GET", "https://api.alquran.cloud/v1/ayah/" + ayahNumber);
        xhr.onreadystatechange = () => {
            if (xhr.readyState !== XMLHttpRequest.DONE)
                return;
            loading = false;
            if (xhr.status === 200) {
                todaysAyah = JSON.parse(xhr.responseText).data;
            } else {
                error = "Failed to fetch today's ayah: " + xhr.status;
            }
        };
        xhr.send();
    }

    function fetchSurahs() {
        loading = true;
        error = "";
        const xhr = new XMLHttpRequest();
        xhr.open("GET", "https://api.alquran.cloud/v1/surah");
        xhr.onreadystatechange = () => {
            if (xhr.readyState !== XMLHttpRequest.DONE)
                return;
            loading = false;
            if (xhr.status === 200) {
                surahs = JSON.parse(xhr.responseText).data;
            } else {
                error = "Failed to fetch surahs: " + xhr.status;
            }
        };
        xhr.send();
    }

    function getSurahByName(name) {
        const lower = name.toLowerCase();
        const match = surahs.find(s => s.englishName.toLowerCase().includes(lower) || s.englishNameTranslation.toLowerCase().includes(lower) || s.name.includes(name));
        if (!match) {
            error = "Surah not found: " + name;
            return;
        }
        loading = true;
        error = "";
        const xhr = new XMLHttpRequest();
        xhr.open("GET", "https://api.alquran.cloud/v1/surah/" + match.number);
        xhr.onreadystatechange = () => {
            if (xhr.readyState !== XMLHttpRequest.DONE)
                return;
            loading = false;
            if (xhr.status === 200) {
                currentSurah = JSON.parse(xhr.responseText).data;
            } else {
                error = "Failed to fetch surah: " + xhr.status;
            }
        };
        xhr.send();
    }
}
