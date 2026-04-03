import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

Item {
    id: root
    required property var beamComp
    visible: BeatsService._playing
    width: bg.implicitWidth + Padding.massive * 2
    height: bg.implicitHeight + Padding.massive * 2

    Anim on y {
        from: -Screen.height + height
        to: 0
        duration: 300
    }

    Anim on x {
        from: Screen.width + width
        to: Screen?.width - width
        duration: 300
    }

    StyledRect {
        id: bg
        anchors.centerIn: parent
        implicitWidth: 420
        implicitHeight: 80
        color: Colors.colLayer2
        clip: true
        radius: Rounding.full

        RowLayout {
            z: 2
            anchors.fill: parent
            spacing: Padding.huge
            anchors.leftMargin: Padding.huge
            anchors.rightMargin: Padding.huge

            // Cover Art
            MusicCoverArt {
                radius: Rounding.full
                implicitSize: 60
            }

            // Track Info
            ColumnLayout {
                Layout.topMargin: Padding.huge
                Layout.bottomMargin: Padding.huge
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.rightMargin: Padding.massive
                z: 2
                spacing: 0

                StyledText {
                    font.pixelSize: Fonts.sizes.huge
                    font.variableAxes: Fonts.variableAxes.main
                    color: Colors.colOnLayer0
                    text: BeatsService.title.charAt(0).toUpperCase() + BeatsService.title.slice(1) || "No Media Playing"
                    truncate: true
                    Layout.fillWidth: true
                    maximumLineCount: 2
                    Layout.maximumWidth: 300
                }

                StyledText {
                    truncate: true
                    font.pixelSize: Fonts.sizes.normal
                    font.variableAxes: Fonts.variableAxes.main
                    color: Colors.colSubtext
                    text: BeatsService.artist || "No Current Artist"
                    Layout.maximumWidth: 200
                }
                Spacer {}
            }
        }
    }
    StyledRectangularShadow {
        target: bg
        intensity: 0.5
    }
    Anim on anchors.topMargin {
        from: -height - Padding.massive
        to: Padding.massive
    }
}
