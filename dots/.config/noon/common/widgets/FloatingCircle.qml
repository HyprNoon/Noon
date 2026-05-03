import QtQuick
import Quickshell
import qs.common
import qs.common.functions

Circle {
    id: circ
    required property int index
    property real baseSpeed: 42
    readonly property real sizeFactor: 0.3 + (index * 0.12)
    readonly property real speedX: baseSpeed * (0.8 + (Math.sin(index) * 0.2))
    readonly property real speedY: baseSpeed * (0.8 + (Math.cos(index) * 0.2))
    z: -1
    implicitSize: parent.width * sizeFactor
    color: ColorUtils.applyAlpha(index % 2 === 0 ? root.colors.colPrimary : root.colors.colSecondaryContainer, 0.1)
    opacity: 0

    ParallelAnimation {
        id: moveAnim
        loops: Animation.Infinite

        NumberAnimation {
            target: circ
            property: "x"
            from: index % 2 === 0 ? parent.width : -circ.width
            to: index % 2 === 0 ? -circ.width : parent.width
            duration: (parent.width + circ.width) / circ.speedX * 1000
            easing.type: Easing.Linear
        }

        NumberAnimation {
            target: circ
            property: "y"
            from: index % 3 === 0 ? parent.height : -circ.height
            to: index % 3 === 0 ? -circ.height : parent.height
            duration: (parent.height + circ.height) / circ.speedY * 1000
            easing.type: Easing.Linear
        }
    }

    Timer {
        interval: 500
        running: true
        onTriggered: {
            circ.opacity = 1;
            moveAnim.restart();
        }
    }
}
