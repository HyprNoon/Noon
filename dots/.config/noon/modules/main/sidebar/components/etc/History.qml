import Noon.Services
import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.functions
import qs.common.widgets
import qs.services

StyledRect {
    id: root
    visible: opacity > 0
    opacity: width > 320 ? 1 : 0
    color: Colors.colLayer1
    radius: Rounding.verylarge

    property string searchQuery: ""

    signal searchFocusRequested
    signal contentFocusRequested
    signal dismiss

    Connections {
        target: ClipboardService
        function onEntriesRefreshed() {
        }
    }

    onContentFocusRequested: {
        if (listView.count > 0) {
            listView.currentIndex = 0;
            listView.forceActiveFocus();
        }
    }

    // Simple filtered model
    ScriptModel {
        id: filteredModel
        values: {
            const entries = ClipboardService?.entries;
            if (!entries.length)
                return [];

            // Create simple data objects
            let items = [];
            for (let i = 0; i < entries.length; i++) {
                items.push({
                    index: i,
                    text: entries[i],
                    isImage: ClipboardService.isImage(i)
                });
            }

            // Filter by search query
            const query = root.searchQuery.trim().toLowerCase();
            if (!query)
                return items;

            return items.filter(item => item.text.toLowerCase().includes(query));
        }
    }

    StyledListView {
        id: listView
        anchors.fill: parent
        animateAppearance: true
        animateMovement: true
        popin: true
        spacing: Padding.small
        clip: true
        model: filteredModel
        currentIndex: -1
        highlightFollowsCurrentItem: true
        highlightMoveDuration: 150

        delegate: Loader {
            id: loader
            required property int index
            required property var modelData

            width: listView.width
            height: modelData.isImage ? 140 : 70

            sourceComponent: modelData.isImage ? imageDelegate : textDelegate

            property bool isSelected: listView.currentIndex === index

            onLoaded: {
                if (item) {
                    item.itemData = Qt.binding(() => loader.modelData);
                    item.selected = Qt.binding(() => loader.isSelected);
                }
            }
        }

        // Image delegate
        Component {
            id: imageDelegate

            StyledRect {
                property var itemData
                property bool selected: false

                color: selected ? Colors.colSecondaryContainerActive : Colors.colLayer2
                radius: Rounding.small
                clip: true
                border.width: selected ? 2 : 0
                border.color: Colors.colPrimary

                StyledImage {
                    anchors.fill: parent
                    anchors.margins: 4
                    source: "file://" + ClipboardService.getImagePath(itemData.index)
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true
                    cache: false

                    onStatusChanged: {
                        if (status === Image.Error) {
                            console.warn("Failed to load image at index:", itemData.index);
                        }
                    }
                }

                // Overlay when selected
                StyledRect {
                    anchors.fill: parent
                    visible: selected
                    color: ColorUtils.transparentize(Colors.colPrimaryContainerHover, 0.85)

                    MaterialShapeWrappedSymbol {
                        anchors {
                            bottom: parent.bottom
                            right: parent.right
                            margins: Padding.large
                        }
                        color: Colors.colPrimaryContainer
                        colSymbol: Colors.colOnPrimaryContainer
                        text: "image"
                        padding: 12
                        iconSize: 20
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        ClipboardService.copyByIndex(itemData.index);
                        NoonUtils.playSound("event_accepted");
                        root.dismiss();
                    }
                }
            }
        }

        // Text delegate
        Component {
            id: textDelegate

            StyledDelegateItem {
                property var itemData
                property bool selected: false
                readonly property bool isColor: ColorUtils.isValidColor(title)

                toggled: selected
                shape: MaterialShape.Shape.Clover4Leaf
                title: itemData.text
                subtext: qsTr("Text")
                materialIcon: "content_paste"
                colBackground: isColor ? itemData.text : colors.colLayer2
                colTitle: !hovered && isColor ? ColorUtils.getReadableColOn(colBackground) : colors.colOnLayer2
                colSubtext: !hovered && isColor ? ColorUtils.colorWithLightness(colTitle, 0.2) : colors.colSubtext
                releaseAction: () => {
                    ClipboardService.copyByIndex(itemData.index);
                    NoonUtils.playSound("event_accepted");
                    root.dismiss();
                }
            }
        }

        // Keyboard navigation
        Keys.onPressed: event => {
            if (event.key === Qt.Key_Up) {
                if (currentIndex <= 0) {
                    currentIndex = -1;
                    root.searchFocusRequested();
                } else {
                    currentIndex--;
                }
                event.accepted = true;
            } else if (event.key === Qt.Key_Down) {
                if (currentIndex < count - 1) {
                    currentIndex++;
                }
                event.accepted = true;
            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                if (currentIndex >= 0 && currentIndex < model.values.length) {
                    ClipboardService.copyByIndex(model.values[currentIndex].index);
                    NoonUtils.playSound("event_accepted");
                    root.dismiss();
                }
                event.accepted = true;
            } else if (event.key === Qt.Key_Delete) {
                if (currentIndex >= 0 && currentIndex < model.values.length) {
                    ClipboardService.deleteEntry(model.values[currentIndex].index);
                    if (currentIndex >= count) {
                        currentIndex = count - 1;
                    }
                }
                event.accepted = true;
            } else if (event.key === Qt.Key_Escape) {
                root.dismiss();
                event.accepted = true;
            }
        }

        ScrollEdgeFade {
            target: listView
            anchors.fill: parent
        }
    }

    // Empty state
    PagePlaceholder {
        shown: listView.count === 0
        title: root.searchQuery ? qsTr("No matches found") : qsTr("Clipboard is empty")
        icon: root.searchQuery ? "search_off" : "content_paste"
        anchors.centerIn: parent
    }
}
