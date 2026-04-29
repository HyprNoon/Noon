import QtQuick
import QtQuick.Layouts
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
    property QtObject colors: Colors
    property string searchQuery: ""

    ScriptModel {
        id: itemsModel
        values: {
            if (!searchQuery)
                return TweaksData.tweaks;

            return TweaksData.tweaks.reduce((acc, entry) => {
                const matchingItems = entry.items.filter(item => item?.name?.toLowerCase().includes(searchQuery.toLowerCase()));

                const sectionMatches = entry.section.toLowerCase().includes(searchQuery.toLowerCase());

                if (sectionMatches) {
                    acc.push(entry);
                } else if (matchingItems.length > 0) {
                    acc.push(Object.assign({}, entry, {
                        items: matchingItems
                    }));
                }

                return acc;
            }, []);
        }
    }

    StyledListView {
        id: list
        anchors.fill: parent
        hint: true
        popin: false
        animateAppearance: false
        model: itemsModel
        reuseItems: false
        spacing: Padding.huge
        delegate: ColumnLayout {
            required property var modelData
            required property int index
            anchors.right: parent?.right
            anchors.left: parent?.left

            StyledText {
                text: modelData?.section ?? ""
                color: Colors.colOnLayer1
                font.weight: 600
                leftPadding: Padding.huge
            }
            Repeater {
                id: itemsRepeater
                model: ScriptModel {
                    values: modelData.items
                }
                delegate: SettingsItem {
                    required property var modelData
                    required property int index

                    topRadius: index === 0 ? Rounding.large : Rounding.tiny
                    bottomRadius: index === itemsRepeater.count - 1 ? Rounding.large : Rounding.tiny
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
                    visible: modelData?.visible ?? true
                    colors: root.colors
                }
            }
        }
    }
    PagePlaceholder {
        anchors.centerIn: parent
        shown: list.count === 0
        icon: "block"
        shape: MaterialShape.Clover4Leaf
        title: "Nothing found"
    }
}
