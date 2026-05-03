import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.common

ColumnLayout {
    id: root

    required property var tabButtonList // Something like [{"icon": "notifications", "name": qsTr("Notifications")}, {"icon": "volume_up", "name": qsTr("Volume mixer")}]
    required property var externalTrackedTab
    property bool enableIndicatorAnimation: false
    property color colIndicator: Colors.colPrimary ?? "#65558F"
    property bool centerTabBar: parent.width > 500
    property alias currentIndex: tabBar.currentIndex

    spacing: Padding.tiny
    Layout.fillWidth: !centerTabBar
    Layout.alignment: Qt.AlignHCenter
    implicitWidth: Math.max(tabBar.implicitWidth, 600)

    TabBar {
        id: tabBar

        Layout.fillWidth: true
        currentIndex: root.externalTrackedTab

        Repeater {
            model: root.tabButtonList

            delegate: PrimaryTabButton {
                selected: (index == root.externalTrackedTab)
                buttonText: modelData.name
                buttonIcon: modelData.icon
                minimumWidth: 160
            }
        }

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
    }

    // Tab indicator
    Item {
        id: tabIndicator

        Layout.fillWidth: true
        height: 3

        Connections {
            function onExternalTrackedTabChanged() {
                root.enableIndicatorAnimation = true;
            }

            target: root
        }

        Rectangle {
            id: indicator

            property int tabCount: root.tabButtonList.length
            property real fullTabSize: root.width / tabCount
            property real targetWidth: tabBar.contentItem.children[0].children[tabBar.currentIndex].tabContentWidth

            implicitWidth: targetWidth
            x: tabBar.currentIndex * fullTabSize + (fullTabSize - targetWidth) / 2
            color: root.colIndicator
            radius: Rounding.full ?? 9999

            anchors {
                top: parent.top
                bottom: parent.bottom
            }

            Behavior on x {
                Anim {}
            }

            Behavior on implicitWidth {
                Anim {}
            }
        }
    }

    Rectangle {
        visible: false
        Layout.fillWidth: true
        implicitHeight: 1
        color: Colors.m3.m3onSurfaceVariant
        opacity: 0.2
        Layout.margins: 6
        Layout.bottomMargin: 0
        Layout.topMargin: 0
    }
}
