import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.common.functions
import qs.services

StyledRect {
    id: root

    property string searchText: ""

    ScriptModel {
        id: filteredModel
        values: {
            const search = searchText.toLowerCase();
            return BeatsService.tracksList.filter(entry => search === "" || (entry.title ?? entry.filename ?? "").toLowerCase().includes(search));
        }
    }

    z: 99
    radius: Rounding.massive
    color: colors.colLayer2
    colors: parent.colors
    clip: true

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Padding.huge
        spacing: Padding.large

        BottomDialogHeader {
            title: BeatsService._connected ? "Beats" : "Offline"
            subTitle: `There are ${filteredModel.values.length} Tracks in your playlist !`
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
            Connections {
                target: search.searchInput
                function onAccepted() {
                    if (root.filteredTracks.length > 0)
                        BeatsService.playTrack(root.filteredTracks[0].playlist_index);
                }
            }
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
            spacing: 6
            clip: true
            reuseItems: false
            model: filteredModel

            delegate: StyledDelegateItem {
                required property int index
                required property var modelData

                readonly property string hash: modelData.hash ?? ""
                readonly property string fileName: modelData.filename ?? ""
                readonly property string absPath: modelData.filepath
                readonly property bool currentlyPlaying: absPath === BeatsService.currentTrackPath
                iconSource: Qt.resolvedUrl(modelData?.cover_art) ?? ""
                implicitHeight: 70
                title: modelData.title ?? "Unknown Track"
                subtext: modelData.artist ?? "Unknown Artist"
                toggled: currentlyPlaying
                buttonRadius: Rounding.huge
                colBackground: colors.colLayer3
                colBackgroundHover: colors.colLayer3Hover
                colors: root.colors

                releaseAction: () => BeatsService.playTrack(modelData?.playlist_index + 1)
                altAction: () => trackContextMenu.popup()

                TrackContextMenu {
                    id: trackContextMenu
                    trackPath: parent.absPath
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
            margins: Padding.large
        }
        radius: Rounding.massive
        color: root.colors.colLayer3
        height: 75

        StyledListView {
            id: foldersList
            anchors.fill: parent
            anchors.margins: Padding.normal
            orientation: Qt.Horizontal
            model: Mem.states.mediaPlayer.folders.concat(["ADD"])

            delegate: GroupButtonWithIcon {
                required property var modelData
                readonly property bool isAdd: modelData === "ADD"

                anchors.top: parent.top
                anchors.bottom: parent.bottom
                baseWidth: height
                radius: Rounding.large
                color: root.colors.colLayer4Hover
                materialIcon: isAdd ? "add" : "folder"
                releaseAction: () => {
                    if (isAdd) {
                        BeatsService.addNewFolder();
                    } else {
                        Mem.states.mediaPlayer.currentTrackPath = Qt.resolvedUrl(modelData);
                    }
                }
                altAction: () => {
                    if (!isAdd) {
                        let currentFolders = Mem.states.mediaPlayer.folders;
                        let updatedFolders = currentFolders.filter(path => path !== modelData);
                        Mem.states.mediaPlayer.folders = updatedFolders;
                    }
                }

                StyledToolTip {
                    extraVisibleCondition: parent.containsMouse
                    content: FileUtils.getEscapedFileName(modelData)
                }
            }
        }
    }
}
