import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Wayland
import Quickshell
import qs.common
import qs.common.widgets
import qs.services
import qs.store
import qs.modules.main.bar.components
import "../widgets"

Variants {
    model: MonitorsInfo.all
    StyledPanel {
        id: root
        required property var modelData
        screen: modelData
        name: "desktop_widgets_layer"
        readonly property string widgetsPath: "../widgets/"
        readonly property var mem: Mem.states.sidebar.widgets
        readonly property var desktop: mem.desktop

        readonly property var widgetObjects: desktop.map(widgetId => {
            const widgetData = WidgetsData.db.find(item => item.id === widgetId);
            return {
                id: widgetId,
                component: widgetData?.component || "",
                expandable: widgetData?.expandable,
                expanded: mem.expanded.find(item => item === widgetId),
                pilled: mem.pilled.find(item => item === widgetId)
            };
        })

        exclusiveZone: 0
        WlrLayershell.layer: WlrLayer.Bottom
        implicitWidth: 600
        anchors {
            right: true
            top: true
            bottom: true
        }
        margins {
            top: Sizes.hyprland?.gapsOut ?? Padding.massive
            bottom: Sizes.hyprland?.gapsOut ?? Padding.massive
            right: Sizes.hyprland?.gapsOut ?? Padding.massive
            left: Sizes.hyprland?.gapsOut ?? Padding.massive
        }
        mask: Region {
            item: flow
        }
        StyledFlow {
            id: flow
            spacing: Padding.huge
            anchors.top: parent.top
            anchors.right: parent.right
            width: 400 + spacing
            Repeater {
                model: ScriptModel {
                    values: root.widgetObjects
                }
                delegate: Item {
                    id: delegated
                    required property var modelData
                    width: modelData.expanded ? parent?.width : (parent?.width - parent?.spacing) / 2
                    height: 200

                    WidgetsContextMenu {
                        id: widgetMenu
                        modelData: delegated.modelData
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        acceptedButtons: Qt.RightButton | Qt.LeftButton
                        onPressed: event => {
                            if (event.button === Qt.RightButton) {
                                widgetMenu.popup();
                            }
                        }
                    }
                    StyledLoader {
                        id: loader
                        anchors.fill: parent
                        asynchronous: true
                        source: root.widgetsPath + modelData.component + ".qml"
                        onLoaded: {
                            if ("expanded" in _item) {
                                _item.expanded = Qt.binding(() => modelData?.expanded ?? false);
                            }
                            if ("pill" in _item) {
                                _item.pill = Qt.binding(() => modelData?.pilled ?? false);
                            }
                            if (!_item.pill)
                                _item.radius = 1.25 * Rounding.massive;
                        }
                    }
                }
            }
        }
    }
}
