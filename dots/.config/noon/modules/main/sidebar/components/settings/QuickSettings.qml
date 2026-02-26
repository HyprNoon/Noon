import Qt5Compat.GraphicalEffects
import QtQuick.Effects
import QtQuick.Controls
import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.store
import qs.services
import qs.common
import qs.common.widgets

StyledRect {
    id: root
    z: 1
    clip: true
    color: "transparent"
    radius: Rounding.verylarge
    property int rowHeight: 30
    property int padding: Padding.normal
    property int minItemWidth: 300
    property int itemSpacing: Padding.normal
    property QtObject colors: Colors

    property int columnNumber: {
        var availableWidth = width - (padding * 2);
        var effectiveItemWidth = minItemWidth + itemSpacing;
        var calculatedColumns = Math.floor(availableWidth / effectiveItemWidth);
        return Math.max(1, calculatedColumns);
    }

    property string searchQuery: ""
    property bool expanded: false

    signal expandToggled

    property var settingsData: TweaksData.tweaks ?? []
    property var itemStates: ({})

    function matchesSearch(text) {
        return searchQuery === "" || text.toLowerCase().includes(searchQuery.toLowerCase());
    }

    function shouldShowItem(item) {
        var searchMatch = matchesSearch(item.name);
        if (!searchMatch)
            return false;

        if (item.condition) {
            try {
                return eval(item.condition);
            } catch (e) {
                return false;
            }
        }

        return true;
    }

    property bool hasAnyVisibleSettingsItem: {
        for (var i = 0; i < settingsData.length; i++) {
            var section = settingsData[i];
            if (section.items) {
                for (var j = 0; j < section.items.length; j++) {
                    if (shouldShowItem(section.items[j])) {
                        return true;
                    }
                }
            }
        }
        return false;
    }

    Timer {
        id: reloadTimeOut
        interval: 200
        onTriggered: Quickshell.reload(true)
    }

    PagePlaceholder {
        anchors.centerIn: parent
        visible: !root.hasAnyVisibleSettingsItem
        icon: "block"
        shape: MaterialShape.Clover4Leaf
        title: "Nothing found"
    }

    StyledFlickable {
        anchors.fill: parent
        contentHeight: contentColumn.height
        boundsBehavior: Flickable.StopAtBounds
        clip: true

        ColumnLayout {
            id: contentColumn
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 7

            Repeater {
                model: settingsData

                delegate: Column {
                    Layout.fillWidth: true

                    property bool hasVisibleItems: {
                        if (!modelData.items)
                            return false;
                        for (var i = 0; i < modelData.items.length; i++) {
                            if (shouldShowItem(modelData.items[i])) {
                                return true;
                            }
                        }
                        return false;
                    }

                    visible: hasVisibleItems

                    StyledText {
                        text: modelData?.section ?? ""
                        width: parent.width
                        leftPadding: 15
                        bottomPadding: 5
                        topPadding: index > 0 ? 10 : 0
                        color: root.colors.colSubtext
                        font.pixelSize: Fonts.sizes.small
                        font.weight: 600
                        visible: parent.hasVisibleItems
                    }

                    GridLayout {
                        width: parent.width
                        columns: root.columnNumber
                        columnSpacing: Padding.verysmall
                        rowSpacing: Padding.verysmall

                        Repeater {
                            id: itemsRepeater
                            model: modelData.items

                            delegate: SettingsItem {
                                required property var modelData
                                required property int index

                                topRadius: index === 0 ? Rounding.huge : Rounding.tiny
                                bottomRadius: index === itemsRepeater.model.length - 1 ? Rounding.huge : Rounding.tiny

                                icon: modelData?.icon ?? "settings"
                                name: modelData?.name ?? ""
                                key: modelData?.key ?? ""
                                type: modelData?.type ?? "switch"
                                hint: modelData?.hint ?? ""
                                useStates: modelData?.state ?? false
                                enableTooltip: modelData?.enableTooltip ?? true
                                sliderMinValue: modelData?.sliderMinValue ?? 0.0
                                sliderMaxValue: modelData?.sliderMaxValue ?? 100.0
                                realValue: modelData?.sliderValue ?? 0.5
                                reloadOnChange: modelData?.reloadOnChange ?? false
                                customItemHeight: modelData?.customItemHeight ?? 65
                                actionName: modelData?.actionName ?? ""
                                comboBoxValues: modelData?.comboBoxValues ?? []
                                fillHeight: modelData?.fillHeight ?? false
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                visible: (modelData?.visible ?? true) && shouldShowItem(modelData)
                                colors: root.colors
                            }
                        }
                    }
                }
            }
        }
    }
}
