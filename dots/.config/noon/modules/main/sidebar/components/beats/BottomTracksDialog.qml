import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.common
import qs.common.widgets
import qs.services

BottomDialog {
    id: root

    property string searchText: ""

    readonly property var filteredTracks: {
        const search = searchText.toLowerCase();
        return BeatsService.tracksList.filter(entry => search === "" || (entry.title ?? entry.filename ?? "").toLowerCase().includes(search));
    }

    z: 99
    expandedHeight: root.height * 0.95
    collapsedHeight: root.height * 0.65
    bottomAreaReveal: true
    hoverHeight: 200
    revealOnWheel: true
    enableStagedReveal: true
    colors: parent.colors
    color: colors.colLayer2
    contentItem: ColumnLayout {
        anchors.fill: parent
        anchors.margins: Padding.verylarge
        spacing: Padding.large

        BottomDialogHeader {
            title: "Beats"
            subTitle: `There are ${root.filteredTracks.length} Tracks in your playlist !`
        }

        SearchBar {
            id: search
            Layout.fillWidth: true
            implicitHeight: 40
            Layout.leftMargin: Padding.large
            Layout.rightMargin: Padding.large
            searchInput.placeholderText: "Search Tracks"
            color: "transparent"
            onSearchTextChanged: searchTimer.restart()

            Timer {
                id: searchTimer
                interval: 200
                onTriggered: root.searchText = search.searchText
            }
        }

        StyledListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: Padding.normal
            spacing: 8
            clip: true
            model: root.filteredTracks

            delegate: StyledDelegateItem {
                required property int index
                required property var modelData

                readonly property string hash: modelData.hash ?? ""
                readonly property string fileName: modelData.filename ?? ""
                readonly property string absPath: modelData.filepath
                readonly property bool currentlyPlaying: absPath === BeatsService.currentTrackPath
                iconSource: Qt.resolvedUrl(modelData?.cover_art) ?? ""
                subtext: FileUtils.getEscapedFileExtension(absPath)
                implicitHeight: 70
                title: modelData.title || modelData.filename || "Unknown Track"
                toggled: currentlyPlaying
                buttonRadius: Rounding.huge
                colBackground: colors.colLayer3
                colBackgroundHover: colors.colLayer3Hover
                colors: root.colors
                releaseAction: () => BeatsService.playTrack(modelData.playlist_index)
                altAction: () => trackContextMenu.popup()

                TrackContextMenu {
                    id: trackContextMenu
                    trackPath: parent.absPath
                    trackName: parent.title
                }
            }
        }
    }
}
