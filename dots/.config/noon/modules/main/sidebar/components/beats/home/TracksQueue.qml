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
    property int moveSrc: -1
    property var moveSrcItem: null

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        RowLayout {
            Layout.maximumHeight: 36
            Layout.fillWidth: true
            Layout.margins: Padding.massive
            Layout.bottomMargin: Padding.verysmall
            spacing: Padding.large

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

            RippleButtonWithIcon {
                implicitSize: 28
                materialIcon: "refresh"
                releaseAction: () => BeatsService.getQueue()
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
            currentIndex: updateIndex()
            Connections {
                target: BeatsService
                function onTitleChanged() {
                    list.updateIndex();
                }
            }
            function updateIndex() {
                const title = BeatsService.player.trackTitle;
                const model = BeatsService.queue;
                list.currentIndex = model?.findIndex(t => t.title === title) ?? -1;
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
                    color: colors.colPrimary
                }
            }

            Keys.onPressed: event => {
                if (event.key === Qt.Key_Up && list.currentIndex === 0) {
                    searchInput.forceActiveFocus();
                    event.accepted = true;
                } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    if (list.currentItem) {
                        let currentTrack = list.model[list.currentIndex];
                        if (currentTrack)
                            BeatsService.playTrackByFile(currentTrack.file);
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
                color: root.moveSrc === index ? colors.colSecondaryContainer : "transparent"

                Rectangle {
                    visible: index !== list.count - 1
                    anchors.bottom: parent?.bottom
                    anchors.left: parent?.left
                    anchors.right: parent?.right
                    anchors.leftMargin: Padding.massive
                    anchors.rightMargin: Padding.massive
                    height: 1
                    color: colors.colOutline
                }

                RLayout {
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
                            color: colors.colOnLayer2
                            font.pixelSize: Fonts.sizes.normal
                        }
                        StyledText {
                            text: modelData?.artist
                            truncate: true
                            Layout.alignment: Qt.AlignVCenter
                            Layout.fillWidth: true
                            color: colors.colSubtext
                            font.pixelSize: Fonts.sizes.small
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: mouse => {
                        if (mouse.button === Qt.RightButton) {
                            root.moveSrc = index;
                            root.moveSrcItem = modelData;
                        } else if (root.moveSrc >= 0) {
                            if (root.moveSrc !== index && root.moveSrcItem)
                                BeatsService.moveQueueItemByMpdIdx(root.moveSrcItem.index, modelData.index);
                            root.moveSrc = -1;
                            root.moveSrcItem = null;
                        } else {
                            list.currentIndex = index;
                            BeatsService.playTrackByFile(modelData?.file);
                        }
                    }
                }
            }
        }
    }
}
