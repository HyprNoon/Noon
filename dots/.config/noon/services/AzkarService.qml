pragma Singleton
import QtQuick
import qs.common
import qs.common.utils

Singleton {
    id: root

    property var db
    property var currentZekr: loadZekrForTime()

    FileView {
        id: azkarFile
        path: Directories.assets + "/db/azkar.json"
        onTextChanged: db = JSON.parse(azkarFile.text())
    }

    function categoryForHour(hour) {
        if (hour >= 4 && hour < 11)
            return "أذكار الصباح";
        if (hour >= 11 && hour < 16)
            return "تسابيح";
        if (hour >= 16 && hour < 18)
            return "أذكار المساء";
        if (hour >= 18 && hour < 21)
            return "أذكار بعد السلام من الصلاة المفروضة";
        if (hour >= 21 && hour < 24)
            return "أذكار النوم";
        return "أذكار الاستيقاظ";
    }

    function loadZekrForTime() {
        const category = db[categoryForHour(DateTimeService.clock)];
        currentZekr = category[Math.floor(Math.random() * category.length)];
    }
}
