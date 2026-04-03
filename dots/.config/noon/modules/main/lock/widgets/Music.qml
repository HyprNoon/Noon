import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

StyledRect {
    id: bg

    z: 0
    implicitWidth: 420
    implicitHeight: 160
    enableBorders: true
    color: "transparent"
    clip: true
    radius: Rounding.verylarge

    Visualizer {
        z: 1
        active: true
        visualizerColor: BeatsService.colors.colPrimary
        maxVisualizerValue: 5000
    }

    BlurImage {
        z: 0
        anchors.fill: parent
        source: BeatsService.artUrl
        asynchronous: true
        blur: true
        tint: true
        tintColor: BeatsService.colors.colPrimaryContainer
        tintLevel: 0.4
    }

    RowLayout {
        z: 2
        anchors.fill: parent
        anchors.margins: Padding.large
        anchors.leftMargin: Padding.massive
        anchors.rightMargin: Padding.massive
        spacing: Padding.massive

        // Cover Art
        MusicCoverArt {
            radius: Rounding.verylarge - Padding.normal
            Layout.preferredWidth: parent.height * 0.86
            Layout.preferredHeight: parent.height * 0.86
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
            StyledProgressBar {
                sperm: true
                highlightColor: BeatsService.colors.colPrimary
                trackColor: BeatsService.colors.colPrimaryContainer
                indicatorColor: BeatsService.colors.colOnLayer0
                valueBarGap: 8
                Layout.preferredHeight: 12
                Layout.fillWidth: true
                value: BeatsService.currentTrackProgressRatio()
            }
        }
    }
}
