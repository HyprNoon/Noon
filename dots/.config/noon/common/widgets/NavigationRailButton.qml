import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.common
import qs.common.functions
import qs.common.widgets

TabButton {
    id: root

    property bool rightMode: false
    property bool toggled: TabBar.tabBar.currentIndex === TabBar.index
    property bool showText: true
    property string buttonIcon
    property real buttonIconRotation: 0
    property string buttonText
    property int fontSize: 14
    property bool expanded: false
    property bool showToggledHighlight: true
    readonly property real visualWidth: root.expanded ? root.baseSize + 20 + itemText.implicitWidth : root.baseSize
    property real baseSize: 56
    property real baseHighlightHeight: 32
    property real highlightCollapsedTopMargin: 8
    property color highlightColor: Colors.colSecondaryContainer
    property color highlightColorHover: Colors.colSecondaryContainerHover
    property color highlightColorActive: Colors.colSecondaryContainerActive
    property color itemColor: Colors.colOnLayer0
    property color itemColorActive: Colors.colOnSecondaryContainer

    Layout.fillWidth: true
    implicitHeight: baseSize
    background: null

    PointingHandInteraction {}

    // Real stuff
    contentItem: Item {
        id: buttonContent

        implicitWidth: root.visualWidth
        implicitHeight: root.expanded ? itemIconBackground.implicitHeight : itemIconBackground.implicitHeight + itemText.implicitHeight

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: root.rightMode ? undefined : parent.left
            right: root.rightMode ? parent.right : undefined
        }

        Rectangle {
            id: itemBackground

            anchors.top: itemIconBackground.top
            anchors.left: root.rightMode ? undefined : itemIconBackground.left
            anchors.right: root.rightMode ? itemIconBackground.right : undefined
            anchors.bottom: itemIconBackground.bottom
            implicitWidth: root.visualWidth
            radius: Rounding.full
            color: toggled ? root.showToggledHighlight ? (root.down ? root.highlightColorActive : root.hovered ? root.highlightColorHover : root.highlightColor) : ColorUtils.transparentize(root.highlightColor) : (root.down ? root.highlightColorActive : root.hovered ? root.highlightColorHover : ColorUtils.transparentize(root.highlightColorActive, 1))

            states: State {
                name: "expanded"
                when: root.expanded

                AnchorChanges {
                    target: itemBackground
                    anchors.top: buttonContent.top
                    anchors.left: root.rightMode ? undefined : buttonContent.left
                    anchors.right: root.rightMode ? buttonContent.right : undefined
                    anchors.bottom: buttonContent.bottom
                }

                PropertyChanges {
                    target: itemBackground
                    implicitWidth: root.visualWidth
                }
            }

            transitions: Transition {
                AnchorAnimation {
                    duration: Animations.durations.standard
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Animations.curves.expressiveEffects
                }

                PropertyAnimation {
                    target: itemBackground
                    property: "implicitWidth"
                    duration: Appearance.animation.elementMove.duration
                    easing.type: Appearance.animation.elementMove.type
                    easing.bezierCurve: Appearance.animation.elementMove.bezierCurve
                }
            }

            // Behavior on color {
            //     CAnim {}
            // }
        }

        Item {
            id: itemIconBackground

            implicitWidth: root.baseSize
            implicitHeight: root.baseHighlightHeight

            anchors {
                left: root.rightMode ? undefined : parent.left
                right: root.rightMode ? parent.right : undefined
                verticalCenter: parent.verticalCenter
            }

            Symbol {
                id: navRailButtonIcon

                rotation: root.buttonIconRotation
                anchors.centerIn: parent
                font.pixelSize: root.baseSize / 2
                fill: toggled ? 1 : 0
                text: buttonIcon
                color: toggled ? root.itemColorActive : root.itemColor

                Behavior on color {
                    CAnim {}
                }
            }
        }

        StyledText {
            id: itemText

            visible: root.showText
            text: buttonText
            font.pixelSize: root.fontSize
            font.letterSpacing: 0.15
            font.family: Fonts.family.variable
            font.variableAxes: ({
                    "WGHT": 700
                })
            font.weight: 700
            color: Colors.colOnLayer1

            anchors {
                top: itemIconBackground.bottom
                topMargin: 2
                horizontalCenter: itemIconBackground.horizontalCenter
            }

            states: State {
                name: "expanded"
                when: root.expanded

                AnchorChanges {
                    target: itemText

                    anchors {
                        top: undefined
                        horizontalCenter: undefined
                        left: root.rightMode ? undefined : itemIconBackground.right
                        right: root.rightMode ? itemIconBackground.left : undefined
                        verticalCenter: itemIconBackground.verticalCenter
                    }
                }
            }

            transitions: Transition {
                AnchorAnimation {
                    duration: Animations.durations.standard
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Animations.curves.expressiveEffects
                }
            }
        }
    }
}
