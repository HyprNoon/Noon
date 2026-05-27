import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
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
        name: "blurred_layer"
        readonly property string widgetsPath: "../widgets/"
        readonly property var widgetObjects: WidgetsData.desktopWidgets
        keyboardFocus: true
        exclusiveZone: 0
        _layer: "Bottom"
        implicitWidth: 600
        fill: true

        margins {
            top: Sizes.elevationMargin
            bottom: Sizes.elevationMargin
            right: Sizes.elevationMargin
            left: Sizes.elevationMargin
        }

        mask: Region {
            item: flow
        }

        StyledFlow {
            id: flow
            width: 400 + spacing
            spacing: Padding.huge
            anchors.top: parent.top
            readonly property bool rightMode: Mem.options.bar.behavior.position === "right"

            anchors.left: !rightMode ? parent.left : undefined
            anchors.right: rightMode ? parent.right : undefined

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
                        source: modelData.isPlugin ? modelData.entry : root.widgetsPath + modelData.component + ".qml"
                        onLoaded: {
                            if ("window" in _item)
                                _item.window = Qt.binding(() => root);
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
