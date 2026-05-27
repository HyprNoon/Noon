import QtQuick
import Quickshell
import qs.common
import qs.common.utils
import qs.common.widgets
import qs.common.functions
import qs.services
import qs.store

Item {
    id: root

    required property bool enableParallax
    required property real effectiveWallpaperScale
    required property real effectiveMovableXSpace
    required property real effectiveMovableYSpace
    required property real bgParallaxX
    required property real bgParallaxY

    property string _current: ""
    property bool toggle: false

    function load(source) {
        if (root._current === source)
            return;
        root._current = source;

        if (transitionAnim.running)
            transitionAnim.stop();

        toggle = !toggle;

        if (toggle) {
            slotB.source = source;
        } else {
            slotA.source = source;
        }

        transitionAnim.start();
    }

    Image {
        id: slotA
        source: !root.toggle ? root._current : ""
        z: root.toggle ? 0 : 1
        fillMode: Image.PreserveAspectCrop
        sourceSize: Qt.size(screen.width, screen.height)
        width: parent.width * root.effectiveWallpaperScale
        height: parent.height * root.effectiveWallpaperScale
        anchors.fill: root.enableParallax ? undefined : root
        x: root.bgParallaxX
        y: root.bgParallaxY

        transform: Scale {
            id: scaleA
            origin.x: slotA.width / 2
            origin.y: slotA.height / 2
        }
    }

    Image {
        id: slotB
        source: root.toggle ? root._current : ""
        z: root.toggle ? 1 : 0
        fillMode: Image.PreserveAspectCrop
        sourceSize: Qt.size(screen.width, screen.height)
        width: parent.width * root.effectiveWallpaperScale
        height: parent.height * root.effectiveWallpaperScale
        anchors.fill: root.enableParallax ? undefined : root
        x: root.bgParallaxX
        y: root.bgParallaxY

        transform: Scale {
            id: scaleB
            origin.x: slotB.width / 2
            origin.y: slotB.height / 2
        }
    }

    SequentialAnimation {
        id: transitionAnim

        ParallelAnimation {
            NumberAnimation {
                target: root.toggle ? slotA : slotB
                property: "opacity"
                to: 0.0
                duration: 400
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                target: root.toggle ? scaleA : scaleB
                properties: "xScale, yScale"
                to: 1.05
                duration: 400
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                target: root.toggle ? slotB : slotA
                property: "opacity"
                to: 1.0
                duration: 400
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                target: root.toggle ? scaleB : scaleA
                properties: "xScale, yScale"
                to: 1.0
                duration: 400
                easing.type: Easing.OutCubic
            }
        }
    }
}
