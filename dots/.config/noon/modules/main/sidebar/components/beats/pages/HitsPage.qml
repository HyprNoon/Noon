import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.services
import "../"
import "./../hits"

StyledRect {
    id: root
    color: Colors.colLayer1
    radius: Rounding.verylarge
    property bool expanded
    property bool isSearching: BeatsHitsService.lastQuery.length > 0
    property rect previewOrigin: Qt.rect(0, 0, 0, 0)

    onIsSearchingChanged: controls.inputArea.forceActiveFocus()

    function loadMore(i) {
        if (BeatsHitsService.isBusy)
            return;
        if (isSearching)
            BeatsHitsService.searchMore(controls.inputArea.text);
        else
            BeatsHitsService.request(i);
    }

    ScrollEdgeFade {
        target: grid
    }

    StyledGridView {
        id: grid
        z: 1
        anchors.margins: Padding.huge
        anchors.fill: parent
        readonly property int columns: root.expanded ? 4 : 2
        cellWidth: width / columns
        cellHeight: cellWidth
        reuseItems: false
        _model: {
            if (root.isSearching)
                return BeatsHitsService.searchResults;
            else if (Mem.states.services.beats.shuffleHits)
                return BeatsHitsService.hits.sort(() => Math.random() - 0.5);
            else
                return BeatsHitsService.hits;
        }
        delegate: TrackItem {
            implicitSize: grid.cellWidth - Padding.large
            title: modelData.title
            artist: modelData.artist
            coverArt: modelData.thumbnail
            isPlaylist: modelData.isPlaylist
            action: () => {
                Mem.states.services.beats.previewData = modelData;
                controls._expanded = true;
                controls.mode = "preview";
            }
        }
        onContentYChanged: {
            if (contentHeight > 0 && contentY + height >= contentHeight - height * 0.25)
                root.loadMore();
        }
    }
    StyledRectangularShadow {
        target: controls
    }

    HitsControls {
        id: controls
        songData: Mem.states.services.beats.previewData
    }
    StyledIndeterminateProgressBar {
        z: 2
        height: 4
        visible: BeatsHitsService.isBusy
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
    }
    StyledRect {
        z: controls.z - 1
        opacity: dismissArea.enabled ? 1 : 0
        anchors.fill: parent
        color: Colors.colScrim
    }
    MouseArea {
        id: dismissArea
        z: controls.z - 1
        preventStealing: true
        hoverEnabled: true
        enabled: controls._expanded
        anchors.fill: parent
        onClicked: {
            controls.mode = "options";
            controls._expanded = false;
        }
    }
}
