import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import qs.common

GridView {
    id: root

    property bool clip: false
    property int radius: Rounding.large
    property color colBackground: "transparent"
    // Scroll behavior properties
    property real touchpadScrollFactor: Mem.options.interactions.scrolling.touchpadScrollFactor ?? 100
    property real mouseScrollFactor: Mem.options.interactions.scrolling.mouseScrollFactor ?? 50
    property real mouseScrollDeltaThreshold: Mem.options.interactions.scrolling.mouseScrollDeltaThreshold ?? 120
    property real scrollTargetY: 0

    // GridView properties
    maximumFlickVelocity: 3500
    boundsBehavior: Flickable.DragOverBounds
    layer.enabled: root.clip

    Rectangle {
        z: -1
        anchors.fill: root
        color: root.colBackground
    }
    // Custom mouse area for accelerated scrolling

    MouseArea {
        visible: Mem.options.interactions.scrolling.fasterTouchpadScroll ?? true
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        propagateComposedEvents: false
        onWheel: function (wheelEvent) {
            const delta = wheelEvent.angleDelta.y / root.mouseScrollDeltaThreshold;
            // The angleDelta.y of a touchpad is usually small and continuous,
            // while that of a mouse wheel is typically in multiples of ±120.
            var scrollFactor = Math.abs(wheelEvent.angleDelta.y) >= root.mouseScrollDeltaThreshold ? root.mouseScrollFactor : root.touchpadScrollFactor;
            const maxY = Math.max(0, root.contentHeight - root.height);
            const base = root.contentY;
            var targetY = Math.max(0, Math.min(base - delta * (scrollFactor * 0.08), maxY));
            root.scrollTargetY = targetY;
            root.contentY = targetY;
            wheelEvent.accepted = true;
        }
    }

    // Animations for adding/removing items
    add: Transition {
        Anim {
            property: "opacity"
            from: 0
            to: 1
            duration: Animations.durations.small
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Animations.curves.expressiveFastSpatial
        }

        Anim {
            property: "scale"
            from: 0.8
            to: 1
            duration: Animations.durations.small
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Animations.curves.expressiveFastSpatial
        }
    }

    addDisplaced: Transition {
        Anim {
            properties: "x,y"
            duration: Animations.durations.small
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Animations.curves.expressiveFastSpatial
        }
    }

    remove: Transition {
        Anim {
            property: "opacity"
            from: 1
            to: 0
            duration: 150
            easing.type: Easing.InCubic
        }

        Anim {
            property: "scale"
            from: 1
            to: 0.8
            duration: 150
            easing.type: Easing.InCubic
        }
    }

    removeDisplaced: Transition {
        Anim {
            properties: "x,y"
            duration: Animations.durations.small
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Animations.curves.expressiveFastSpatial
        }
    }

    layer.effect: OpacityMask {

        maskSource: Rectangle {
            width: root.width
            height: root.height
            radius: root.radius
        }
    }
}
