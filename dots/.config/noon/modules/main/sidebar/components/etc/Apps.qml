import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

StyledRect {
    id: root
    visible: opacity > 0
    opacity: width > 320 ? 1 : 0
    color: Colors.colLayer1
    radius: Rounding.verylarge

    readonly property int columns: 3
    property string searchQuery: ""
    property string _debouncedQuery: ""

    signal searchFocusRequested
    signal contentFocusRequested
    signal dismiss

    function first_action() {
        filteredModel.values[0].execute();
    }

    Timer {
        id: debounceTimer
        interval: 200
        onTriggered: root._debouncedQuery = root.searchQuery
    }

    onSearchQueryChanged: debounceTimer.restart()

    ScriptModel {
        id: filteredModel
        values: {
            const query = root._debouncedQuery.toLowerCase().trim();
            const apps = DesktopEntries.applications.values;
            if (query === "")
                return apps;
            return apps.filter(entry => entry.name.toLowerCase().includes(query) || entry.genericName.toLowerCase().includes(query) || entry.keywords.some(k => k.toLowerCase().includes(query)));
        }
    }

    StyledGridView {
        id: gridView
        anchors.fill: parent
        anchors.margins: Padding.normal
        cellWidth: Math.floor(width / root.columns)
        cellHeight: cellWidth + 20
        clip: true
        currentIndex: -1
        model: filteredModel

        Connections {
            target: root
            function onContentFocusRequested() {
                if (gridView.count > 0) {
                    gridView.currentIndex = 0;
                    gridView.forceActiveFocus();
                }
            }
        }

        delegate: StyledRect {
            id: appButton
            required property int index
            required property var modelData

            implicitHeight: gridView.cellHeight
            implicitWidth: gridView.cellWidth
            property bool isSelected: gridView.currentIndex === index && gridView.activeFocus
            property bool isPinned: Mem.states.favorites.apps.some(id => id.toLowerCase() === modelData.id.toLowerCase())

            radius: Rounding.large
            color: isSelected ? Colors.colSecondaryContainerActive : (eventArea.containsMouse ? Colors.colSecondaryContainerHover : "transparent")

            MouseArea {
                id: eventArea
                hoverEnabled: true
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onReleased: mouse => {
                    if (mouse.button === Qt.RightButton)
                        contextMenu.popup();
                    else {
                        GlobalStates.main.sidebar.hide();
                        modelData.execute();
                    }
                }
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Padding.small
                spacing: Padding.normal

                StyledIconImage {
                    source: NoonUtils.iconPath(modelData.icon)
                    colorize: Mem.options.appearance.icons.tint
                    implicitSize: 56
                    Layout.alignment: Qt.AlignHCenter
                }

                StyledText {
                    text: modelData.name
                    font.pixelSize: Fonts.sizes.small
                    color: Colors.colOnLayer2
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                    maximumLineCount: 2
                    wrapMode: Text.WordWrap
                }
            }

            StyledMenu {
                id: contextMenu
                content: [
                    {
                        "text": "Launch",
                        "materialIcon": "launch",
                        "action": () => {
                            modelData.execute();
                            root.dismiss();
                        }
                    },
                    {
                        "text": appButton.isPinned ? "Unpin" : "Pin",
                        "materialIcon": "push_pin",
                        "action": () => {
                            const id = modelData.id;
                            Mem.states.favorites.apps = appButton.isPinned ? Mem.states.favorites.apps.filter(x => x !== id) : [...Mem.states.favorites.apps, id];
                        }
                    }
                ]
            }
        }

        Keys.onPressed: event => {
            const cols = root.columns;
            if (event.key === Qt.Key_Up) {
                if (currentIndex < cols) {
                    currentIndex = -1;
                    root.searchFocusRequested();
                } else
                    currentIndex -= cols;
            } else if (event.key === Qt.Key_Down) {
                if (currentIndex + cols < count)
                    currentIndex += cols;
            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                if (currentIndex >= 0) {
                    model.values[currentIndex].execute();
                    root.dismiss();
                }
            } else
                return;
            event.accepted = true;
        }

        ScrollEdgeFade {
            target: gridView
            anchors.fill: parent
        }
    }

    PagePlaceholder {
        shown: gridView.count === 0
        title: root.searchQuery === "" ? "No applications found" : "No results for '" + root.searchQuery + "'"
        icon: "search_off"
        anchors.centerIn: parent
    }
}
