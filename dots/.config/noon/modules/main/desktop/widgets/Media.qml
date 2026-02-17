import QtQuick
import QtQuick.Layouts
import qs.services
import qs.common
import qs.common.widgets

IslandComponent {
    id: bg
    clip: true
    BlurImage {
        z: 0
        anchors.fill: parent
        source: BeatsService.artUrl
        asynchronous: true
        blur: true
    }

    RowLayout {
        z: 2
        anchors.fill: parent
        anchors.margins: Padding.large
        anchors.leftMargin: Padding.massive
        anchors.rightMargin: Padding.large
        spacing: Padding.massive

        // Cover Art
        MusicCoverArt {
            visible: BeatsService.artUrl.length > 1
            radius: Rounding.verylarge - Padding.normal
            Layout.preferredWidth: parent.height * 0.86
            Layout.preferredHeight: parent.height * 0.86
        }

        // Track Info
        ColumnLayout {
            Layout.fillWidth: true
            Layout.rightMargin: Padding.massive
            z: 2
            spacing: 0

            StyledText {
                font.pixelSize: Fonts.sizes.huge
                font.variableAxes: Fonts.variableAxes.title
                color: Colors.colOnLayer0
                text: BeatsService.title || "No Media Playing"
                elide: Text.ElideRight
                maximumLineCount: 1
                wrapMode: TextEdit.Wrap
                Layout.fillWidth: true
            }

            StyledText {
                maximumLineCount: 1
                wrapMode: TextEdit.Wrap
                font.pixelSize: Fonts.sizes.large
                font.variableAxes: Fonts.variableAxes.main
                color: Colors.colSubtext
                text: BeatsService.artist || "No Current Artist"
                elide: Text.ElideRight
            }
        }
    }
}
