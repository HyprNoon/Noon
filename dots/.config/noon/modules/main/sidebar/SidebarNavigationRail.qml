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
        intensity: 0.5
        color: colors.colShadow
    }

    StyledRect {
        id: bg
        anchors.fill: parent
        color: colors.colLayer2

        ListView {
            id: navRailList
            anchors.centerIn: parent
            implicitWidth: Sizes.sidebar.bar * 2 / 3
            implicitHeight: contentHeight
            clip: true
            spacing: sleek ? Padding.normal : Padding.verylarge
            model: SidebarData.enabledCategories
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

                fontSize: 12
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
                    extraVisibleCondition: selectedCategory !== ""
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
