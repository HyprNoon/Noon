import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.common.functions
import qs.services
import "../local"
import "../"

StyledRect {
    id: root

    property bool expanded

    ScriptModel {
        id: filteredModel
        values: {
            const query = controls.inputArea.text;
            const searchBy = text => {
                if (query === "")
                    return true;
                else if (text)
                    return (text).toLowerCase().includes(query);
            };
            const filtered = BeatsService.library.filter(entry => searchBy(entry.title) || searchBy(entry.artist));
            if (Mem.states.services.beats.shuffleTracks)
                return filtered.sort(() => Math.random() - 0.5);
            else
                return filtered;
        }
    }

    StyledRectangularShadow {
        target: controls
    }

    LocalControls {
        id: controls
    }
    function createPlaylistFromModel() {
        var playlist = [];
        for (var i = 0; i < filteredModel.values.length; i++) {
            var item = filteredModel.values[i];
            if (item && item.title)
                playlist.push(item.title);
        }
        return playlist.join(",");
    }

    function playResults() {
        if (controls.inputArea.text.length > 0) {
            BeatsService.playCustomPlaylist(createPlaylistFromModel());
        }
    }
    function createPlaylist(fileName) {
        BeatsService.playTrackByFile(fileName);
    }

    radius: Rounding.verylarge
    color: colors.colLayer1
    colors: BeatsService.colors

    StyledGridView {
        id: grid
        clip: true
        anchors.fill: parent
        anchors.margins: Padding.large
        reuseItems: false
        model: filteredModel
        property int columns: root.expanded ? 4 : 2
        cellWidth: width / columns
        cellHeight: cellWidth
        property string libPath: BeatsService.getCurrentLibraryPath() + "/"
        delegate: TrackItem {
            implicitSize: grid.cellWidth - Padding.large
            title: modelData?.title ?? ""
            artist: modelData?.artist ?? ""
            coverArt: grid.libPath + modelData?.cover ?? ""
            eventArea.onClicked: event => {
                if (event.button === Qt.LeftButton) {
                    root.createPlaylist(modelData?.file);
                } else if (event.button === Qt.MiddleButton) {
                    root.playResults();
                } else if (event.button === Qt.RightButton) {
                    menu.popup();
                }
            }
            // REWORK
            TrackContextMenu {
                id: menu
                trackPath: grid.libPath + modelData.file
                trackName: modelData.title
            }
        }
    }
    MouseArea {
        id: dismissArea
        z: controls.z - 1
        preventStealing: true
        hoverEnabled: true
        enabled: controls._expanded
        anchors.fill: parent
        onClicked: controls.mode = ""
    }
}
