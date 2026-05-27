import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.common
import qs.common.widgets
import qs.services

StyledPanel {
    id: panelRoot
    name: "blurred_fade_layer"

    property real value
    property string icon
    property var targetScreen

    signal valueModified(real newValue)
    signal interactionStarted
    signal interactionEnded

    mask: Region {
        item: bg
    }

    exclusiveZone: -1
    fill: true

    Connections {
        target: panelRoot
        function onTargetScreenChanged() {
            panelRoot.screen = panelRoot.targetScreen;
        }
    }

    StyledRectangularShadow {
        target: bg
    }

    StyledRect {
        id: bg
        anchors.centerIn: parent

        implicitSize: Sizes.osd.centerIsland.width

        enableBorders: true
        color: Colors.colLayer0
        radius: Rounding.silly

        CircularProgress {
            id: circularProgress
            anchors.centerIn: parent
            value: panelRoot.value
            size: bg.implicitWidth / 1.25
            lineWidth: 10

            property bool valueChanging: true

            Timer {
                id: valueChangeTimer
                interval: 500
                onTriggered: circularProgress.valueChanging = false
            }

            Connections {
                target: panelRoot
                function onValueChanged() {
                    circularProgress.valueChanging = true;
                    valueChangeTimer.restart();
                }
            }

            Symbol {
                animateChange: !circularProgress.valueChanging

                text: circularProgress.valueChanging ? Math.round(panelRoot.value * 100) : panelRoot.icon
                font.family: circularProgress.valueChanging ? Fonts.family.numbers : Fonts.family.iconMaterial
                font.variableAxes: circularProgress.valueChanging ? Fonts.variableAxes.numbers : variableAxes
                font.pixelSize: bg.implicitWidth / 3.85

                color: Colors.colOnLayer0
                anchors.centerIn: parent
            }
        }
    }
}
