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
    readonly property bool sleek: !Mem.options.sidebar.appearance.showNavTitles
    property alias radius: bg.radius
    implicitWidth: Sizes.sidebar.bar
    Layout.fillHeight: true
    property alias color: bg.color

    StyledRectangularShadow {
        target: bg
        show: root.selectedCategory?.length > 0
    }

    StyledRect {
        id: bg
        clip: true
        anchors.fill: parent
        color: colors.colLayer2
        StyledRect {
            z: 9999
            readonly property bool show: SidebarData?.isStealth(root.selectedCategory)
            anchors.fill: parent
            visible: opacity > 0
            opacity: show ? 1 : 0
            color: colors.colLayer2

            StyledRect {
                anchors.centerIn: parent
                color: Colors.colPrimaryContainer
                radius: Rounding.full
                implicitWidth: catName.contentHeight + Padding.small * 2
                implicitHeight: catName.contentWidth + Padding.massive * 2

                StyledText {
                    id: catName
                    text: show ? root.selectedCategory : ""
                    font.pixelSize: Fonts.sizes.large
                    anchors.centerIn: parent
                    rotation: -90
                }
            }
        }
        Item {
            anchors.fill: parent

            ListView {
                id: navRailList
                width: parent.width
                height: Math.min(contentHeight + topMargin + bottomMargin, parent.height)
                anchors.centerIn: parent
                spacing: sleek ? Padding.normal : Padding.verylarge
                model: SidebarData.enabledCategories
                currentIndex: SidebarData.enabledCategories.indexOf(root.selectedCategory)
                interactive: height === parent.height

                displayMarginBeginning: topMargin
                displayMarginEnd: bottomMargin

                topMargin: Padding.huge
                bottomMargin: Padding.huge

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
                        width: navRailList.width * 2 / 3
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
                    baseSize: Math.round(navRailList.width * 2 / 3)
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
                            Globals.main.sidebar.detach(modelData);
                        }
                    }
                }
            }
        }
    }
}
