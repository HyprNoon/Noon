import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.common.functions
import qs.services

StyledRect {
    id: root

    z: 99
    radius: Rounding.massive
    color: colors.colLayer1
    colors: parent.colors
    clip: true

    readonly property string searchQuery: searchInput.text.trim().toLowerCase()

    ColumnLayout {
        anchors.fill: parent
        spacing: Padding.large

        StyledRect {
            Layout.topMargin: Padding.huge
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            color: "transparent"

            RowLayout {
                id: searchRow
                height: 36
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.leftMargin: Padding.massive
                anchors.rightMargin: Padding.massive

                Symbol {
                    icon: "search"
                    iconSize: 20
                    color: root.colors.colOnLayer1
                }
                StyledTextField {
                    id: searchInput
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    background: null
                    placeholderText: "Search..."
                    placeholderTextColor: focus ? colors.colOnSecondaryContainer : colors.colOutline
                    selectionColor: searchBar.colors.colSecondary
                    selectedTextColor: colors.colOnSecondary
                    color: colors.colOnLayer1
                    selectByMouse: true
                    font {
                        family: Fonts.family.main
                        pixelSize: Fonts.sizes.small
                    }

                    Keys.onPressed: event => {
                        if (event.key === Qt.Key_Down) {
                            list.forceActiveFocus();
                            if (list.currentIndex === -1 && list.count > 0) {
                                list.currentIndex = 0;
                            }
                            event.accepted = true;
                        }
                    }
                }
            }
        }

        StyledListView {
            id: list
            clip: true
            Layout.margins: Padding.large
            radius: Rounding.huge
            hinter.anchors.margins: -Layout.margins
            Layout.fillWidth: true
            Layout.fillHeight: true
            highlightFollowsCurrentItem: true
            highlightMoveDuration: 250
            highlightMoveVelocity: -1
            keyNavigationEnabled: true
            focus: true

            _model: {
                let fullQueue = BeatsService.queue || [];
                if (root.searchQuery === "") {
                    return fullQueue;
                }
                return fullQueue.filter(item => {
                    let titleMatch = item?.title?.toLowerCase().includes(root.searchQuery);
                    let artistMatch = item?.artist?.toLowerCase().includes(root.searchQuery);
                    return titleMatch || artistMatch;
                });
            }

            currentIndex: {
                let currentTitle = BeatsService.player.trackTitle;
                if (!model || currentTitle === undefined)
                    return -1;

                let modelArray = Array.isArray(model) ? model : [];
                for (let i = 0; i < modelArray.length; i++) {
                    if (modelArray[i] && modelArray[i].title === currentTitle) {
                        return i;
                    }
                }
                return -1;
            }

            highlight: Item {
                z: 2
                width: list.width
                height: 60

                StyledRect {
                    anchors.left: parent.left
                    anchors.leftMargin: Padding.huge
                    anchors.verticalCenter: parent.verticalCenter
                    height: 24
                    radius: 6
                    width: 6
                    color: Colors.colPrimary
                }
            }

            Keys.onPressed: event => {
                if (event.key === Qt.Key_Up && list.currentIndex === 0) {
                    searchInput.forceActiveFocus();
                    event.accepted = true;
                } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    if (list.currentItem) {
                        let currentTrack = list.model[list.currentIndex];
                        if (currentTrack) {
                            BeatsService.playTrackByFile(currentTrack.file);
                        }
                    }
                    event.accepted = true;
                }
            }

            delegate: StyledRect {
                required property var modelData
                required property int index

                anchors.right: parent?.right
                anchors.left: parent?.left
                height: 60
                color: "transparent"

                Rectangle {
                    visible: index !== list.count - 1
                    anchors.bottom: parent?.bottom
                    anchors.left: contentRow?.left
                    anchors.right: contentRow?.right
                    anchors.rightMargin: Padding.massive
                    anchors.leftMargin: Padding.massive

                    height: 1
                    color: colors.colOutline
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        list.currentIndex = index;
                        BeatsService.playTrackByFile(modelData?.file);
                    }
                }

                RLayout {
                    id: contentRow
                    anchors.fill: parent
                    anchors.rightMargin: Padding.normal
                    anchors.leftMargin: Padding.normal
                    spacing: Padding.massive

                    Item {
                        height: 24
                        width: 6
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 1
                        StyledText {
                            text: modelData?.title
                            truncate: true
                            Layout.alignment: Qt.AlignVCenter
                            Layout.fillWidth: true
                            color: Colors.colOnLayer2
                            font.pixelSize: Fonts.sizes.normal
                        }
                        StyledText {
                            text: modelData?.artist
                            truncate: true
                            Layout.alignment: Qt.AlignVCenter
                            Layout.fillWidth: true
                            color: Colors.colSubtext
                            font.pixelSize: Fonts.sizes.small
                        }
                    }
                }
            }
        }
    }
}
