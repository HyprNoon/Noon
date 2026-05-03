import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets

/**
 * Material 3 expressive style toolbar.
 * https://m3.material.io/components/toolbars
 */
Item {
    id: root

    property real padding: 8
    property alias colBackground: background.color
    property alias spacing: toolbarLayout.spacing
    default property alias data: toolbarLayout.data
    property alias radius: background.radius

    implicitWidth: background.implicitWidth
    implicitHeight: background.implicitHeight

    // StyledRectangularShadow {
    //     target: background
    //     intensity: 0.25
    // }

    LayerRect {
        id: background

        anchors.fill: parent
        colBackground: Colors.m3.m3surfaceContainer // Needs to be opaque
        implicitHeight: Math.max(toolbarLayout.implicitHeight + root.padding * 2, 56)
        implicitWidth: toolbarLayout.implicitWidth + root.padding * 2
        radius: height / 2

        RowLayout {
            id: toolbarLayout

            spacing: 4

            anchors {
                fill: parent
                margins: root.padding
            }
        }
    }
}
