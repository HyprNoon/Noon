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

            name: "fade_layer"
            shell: "noon"
            fill: true
            visible: GlobalStates.main.showScreenshot
            screen: modelData

            RegionSelectorCanvas {
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
                active: visible
            }

            ScreenShotBottomControls {
                panelWindow: panel
            }
        }
    }
}
