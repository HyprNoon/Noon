import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.utils
import qs.common.widgets

StyledRect {
    id: root
    property bool expanded: false
    property bool readyToReceive: false
    color: Colors.colLayer1
    radius: Rounding.verylarge
    clip: true

    ScreenActionHint {
        z: 999
        text: "You Can Drop it Now"
        target: dropArea
        scale: 0.5
    }

    // Drop zone
    DropArea {
        id: dropArea
        anchors.fill: parent

        keys: ["text/uri-list"]

        onEntered: root.readyToReceive = true
        onExited: root.readyToReceive = false

        onDropped: drop => {
            root.readyToReceive = false;
            let newPaths = drop.urls.map(url => url.toString());
            Mem.states.sidebar.shelf.filePaths = [...Mem.states.sidebar.shelf.filePaths, ...newPaths];

            if (!GlobalStates.main.sidebar.pinned) {
                NoonUtils.callIpc("sidebar hide");
            }
            NoonUtils.playSound("event_accepted");
        }

        StyledRect {
            id: dropRect
            anchors.fill: parent
            anchors.margins: Padding.normal
            color: "transparent"
            radius: Rounding.verylarge
            Flickable {
                anchors.fill: parent
                anchors.margins: Padding.normal

                contentWidth: grid.width
                contentHeight: grid.height

                clip: true

                GridLayout {
                    id: grid
                    width: dropRect.width - Padding.large
                    readonly property bool listMode: Mem.states.sidebar.shelf.listMode

                    columns: listMode ? 1 : 3
                    rowSpacing: Padding.verysmall
                    columnSpacing: Padding.verysmall
                    flow: listMode ? GridLayout.TopToBottom : GridLayout.LeftToRight

                    Repeater {
                        model: Mem.states.sidebar.shelf.filePaths

                        delegate: ShelfFileItem {
                            required property var modelData
                            listMode: grid.listMode
                            path: modelData
                            height: listMode ? 72 : Sizes.sidebar.shelfItemSize.height
                            width: listMode ? grid.width - Padding.large : Sizes.sidebar.shelfItemSize.width
                        }
                    }

                    Spacer {}
                }
            }
            StyledRect {
                anchors {
                    bottom: parent.bottom
                    right: parent.right
                    margins: Padding.huge
                }
                z: 99
                width: row.implicitWidth + Padding.large
                height: 36
                enableBorders: true
                radius: Rounding.large
                color: Colors.colLayer2
                RLayout {
                    id: row
                    anchors.centerIn: parent
                    RippleButtonWithIcon {
                        implicitSize: 28
                        toggled: grid.listMode === false
                        materialIcon: "grid_view"
                        releaseAction: () => Mem.states.sidebar.shelf.listMode = false
                    }
                    RippleButtonWithIcon {
                        implicitSize: 28
                        materialIcon: "list"
                        toggled: grid.listMode !== false
                        releaseAction: () => Mem.states.sidebar.shelf.listMode = true
                    }
                }
            }
            PagePlaceholder {
                icon: "shelves"
                shown: Mem.states.sidebar.shelf.filePaths.length === 0
                title: "Drop Anything Here"
            }
        }
    }
}
