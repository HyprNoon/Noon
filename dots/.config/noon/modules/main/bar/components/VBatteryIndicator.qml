import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.services

BarGroup {
    id: root

    implicitHeight: 80
    implicitWidth: 80

    MouseArea {
        id: mouseArea
        z: 99
        anchors.fill: parent
        hoverEnabled: true
    }

    BatteryPopup {
        id: batteryPopup
        hoverTarget: mouseArea
    }

    StyledRect {
        id: bg
        anchors.fill: parent
        anchors.margins: Padding.verysmall
        color: Colors.colSurfaceContainer
        radius: Rounding.huge
        clip: true

        Symbol {
            z: 0
            color: Colors.colOnSurface
            fill: 1
            text: "electric_bolt"
            font.pixelSize: Fonts.sizes.small
            visible: BatteryService.isCharging && BatteryService.percentage < 1
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: Padding.normal
        }

        StyledRect {
            z: 1
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: (bg.height * BatteryService.percentage)
            topRadius: Rounding.huge
            color: Colors.colPrimary

            StyledText {
                z: 2
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: Padding.small
                text: Math.round(BatteryService.percentage * 100)
                font.family: Fonts.family.variable
                color: Colors.colOnPrimary
                font.pixelSize: 12
                font.weight: Font.Bold
            }
        }
    }
}
