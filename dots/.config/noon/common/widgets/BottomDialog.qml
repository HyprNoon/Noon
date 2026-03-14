import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.functions
import qs.common.widgets
import qs.services

Item {
    id: root
    readonly property bool mouseOriented: Mem.options.interactions.mouseOriented ?? true
    property int collapsedHeight: 200
    property int expandedHeight: 400
    property bool expand: false
    property bool show: false
    property bool revealOnWheel: true
    property bool enableStagedReveal: true
    property bool bottomAreaReveal: false
    property int hoverHeight: 100
    property var contentItem
    property bool enableShadows: false
    property alias topRadius: bg.topRadius
    property alias scrim: scrim.visible
    property alias bgAnchors: bg.anchors
    property alias backgroundOpacity: bg.opacity
    readonly property bool reveal: show || bg.visible
    readonly property int targetHeight: show ? (expand && enableStagedReveal ? expandedHeight : collapsedHeight) : 0
    property var finishAction
    property QtObject colors: Colors
    property alias color: bg.color
    onRevealChanged: {
        if (!reveal && finishAction)
            return finishAction();
    }
    anchors.fill: parent
    clip: true

    Rectangle {
        id: scrim

        z: -1
        opacity: root.reveal ? 1 : 0
        color: ColorUtils.transparentize(colors.colScrim, 0.24)
        anchors.fill: parent
        radius: Rounding.verylarge

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: root.show ? Qt.LeftButton : Qt.NoButton
            onClicked: root.show = false
        }

        Behavior on opacity {
            Anim {
                duration: Animations.durations.normal
                easing.bezierCurve: Animations.curves.emphasized
            }
        }
    }

    MouseArea {
        property int scrollSum: 0
        readonly property int threshold: 750

        height: root.bottomAreaReveal ? root.hoverHeight : parent.height
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        scrollGestureEnabled: root.revealOnWheel
        onWheel: wheel => {
            if (!root.revealOnWheel) {
                wheel.accepted = false;
                return;
            }
            scrollSum += wheel.angleDelta.y;
            if (Math.abs(scrollSum) >= threshold) {
                if (scrollSum > 0) {
                    if (!root.show) {
                        root.show = true;
                        root.expand = false;
                    } else if (!root.expand && root.enableStagedReveal) {
                        root.expand = true;
                    }
                } else {
                    if (root.expand && root.enableStagedReveal)
                        root.expand = false;
                    else if (root.show)
                        root.show = false;
                }
                scrollSum = 0;
            }
            wheel.accepted = true;
        }

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
    }

    Item {
        height: ch.implicitHeight
        width: parent.width
        visible: root.mouseOriented
        opacity: root.show ? 0 : 1

        anchors {
            bottom: bg.top
            bottomMargin: Padding.huge
            right: root.right
            left: root.left
        }

        MouseArea {
            anchors.fill: parent
            onPressed: root.show = true
        }

        Behavior on opacity {
            Anim {}
        }

        CLayout {
            id: ch
            anchors.centerIn: parent
            opacity: 0.6
            spacing: 0
            Symbol {
                Layout.alignment: Qt.AlignHCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Fonts.sizes.large
                color: Colors.colSubtext
                fill: 1
                text: "stat_2"
            }
            StyledText {
                Layout.alignment: Qt.AlignHCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Fonts.sizes.small
                color: Colors.colSubtext
                text: "Swipe"
            }
        }
    }
    StyledRect {
        id: bg

        z: 999
        visible: height > 0
        height: root.targetHeight
        topRadius: Rounding.verylarge
        color: root.colors.colLayer0
        children: root.contentItem
        Component.onCompleted: {
            if (contentItem)
                contentItem.anchors.fill = bg;
        }

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        Behavior on anchors.rightMargin {
            Anim {}
        }

        Behavior on anchors.leftMargin {
            Anim {}
        }

        Behavior on height {
            Anim {
                duration: Animations.durations.normal
                easing.bezierCurve: Animations.curves.emphasized
            }
        }
    }
}
