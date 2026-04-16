import qs.common
import qs.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris

ColumnLayout {
    id: root

    property bool showCover: false
    readonly property MprisPlayer player: BeatsService.player
    readonly property bool isPlaying: player.playbackState === MprisPlaybackState.Playing
    readonly property var trackColors: BeatsService.colors
    property int spermFrequency: 6

    spacing: Padding.veryhuge
    Layout.fillWidth: true

    RowLayout {
        Layout.preferredHeight: 100
        Layout.fillWidth: true
        spacing: Padding.massive

        Revealer {
            reveal: root?.showCover
            implicitWidth: reveal ? 75 : 0
            implicitHeight: 75

            Item {
                visible: root?.showCover
                anchors.fill: parent

                CroppedImage {
                    anchors.centerIn: parent
                    radius: Rounding.large
                    source: BeatsService.artUrl
                    implicitSize: 75
                    tint: true
                    tintLevel: 0.8
                    tintColor: root.trackColors.colSecondaryContainer
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4

            StyledText {
                Layout.fillWidth: true
                font.pixelSize: Fonts.sizes.huge
                font.weight: Font.Medium
                color: root.trackColors.colOnLayer0
                elide: Text.ElideRight
                maximumLineCount: 2
                text: root.player.trackTitle || "No Title"
                horizontalAlignment: Text.AlignLeft
            }

            StyledText {
                Layout.fillWidth: true
                font.pixelSize: 17
                color: root.trackColors.colOnLayer2
                elide: Text.ElideRight
                maximumLineCount: 1
                text: root.player.trackArtist || "No Artist"
                horizontalAlignment: Text.AlignLeft
            }
        }
    }

    // Progress bar
    StyledProgressBar {
        sperm: true
        value: BeatsService.currentTrackProgressRatio()
        highlightColor: root.trackColors.colPrimary
        trackColor: root.trackColors.colSecondaryContainer
        Layout.fillWidth: true
        Layout.preferredHeight: 18
        spermFrequency: root.spermFrequency
        MouseArea {
            anchors.fill: parent
            enabled: root.player?.canSeek && root.player?.length > 0
            hoverEnabled: true

            property bool isDragging: false

            onPressed: mouse => {
                isDragging = true;
                seekTo(mouse.x);
            }

            onPositionChanged: mouse => {
                if (isDragging)
                    seekTo(mouse.x);
            }

            onReleased: isDragging = false

            function seekTo(x) {
                if (!root.player?.canSeek || !root.player?.length)
                    return;
                const ratio = Math.max(0, Math.min(1, x / width));
                root.player.position = ratio * root.player.length;
            }
        }
    }

    // Media controls
    RowLayout {
        spacing: Padding.small
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        MediaButton {
            materialIcon: "shuffle"
            enabled: root.player?.canControl
            toggled: root.player?.shuffle ?? false
            releaseAction: () => {
                if (root.player)
                    root.player.shuffle = !root.player.shuffle;
            }
        }

        MediaButton {
            materialIcon: "skip_previous"
            enabled: root.player?.canGoPrevious
            releaseAction: () => root.player?.previous()
        }
        Item {
            id: playButton
            implicitHeight: playShape.implicitHeight
            implicitWidth: playShape.implicitWidth
            MaterialShapeWrappedSymbol {
                id: playShape
                color: root.isPlaying ? root.trackColors.colPrimary : root.trackColors.colSecondaryContainer
                shape: root.isPlaying ? MaterialShape.Shape.Cookie9Sided : MaterialShape.Shape.Cookie6Sided
                padding: Padding.massive
                fill: 1
                iconSize: 42
                property double dummy: 0
                property real progress: BeatsService.currentTrackProgressRatio()
                rotation: dummy + progress * 360

                RotationAnimation on dummy {
                    running: true
                    duration: 25000
                    loops: Animation.Infinite
                    from: 0
                    to: 360
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: root.player.togglePlaying()
                }
            }
            Symbol {
                id: playSymbol
                fill: 1
                text: root.isPlaying ? "pause" : "play_arrow"
                color: root.isPlaying ? root.trackColors.colOnPrimary : root.trackColors.colOnSecondaryContainer
                font.pixelSize: 42
                anchors.centerIn: playShape
            }
        }

        MediaButton {
            materialIcon: "skip_next"
            enabled: root.player?.canGoNext
            releaseAction: () => root.player?.next()
        }

        MediaButton {
            materialIcon: root.player?.loopState === MprisLoopState.Track ? "repeat_one" : "repeat"
            enabled: root.player && root.player.canControl
            toggled: root.player?.loopState !== MprisLoopState.None
            releaseAction: () => BeatsService.cycleRepeat()
        }
    }

    component MediaButton: GroupButtonWithIcon {
        Layout.fillHeight: false
        Layout.fillWidth: false
        buttonRadiusPressed: Rounding.tiny
        baseSize: 32
        colors: BeatsService.colors
        buttonRadius: Rounding.large
    }
}
