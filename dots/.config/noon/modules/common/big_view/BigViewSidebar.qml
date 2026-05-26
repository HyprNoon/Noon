import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

import qs.common
import qs.common.widgets
import qs.services
import qs.store

StyledRect {
    id: root
    z: 2
    required property QtObject states
    property alias selectedIndex: list.currentIndex

    visible: sidebar.anchors.leftMargin > -319
    color: Colors.t(Colors.colScrim, 0.8)
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right

    MouseArea {
        z: 0
        enabled: root.states.sidebarOpen
        anchors.fill: parent
        onClicked: root.states.sidebarOpen = false
    }

    Item {
        id: sidebar
        z: 1
        anchors.leftMargin: root.states.sidebarOpen ? Padding.massive * 2 : -implicitWidth
        implicitWidth: 80
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        Behavior on anchors.leftMargin {
            Anim {}
        }

        StyledRectangularShadow {
            target: sidebarBg
        }

        WrapperRectangle {
            id: sidebarBg
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.left: parent.left
            margin: Padding.normal
            radius: Rounding.verylarge
            color: Colors.colLayer0
            clip: true
            StyledListView {
                id: list
                anchors.centerIn: parent
                implicitHeight: contentHeight
                spacing: Padding.normal
                model: [
                    {
                        name: "Home",
                        icon: "home"
                    },
                    {
                        name: "Games",
                        icon: "sports_esports"
                    },
                    {
                        name: "Movies",
                        icon: "movie"
                    }
                ]
                delegate: RippleButtonWithIcon {
                    required property var modelData
                    required property int index
                    readonly property bool _selected: index === list.currentIndex
                    colBackground: _selected ? Colors.colLayer4 : "transparent"
                    anchors.left: parent?.left
                    anchors.right: parent?.right
                    height: width
                    buttonRadius: Rounding.verylarge
                    materialIcon: modelData?.icon ?? "close"

                    releaseAction: () => {
                        list.currentIndex = index;
                        root.states.sidebarOpen = false;
                    }
                }
            }
        }
    }
}
