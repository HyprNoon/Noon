import qs.services
import qs.common
import qs.common.widgets
import qs.common.functions
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

PopupWindow {
    id: root
    property var groupData
    property var parentButton

    // Connections {
    //     target: Globals.main.dock
    //     enabled: Globals.main.dock
    //     function onRevealChanged() {
    //         if (!Globals.main.dock.reveal)
    //             root.visible = false;
    //     }
    // }

    anchor.window: parentButton?.QsWindow.window
    anchor.rect.x: parentButton ? parentButton.mapToItem(null, parentButton?.width / 2, 0).x : 0
    anchor.rect.y: 2 * Sizes.elevationMargin
    anchor.edges: Edges.Top
    anchor.gravity: Edges.Top

    grabFocus: true
    color: "transparent"

    implicitWidth: container.implicitWidth
    implicitHeight: container.implicitHeight
    Item {
        id: container
        implicitWidth: grid.implicitWidth + Sizes.elevationMargin * 4
        implicitHeight: grid.implicitHeight + Sizes.elevationMargin * 5

        StyledRectangularShadow {
            target: bg
        }

        StyledRect {
            id: bg
            color: Colors.colLayer1
            radius: Rounding.verylarge
            enableBorders: true
            anchors.fill: parent
            anchors.margins: Sizes.elevationMargin
            clip: true
            StyledText {
                id: title
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.margins: 4
                text: root.groupData?.appId.charAt(0).toUpperCase() + root.groupData?.appId.slice(1) ?? ""
                font.pixelSize: Fonts.sizes.small
                color: Colors.colOnLayer0
            }
            StyledRect {
                anchors.top: title.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 5
                color: Colors.colLayer3
                radius: Rounding.verylarge - anchors.margins

                Grid {
                    id: grid
                    anchors.centerIn: parent
                    columns: Math.ceil(Math.sqrt(root.groupData?.entries?.length ?? 0))
                    spacing: Padding.small

                    Repeater {
                        model: root.groupData?.entries ?? []
                        delegate: GroupButton {
                            id: popupItem
                            required property var modelData
                            property var de: DesktopEntries.byId(modelData.appId)
                            baseSize: Mem.options.dock.appearance.iconSize * 1.25
                            buttonRadius: Rounding.normal
                            colBackground: "transparent"

                            Drag.active: dragHandler.active
                            Drag.hotSpot.x: width / 2
                            Drag.hotSpot.y: height / 2
                            Drag.mimeData: ({
                                    "text/plain": modelData.appId
                                })
                            Drag.dragType: Drag.Automatic
                            Drag.onDragStarted: {
                                parentButton.appListRoot.draggingAppId = modelData.appId;
                                parentButton.appListRoot.draggingFromGroup = root.groupData.gid;
                            }
                            Drag.onDragFinished: {
                                parentButton.appListRoot.draggingAppId = "";
                                parentButton.appListRoot.draggingFromGroup = "";
                            }

                            DragHandler {
                                id: dragHandler
                                xAxis.enabled: true
                                yAxis.enabled: true
                                dragThreshold: 8
                                onActiveChanged: {
                                    if (active) {
                                        popupItem.grabToImage(function (result) {
                                            popupItem.Drag.imageSource = result.url;
                                            root.visible = false;
                                            popupItem.Drag.active = true;
                                        });
                                    }
                                }
                            }

                            releaseAction: () => {
                                if (dragHandler.active)
                                    return;
                                const toplevels = (root.groupData?.toplevels ?? []).filter(t => t.appId.toLowerCase() === modelData.appId.toLowerCase());
                                if (toplevels.length > 0)
                                    toplevels[0].activate();
                                else
                                    de?.execute();
                                root.visible = false;
                            }
                            StyledToolTip {
                                bg.enableBorders: true
                                bg.color: Colors.colLayer1
                                content: modelData.appId
                            }
                            contentItem: StyledIconImage {
                                anchors.centerIn: parent
                                width: Mem.options.dock.appearance.iconSize
                                height: width
                                cache: false
                                source: NoonUtils.iconPath(de ? (de.icon || de.genericIcon || "applications-system") : modelData.appId)
                            }
                        }
                    }
                }
            }
        }
    }
}
