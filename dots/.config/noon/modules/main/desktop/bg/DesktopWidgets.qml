import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Wayland
import Quickshell
import qs.common
import qs.common.widgets
import qs.modules.main.bar.components
import qs.services
import qs.store

Variants {
    model: MonitorsInfo.all
    StyledPanel {
        id: root
        required property var modelData
        screen: modelData
        name: "onScreenWidgets"
        readonly property bool rightMode: Mem.options.bar.behavior.position === "left"
        readonly property string widgetsPath: "../widgets/"
        readonly property var mem: Mem.states.sidebar.widgets
        readonly property var desktop: mem.desktop
        readonly property var widgetObjects: desktop.map(widgetId => {
            const widgetData = WidgetsData.db.find(item => item.id === widgetId);
            return {
                id: widgetId,
                component: widgetData?.component || "",
                expanded: mem.expanded.find(item => item === widgetId),
                pilled: mem.pilled.find(item => item === widgetId)
            };
        })
        exclusiveZone: 0
        WlrLayershell.layer: WlrLayer.Bottom
        implicitWidth: 380
        anchors {
            right: rightMode
            top: true
            bottom: true
            left: !rightMode
        }
        margins {
            top: Sizes.hyprland?.gapsOut ?? Padding.massive
            bottom: Sizes.hyprland?.gapsOut ?? Padding.massive
            right: Sizes.hyprland?.gapsOut ?? Padding.massive
            left: Sizes.hyprland?.gapsOut ?? Padding.massive
        }
        mask: Region {
            item: flow.contentItem
        }
        Flow {
            id: flow
            spacing: Padding.huge
            anchors.fill: parent
            Repeater {
                model: root.widgetObjects
                delegate: Loader {
                    required property var modelData
                    source: root.widgetsPath + modelData.component + ".qml"
                    width: modelData.expanded ? parent.width : 180
                    onLoaded: if (item && modelData) {
                        if ("expanded" in item) {
                            item.expanded = Qt.binding(() => modelData?.expanded ?? false);
                        }
                        if ("pill" in item) {
                            item.pill = Qt.binding(() => modelData?.pilled ?? false);
                        }
                        if (!item.pill)
                            item.radius = 1.25 * Rounding.massive;
                    }
                }
            }
        }
    }
}
