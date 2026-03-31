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
            const existing = new Set(Mem.states.sidebar.shelf.filePaths);
            const unique = drop.urls.map(url => url.toString()).filter(p => !existing.has(p));
            Mem.states.sidebar.shelf.filePaths = [...existing, ...unique];
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

                    columns: 3
                    rowSpacing: Padding.verysmall
                    columnSpacing: Padding.verysmall
                    flow: GridLayout.LeftToRight

                    Repeater {
                        model: Mem.states.sidebar.shelf.filePaths

                        delegate: ShelfFileItem {
                            required property var modelData
                            path: modelData
                            height: Sizes.sidebar.shelfItemSize.height
                            width: Sizes.sidebar.shelfItemSize.width
                        }
                    }

                    Spacer {}
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
