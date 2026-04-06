import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

LockTopInfoContainer {
    id: root
    // visible: BeatsService._playing
    contentItem: RowLayout {
        z: 2
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
