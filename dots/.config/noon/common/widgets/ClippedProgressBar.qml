import qs.common
import qs.common.functions
import qs.common.widgets
import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

ProgressBar {
    id: root
    property bool vertical: false
    property real valueBarWidth: 30
    property real valueBarHeight: 18
    property color highlightColor: Colors.colOnSecondaryContainer ?? "#685496"
    property color trackColor: ColorUtils.transparentize(highlightColor, 0.5) ?? "#F1D3F9"
    property alias radius: contentItem.radius
    property bool showEndPoint: true
    property string text
    text: ""

    background: Item {
        implicitHeight: valueBarHeight
        implicitWidth: valueBarWidth
    }
    Behavior on value {
        Anim {}
    }

    contentItem: Rectangle {
        id: contentItem
        anchors.fill: parent
        radius: Rounding.full
        color: root.trackColor

        Rectangle {
            id: progressFill
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
                right: undefined
            }
            width: parent.width * root.visualPosition
            height: parent.height

            states: State {
                name: "vertical"
                when: root.vertical
                AnchorChanges {
                    target: progressFill
                    anchors {
                        top: undefined
                        bottom: parent.bottom
                        left: parent.left
                        right: parent.right
                    }
                }
                PropertyChanges {
                    target: progressFill
                    width: parent.width
                    height: parent.height * root.visualPosition
                }
            }

            radius: Rounding.normal
            color: root.highlightColor
        }
    }

    StyledRect {
        visible: root.showEndPoint
        z: 9999
        anchors {
            top: parent.top
            margins: Padding.normal
            horizontalCenter: parent.horizontalCenter
        }
        radius: Rounding.full
        implicitWidth: parent.width / 4
        implicitHeight: parent.width / 4
        color: progressFill.height === contentItem.height ? Colors.colLayer3 : Colors.colPrimary
    }
}
