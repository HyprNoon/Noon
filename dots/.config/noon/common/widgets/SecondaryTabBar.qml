import qs.common
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

ColumnLayout {
    id: root
    spacing: 0
    clip: true
    required property var tabButtonList // Something like [{"icon": "notifications", "name": qsTr("Notifications")}, {"icon": "volume_up", "name": qsTr("Volume mixer")}]
    property var externalTrackedTab

    property bool enableIndicatorAnimation: false
    property bool enableSpacing: false
    property color colIndicator: Colors.colPrimary ?? "#65558F"
    property color colBorder: Colors.m3.m3outlineVariant ?? "#C6C6D0"
    signal currentIndexChanged(int index)
    property int realFontSize: Fonts.sizes.large
    property bool showIcons: true
    property bool centerTabBar: parent.width > 500
    Layout.fillWidth: !centerTabBar
    Layout.minimumWidth: Math.max(tabBar.implicitWidth, 340)
    Layout.alignment: Qt.AlignHCenter

    TabBar {
        id: tabBar
        spacing: 25
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        background: Item {
            WheelHandler {
                onWheel: event => {
                    if (event.angleDelta.y < 0)
                        tabBar.currentIndex = Math.min(tabBar.currentIndex + 1, root.tabButtonList.length - 1);
                    else if (event.angleDelta.y > 0)
                        tabBar.currentIndex = Math.max(tabBar.currentIndex - 1, 0);
                }
                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            }
        }
        Repeater {
            model: root.tabButtonList
            delegate: SecondaryTabButton {
                colTextSelected: root.colIndicator
                selected: (index == root.externalTrackedTab)
                buttonText: modelData?.name ?? ""
                fontSize: realFontSize
                buttonIcon: modelData?.icon ?? ""
                showIcons: root.showIcons
            }
        }
    }

    Item { // Tab indicator
        id: tabIndicator
        Layout.fillWidth: false
        height: 3
        width: 2

        Connections {
            target: root
            function onExternalTrackedTabChanged() {
                root.enableIndicatorAnimation = true;
            }
        }

        Rectangle {
            id: indicator
            property int tabCount: root.tabButtonList.length
            property real fullTabSize: root.width / Math.max(tabCount, 1) // Prevent division by zero

            // Safe property access with fallback values
            property real targetWidth: {
                if (!tabBar.contentItem || !tabBar.contentItem.children || !tabBar.contentItem.children[0] || !tabBar.contentItem.children[0].children || tabBar.currentIndex < 0 || tabBar.currentIndex >= tabBar.contentItem.children[0].children.length) {
                    return 60; // Default width fallback
                }

                var currentTab = tabBar.contentItem.children[0].children[tabBar.currentIndex];
                if (!currentTab) {
                    return 60; // Default width fallback
                }

                // Try to get the tab content width, with multiple fallback options
                if (currentTab.tabContentWidth !== undefined) {
                    return currentTab.tabContentWidth;
                } else if (currentTab.contentWidth !== undefined) {
                    return currentTab.contentWidth;
                } else if (currentTab.implicitWidth !== undefined) {
                    return currentTab.implicitWidth;
                } else if (currentTab.width !== undefined) {
                    return currentTab.width;
                } else {
                    return 60; // Final fallback
                }
            }

            implicitHeight: 3
            implicitWidth: targetWidth
            anchors {
                top: parent.top
                bottom: parent.bottom
            }

            // Safe x position calculation
            x: {
                var safeCurrentIndex = Math.max(0, Math.min(tabBar.currentIndex, tabCount - 1));
                var xPos = safeCurrentIndex * fullTabSize + (fullTabSize - targetWidth) / 2;
                return Math.max(0, xPos); // Ensure x is never negative
            }

            color: root.colIndicator
            radius: Rounding.full ?? 9999

            Behavior on x {
                enabled: root.enableIndicatorAnimation
                Anim {}
            }
            Behavior on implicitWidth {
                enabled: root.enableIndicatorAnimation
                Anim {}
            }
        }
    }
}
