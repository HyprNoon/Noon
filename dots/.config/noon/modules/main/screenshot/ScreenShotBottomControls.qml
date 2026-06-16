import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.common
import qs.common.utils
import qs.common.widgets
import qs.services
import qs.store

Item {
    id: root
    focus: true

    required property var panelWindow
    readonly property bool isPendingArea: currentMode?.region === ScreenShotService.Regions.Part && !ScreenShotService.hasRegion
    readonly property var currentMode: modes[tabBar.currentIndex]

    readonly property list<var> modes: [
        {
            "name": "full",
            "icon": "screenshot_frame_2",
            "hint": "Take a full screenshot",
            "region": ScreenShotService.Regions.Full
        },
        {
            "name": "window",
            "icon": "ad",
            "hint": "Take a screenshot of an active window",
            "region": ScreenShotService.Regions.Window
        },
        {
            "name": "area",
            "icon": "screenshot_region",
            "hint": "Take a screenshot of a selected area",
            "region": ScreenShotService.Regions.Part
        }
    ]
    property bool reveal: Globals.main.showScreenshot

    implicitWidth: bg.implicitWidth
    implicitHeight: Sizes.screenshot.size.height
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter

    Anim on anchors.bottomMargin {
        from: -height
        to: Sizes.elevationMargin
        duration: 600
    }

    function execute() {
        if (root.currentMode.region === ScreenShotService.Regions.Part) {
            ScreenShotService.clearRegion();
            ScreenShotService.startRegionSelect();
        } else {
            ScreenShotService.request({
                region: root.currentMode.region,
                temp: false
            });
        }
    }

    Keys.onReturnPressed: execute()

    StyledRectangularShadow {
        target: bg
    }

    StyledRect {
        id: bg
        anchors.centerIn: parent
        implicitHeight: Sizes.screenshot.size.height
        implicitWidth: contentRow.implicitWidth + Padding.large * 2
        color: Colors.colLayer1
        radius: Rounding.full

        RowLayout {
            id: contentRow
            anchors.centerIn: parent
            spacing: Padding.normal

            ToolbarTabBar {
                id: tabBar
                tabButtonList: root.modes
                currentIndex: 0
                tabButtonhorizontalPadding: Padding.large
                onCurrentIndexChanged: {
                    if (root.currentMode.region !== ScreenShotService.Regions.Part)
                        ScreenShotService.clearRegion();
                }
            }

            VerticalSeparator {
                Layout.margins: Padding.normal
            }

            GroupButtonWithIcon {
                materialIcon: "photo_camera"
                releaseAction: () => execute()
            }
        }
    }
}
