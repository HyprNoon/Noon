import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.services
import qs.store

Item {
    id: root
    required property var content
    required property string selectedCategory
    required property QtObject colors
    readonly property double stealth: SidebarData.isStealth(selectedCategory)
    readonly property bool sleek: !Mem.options.sidebar.appearance.showNavTitles
    property alias radius: bg.radius
    implicitWidth: Sizes.sidebar.bar
    Layout.fillHeight: true
    property alias color: bg.color

    StyledRectangularShadow {
        target: bg
        intensity: 0.5
        color: colors.colShadow
    }

    StyledRect {
        id: bg
        clip: true
        anchors.fill: parent
        color: colors.colLayer2
        StyledRect {
            visible: opacity > 0
            opacity: stealth
            anchors.centerIn: parent
            color: Colors.colSecondaryContainer
            radius: Rounding.large
            height: stealthText.contentWidth + Padding.massive * 1.5
            width: stealthText.contentHeight

            StyledText {
                id: stealthText
                anchors.centerIn: parent
                rotation: -90
                text: root.selectedCategory
                font.pixelSize: Fonts.sizes.huge
                color: Colors.colOnSecondaryContainer
                font.variableAxes: Fonts.variableAxes.title
            }
        }
        StyledFlickable {
            visible: !stealth
            opacity: !stealth
            Behavior on opacity {
                Anim {}
            }
            anchors.fill: parent
            contentHeight: Math.max(navRailList.contentHeight + verticalOffset * 2, height)
            readonly property real verticalOffset: Math.max((height - navRailList.contentHeight) / 2, 0)

            ListView {
                id: navRailList
                anchors.centerIn: parent
                implicitWidth: Sizes.sidebar.bar * 2 / 3
                implicitHeight: contentHeight
                spacing: sleek ? Padding.normal : Padding.verylarge
                model: SidebarData.enabledCategories
                y: parent?.verticalOffset ?? 0
                currentIndex: SidebarData.enabledCategories.indexOf(root.selectedCategory)
                highlightFollowsCurrentItem: false
                highlight: Item {
                    width: navRailList.width
                    height: navRailList.currentItem ? navRailList.currentItem.height : 0
                    y: navRailList.currentItem ? navRailList.currentItem.y : 0
                    z: -2

                    Behavior on y {
                        Anim {}
                    }

                    Anim on opacity {
                        from: 0
                        to: 1
                    }

                    StyledRect {
                        anchors.centerIn: parent
                        width: navRailList.width
                        height: width * 0.8
                        radius: width / 2
                        color: root.colors.colSecondaryContainer
                    }
                }

                delegate: NavigationRailButton {
                    required property int index
                    required property string modelData

                    fontSize: 9
                    showText: !root.sleek
                    anchors.horizontalCenter: parent.horizontalCenter
                    implicitWidth: baseSize
                    baseSize: Math.round(navRailList.width)
                    toggled: root.selectedCategory === modelData
                    buttonIcon: SidebarData?.getIcon(modelData, toggled ?? false)
                    buttonText: modelData || ""
                    highlightColor: "transparent"
                    highlightColorHover: index === navRailList?.currentIndex ? "transparent" : root.colors.colLayer2Hover
                    highlightColorActive: "transparent"
                    itemColorActive: root.colors.colOnSecondaryContainer
                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        propagateComposedEvents: true
                        onClicked: event => {
                            if (event.button === Qt.LeftButton)
                                content.changeContent(modelData);
                            else if (event.button === Qt.RightButton)
                                content.incubateContent(modelData);
                        }
                    }
                    StyledToolTip {
                        content: modelData
                        extraVisibleCondition: root.sleek && selectedCategory !== ""
                    }

                    DragHandler {
                        acceptedButtons: Qt.LeftButton
                        xAxis.enabled: true
                        yAxis.enabled: false
                        onActiveChanged: if (SidebarData.isDetachable(modelData) && !SidebarData.isDetached(modelData)) {
                            GlobalStates.main.sidebar.detach(modelData);
                        }
                    }
                }
            }
        }
    }
}
