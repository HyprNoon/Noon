import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.common.functions
import qs.services

StyledRect {
    id: root

    property var filteredTracks: []
    property string searchText: ""
    readonly property var model: BeatsService.tracksModel
    function updateFilteredTracks() {
        let tracks = [];
        if (!model) {
            filteredTracks = tracks;
            return;
        }
        const count = model.count;
        const search = searchText.toLowerCase();
        for (let i = 0; i < count; i++) {
            const trackInfo = BeatsService.getTrackInfo(i);
            if (trackInfo && (search === "" || trackInfo.name.toLowerCase().includes(search)))
                tracks.push({
                    "index": i,
                    "info": trackInfo
                });
        }
        filteredTracks = tracks;
    }
    Connections {
        target: BeatsService.tracksModel
        function onFolderChanged() {
            updateFilteredTracks();
        }
    }
    z: 99
    radius: Rounding.massive
    color: colors.colLayer2
    colors: parent.colors
    Component.onCompleted: updateFilteredTracks()
    clip: true
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Padding.huge
        spacing: Padding.large

        BottomDialogHeader {
            title: "Beats"
            subTitle: `There are ${root.filteredTracks.length} Tracks in your playlist !`
            showCloseButton: false
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
                onTriggered: {
                    root.searchText = search.searchText;
                    root.updateFilteredTracks();
                }
            }
        }

        StyledListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: Padding.normal
            spacing: 6
            clip: true
            model: root.filteredTracks

            delegate: StyledDelegateItem {
                required property int index
                required property var modelData
                readonly property var trackInfo: modelData.info
                readonly property string trackPath: trackInfo.path || ""
                readonly property bool currentlyPlaying: trackPath === BeatsService.currentTrackPath
                readonly property string fileExtension: trackInfo.fileName.includes('.') ? trackInfo.fileName.split('.').pop().toUpperCase() : ""

                implicitHeight: 70
                title: trackInfo.name || "Unknown Track"
                subtext: fileExtension ? `${fileExtension} Audio` : ""
                toggled: currentlyPlaying
                buttonRadius: Rounding.huge
                colBackground: colors.colLayer3
                colBackgroundHover: colors.colLayer3Hover
                shape: MaterialShape.Bun
                shapePadding: Padding.small
                colors: root.colors
                releaseAction: () => {
                    return BeatsService.playTrackByPath(trackPath);
                }
                altAction: () => {
                    return trackContextMenu.popup();
                }

                TrackContextMenu {
                    id: trackContextMenu

                    trackPath: parent.trackPath
                    trackName: parent.title
                }
            }
        }
    }
    StyledRect {
        anchors {
            bottom: parent.bottom
            right: parent.right
            left: parent.left
            margins: Padding.normal
        }
        radius: Rounding.massive
        color: root.colors.colLayer3
        height: 75
        StyledListView {
            id: foldersList
            anchors.fill: parent
            anchors.leftMargin: Padding.huge
            anchors.margins: Padding.normal
            orientation: Qt.Horizontal
            model: Mem.states.mediaPlayer.folders
            delegate: StyledRect {
                required property var modelData
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    margins: Padding.small
                }
                width: height
                radius: Rounding.large
                color: root.colors.colLayer4
                Symbol {
                    anchors.centerIn: parent
                    text: "folder"
                    fill: 1
                    color: root.colors.colOnLayer4
                    font.pixelSize: 20
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: BeatsService.tracksModel.folder = Qt.resolvedUrl(modelData)

                    StyledToolTip {
                        extraVisibleCondition: parent.containsMouse
                        content: FileUtils.getEscapedFileName(modelData)
                    }
                }
            }
        }
    }
}
