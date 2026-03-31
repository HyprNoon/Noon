import qs.store
import qs.common
import qs.common.widgets
import qs.common.functions
import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

LazyLoader {
    id: root
    property string name: "popup"
    property Item hoverTarget
    default property Item contentItem
    property real popupBackgroundMargin: Padding.verylarge
    property int contentMargins: 40
    property bool extraVisibilityCondition: true
    // unified bar position property
    readonly property string barPosition: Mem.options.bar.behavior.position
    active: hoverTarget && hoverTarget.containsMouse && extraVisibilityCondition
    property bool focus: false
    component: StyledPanel {
        id: popupWindow

        anchors {
            top: barPosition !== "bottom"
            bottom: barPosition === "bottom"
            left: barPosition !== "right"
            right: barPosition === "right"
        }
        name: root.name
        implicitWidth: popupBackground.implicitWidth + Sizes.elevationMargin * 2 + root.popupBackgroundMargin
        implicitHeight: popupBackground.implicitHeight + Sizes.elevationMargin * 2 + root.popupBackgroundMargin

        mask: Region {
            item: popupBackground
        }
        exclusionMode: ExclusionMode.Ignore

        FocusHandler {
            id: grab
            windows: [popupWindow]
            active: root.focus
            onCleared: () => {
                if (!active && !pinned)
                    root.active = false;
            }
        }
        margins {
            left: {
                // Popup placement for top/bottom bars (horizontal)
                if (barPosition === "top" || barPosition === "bottom") {
                    const mapped = root.QsWindow?.mapFromItem(root.hoverTarget, (root.hoverTarget.width - popupBackground.implicitWidth) / 2, 0);
                    if (!mapped)
                        return BarData.currentBarExclusiveSize;

                    const screenWidth = root.QsWindow?.screen?.width || 1920;
                    const popupWidth = popupBackground.implicitWidth + Sizes.elevationMargin * 2 + root.popupBackgroundMargin;

                    // Prevent overflow
                    let leftPos = mapped.x;
                    if (leftPos < 0)
                        leftPos = 0;
                    if (leftPos + popupWidth > screenWidth)
                        leftPos = screenWidth - popupWidth;

                    return Math.max(0, leftPos);
                }

                // For left/right bars, respect exclusive size
                if (barPosition === "left")
                    return BarData.currentBarExclusiveSize + (Sizes.hyprland.gapsOut / 2);

                return 0;
            }

            top: {
                // Popup placement for left/right bars (vertical)
                if (barPosition === "left" || barPosition === "right") {
                    const mapped = root.QsWindow?.mapFromItem(root.hoverTarget, 0, (root.hoverTarget.height - popupBackground.implicitHeight) / 2);
                    if (!mapped)
                        return BarData.currentBarExclusiveSize;

                    const screenHeight = root.QsWindow?.screen?.height || 1080;
                    const popupHeight = popupBackground.implicitHeight + Sizes.elevationMargin * 2 + root.popupBackgroundMargin;

                    // Prevent overflow
                    let topPos = mapped.y;
                    if (topPos < 0)
                        topPos = 0;
                    if (topPos + popupHeight > screenHeight)
                        topPos = screenHeight - popupHeight;

                    return Math.max(0, topPos);
                }

                // For top/bottom bars, respect exclusive size
                if (barPosition === "top")
                    return BarData.currentBarExclusiveSize + (Sizes.hyprland.gapsOut / 2);

                return 0;
            }

            right: barPosition === "right" ? BarData.currentBarExclusiveSize : 0
            bottom: barPosition === "bottom" ? BarData.currentBarExclusiveSize : 0
        }

        WlrLayershell.layer: WlrLayer.Overlay

        StyledRectangularShadow {
            target: popupBackground
        }

        Rectangle {
            id: popupBackground

            anchors {
                fill: parent
                leftMargin: Sizes.elevationMargin + root.popupBackgroundMargin * (barPosition !== "left")
                rightMargin: Sizes.elevationMargin + root.popupBackgroundMargin * (barPosition !== "right")
                topMargin: Sizes.elevationMargin + root.popupBackgroundMargin * (barPosition !== "top")
                bottomMargin: Sizes.elevationMargin + root.popupBackgroundMargin * (barPosition !== "bottom")
            }

            implicitWidth: root.contentItem.implicitWidth + root.contentMargins
            implicitHeight: root.contentItem.implicitHeight + root.contentMargins
            border.width: 1
            border.color: Colors.colOutline
            color: ColorUtils.applyAlpha(Colors.colLayer0, 1 - Colors.transparency)
            radius: Rounding.verylarge

            children: [root.contentItem]
        }
    }
}
