import Noon.Services
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

    signal searchFocusRequested
    signal contentFocusRequested
    signal dismiss

    ScriptModel {
        id: filteredModel
        values: {
            const all = EmojisService.list;
            const q = root.searchQuery.toLowerCase().trim();

            if (q === "") {
                const frequent = EmojisService.frequentEmojis;
                if (frequent.length > 0) {
                    const freqObjs = frequent.map(fChar => all.find(e => e.emoji === fChar)).filter(Boolean);
                    const others = all.filter(e => !frequent.includes(e.emoji));
                    return [...freqObjs, ...others].slice(0, 150);
                }
                return all.slice(0, 150);
            }

            return all.filter(e => e.name.toLowerCase().includes(q) || e.category.toLowerCase().includes(q) || e.subcategory.toLowerCase().includes(q) || e.emoji.includes(q)).slice(0, 100);
        }
    }

    StyledGridView {
        id: gridView
        anchors.fill: parent
        cellWidth: Math.floor(width / root.columns)
        cellHeight: cellWidth
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
            id: emojiButton
            required property int index
            required property var modelData

            implicitHeight: gridView.cellHeight
            implicitWidth: gridView.cellWidth
            property bool isSelected: gridView.currentIndex === index && gridView.activeFocus

            radius: Rounding.verylarge
            color: isSelected ? Colors.colSecondaryContainerActive : (eventArea.containsMouse ? Colors.colSecondaryContainerHover : "transparent")

            MouseArea {
                id: eventArea
                hoverEnabled: true
                anchors.fill: parent
                onReleased: {
                    root.dismiss();
                    ClipboardService.copy(modelData.emoji);
                    EmojisService.recordEmojiUse(modelData.emoji);
                }
            }

            StyledText {
                anchors.centerIn: parent
                text: modelData.emoji
                font.pixelSize: 64
            }
        }

        Keys.onPressed: event => {
            const cols = root.columns;
            if (event.key === Qt.Key_Up) {
                if (currentIndex < cols) {
                    currentIndex = -1;
                    root.searchFocusRequested();
                } else {
                    currentIndex -= cols;
                }
            } else if (event.key === Qt.Key_Down) {
                if (currentIndex + cols < count)
                    currentIndex += cols;
            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                if (currentIndex >= 0) {
                    const e = model.values[currentIndex].emoji;
                    ClipboardService.copy(e);
                    EmojisService.recordEmojiUse(e);
                    root.dismiss();
                }
            } else
                return;
            event.accepted = true;
        }
    }

    PagePlaceholder {
        shown: gridView.count === 0
        title: qsTr("No emojis found")
        icon: "sentiment_dissatisfied"
        anchors.centerIn: parent
    }
}
