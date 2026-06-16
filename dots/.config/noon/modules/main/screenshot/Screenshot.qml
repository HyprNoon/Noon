import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.common
import qs.common.utils
import qs.common.widgets
import qs.services
import qs.store

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        StyledPanel {
            id: panel

            required property var modelData

            name: "blurred_layer"
            shell: "noon"
            fill: true
            visible: Globals.main.showScreenshot
            screen: modelData
            keyboardFocus: true
            mask: Region {
                item: canvas
            }
            RegionSelectorCanvas {
                id: canvas
                anchors.fill: parent
                active: ScreenShotService.isSelecting
                onRegionCommitted: (x, y, w, h) => {
                    ScreenShotService.setRegion(x, y, w, h);
                    Qt.callLater(() => {
                        ScreenShotService.request({
                            temp: false,
                            region: ScreenShotService.Regions.Part
                        });
                    });
                }
            }

            FocusHandler {
                windows: [panel]
                active: Globals.main.showScreenshot
                onCleared: Globals.main.showScreenshot = false
            }

            ScreenShotBottomControls {
                panelWindow: panel
            }
        }
    }
}
