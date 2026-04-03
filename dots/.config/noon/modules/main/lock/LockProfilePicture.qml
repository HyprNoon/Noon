import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.common.utils
import qs.common.functions
import qs.services
import Qt5Compat.GraphicalEffects
import QtQuick.Effects

Item {
    id: root
    implicitHeight: 400
    implicitWidth: 400

    Anim on x {
        from: 0
        to: (Screen?.width - width) / 2
        duration: 450
    }

    Anim on y {
        from: Screen.height + 100 // Hidden
        to: (Screen?.height - (height * 1.4)) / 2
        duration: 450
    }

    Shape {
        id: shape
        anchors.centerIn: parent
        implicitSize: 400
        Shape {
            anchors.centerIn: parent
            clip: true
            StyledImage {
                anchors.fill: parent
                source: SysInfoService?.userPfp
            }
            Rectangle {
                z: 999
                anchors.fill: parent
                color: Colors.colPrimary
                opacity: 0.15
            }
            layer.enabled: true
            layer.effect: MultiEffect {
                maskEnabled: true
                maskSource: Shape {}
            }
        }
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowBlur: 50
            shadowColor: "white"
        }
    }
    CLayout {
        anchors {
            top: shape.bottom
            horizontalCenter: shape.horizontalCenter
            topMargin: Padding.massive
        }
        StyledText {
            id: greets
            text: "Welcome Back " + StringUtils.capitalizeFirstLetter(SysInfoService.username) + "!"
            color: Colors.colOnLayer0
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            font {
                variableAxes: Fonts.variableAxes.title
                pixelSize: Fonts.sizes.title * 1.25
            }
        }
        StyledText {
            text: AzkarService?.currentZekr?.content ?? ""
            color: Colors.colSubtext
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
            Layout.maximumWidth: greets.contentWidth
            lineHeight: 1.5
            font {
                weight: 600
                pixelSize: Fonts.sizes.huge
                family: "Rubik"
            }
        }
    }
    component Shape: MaterialShape {
        shape: MaterialShape.Shape.Cookie9Sided
        implicitSize: 340
        color: Colors.colSecondaryContainer
    }
}
