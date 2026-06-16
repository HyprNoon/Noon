import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.common
import qs.common.widgets
import qs.services

StyledPanel {
    id: panelRoot
    name: "blurred_layer"

    property real value
    property string icon
    property var targetScreen

    signal valueModified(real newValue)
    signal interactionStarted
    signal interactionEnded
    visible: true
    exclusiveZone: -1
    _layer: "Overlay"
    fill: true

    mask: Region {
        item: bottomPill
    }

    implicitWidth: bottomPill.implicitWidth
    implicitHeight: bottomPill.implicitHeight + Sizes.elevationMargin * 2

    Connections {
        target: panelRoot
        function onTargetScreenChanged() {
            panelRoot.screen = panelRoot.targetScreen;
        }
    }

    StyledRectangularShadow {
        target: bottomPill
    }

    ShaderRect {
        id: bottomPill

        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: Sizes.elevationMargin

        implicitWidth: Sizes.osd.bottomPill.width
        implicitHeight: Sizes.osd.bottomPill.height

        radius: Rounding.full

        clip: true

        RowLayout {
            anchors.fill: parent
            anchors.margins: Padding.verylarge
            anchors.rightMargin: Padding.massive
            spacing: Padding.veryhuge

            StyledRect {
                id: sideRect
                Layout.fillHeight: true
                implicitSize: height
                color: panelRoot.value > 0 ? Colors.colPrimary : Colors.colLayer2
                radius: Rounding.full

                Symbol {
                    fill: 1
                    anchors.centerIn: parent
                    color: panelRoot.value === 0 ? Colors.colOnSurface : Colors.colOnPrimary
                    icon: panelRoot.icon
                    iconSize: 24
                }
            }

            StyledProgressBar {
                id: valueProgressBar
                Layout.alignment: Qt.AlignCenter
                Layout.fillWidth: true
                valueBarHeight: 5
                showProgressIndicator: false
                valueBarGap: 4
                value: panelRoot.value
            }
        }
    }
}
