import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.services
import qs.common
import qs.common.widgets
import "widgets"
import "pages"

StyledRect {
    id: root

    color: Colors.colLayer1
    radius: Rounding.verylarge

    property bool expanded: false
    readonly property Component widgetView: IslamWidgetsPage {
        expanded: root.expanded
    }
    readonly property Component quranView: QuranPage {}

    function reset() {
        mainView.push(widgetView);
        mainView.pop(quranView);
    }
    Connections {
        target: QuranService

        function onCurrentSurahChanged() {
            if (QuranService.currentSurah !== null) {
                mainView.push(quranView);
                mainView.pop(widgetView);
            } else
                reset();
        }
    }

    StackView {
        id: mainView
        anchors.fill: parent
        initialItem: widgetView
        onCurrentItemChanged: mainView.currentItem.backRequested.connect(() => reset())
    }
    SurahList {
        show: false
        expand: root.expanded
    }
}
