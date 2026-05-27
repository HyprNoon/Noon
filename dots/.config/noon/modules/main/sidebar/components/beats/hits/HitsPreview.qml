import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import qs.common
import qs.common.widgets
import qs.services
import QtMultimedia

StyledRect {
    id: root

    property var songData
    readonly property var player: BeatsService.previewer
    onSongDataChanged: BeatsService.previewURL(root.songData.url)
    clip: true
    radius: Rounding.verylarge
    color: "transparent"

    Visualizer {
        z: 0
        active: true
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 2
        RowLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true
            z: 1
            spacing: Padding.massive

            MusicCoverArt {
                implicitSize: 136
                source: songData?.thumbnail ?? ""
            }

            ColumnLayout {
                Layout.fillWidth: true

                StyledText {
                    font.weight: 800
                    font.pixelSize: Fonts.sizes.large
                    Layout.fillWidth: true
                    truncate: true
                    wrapMode: Text.Wrap
                    maximumLineCount: 3
                    text: songData?.title ?? "No Title"
                }

                StyledText {
                    font.pixelSize: Fonts.sizes.verysmall
                    Layout.fillWidth: true
                    text: songData?.artist ?? "No Artist"
                    color: Colors.colSubtext
                }

                ButtonGroup {
                    Layout.topMargin: Padding.large
                    Layout.alignment: Qt.AlignRight | Qt.AlignBottom
                    Layout.fillWidth: false
                    Layout.fillHeight: false

                    Repeater {
                        model: [
                            {
                                icon: "close",
                                action: () => root.player.stop()
                            },
                            {
                                icon: "download",
                                action: () => {
                                    DlpService.request({
                                        url: songData?.url,
                                        audio: true,
                                        quality: "best",
                                        directory: BeatsService.daemonOptions.players.main.musicDirectory
                                    });
                                    root.dismiss();
                                }
                            },
                            {
                                enabled: !root.player.isDecoding,
                                toggled: root.player?.playbackState === MediaPlayer.PlayingState,
                                icon: root.player?.playbackState === MediaPlayer.PlayingState ? "pause" : "play_arrow",
                                action: () => {
                                    root.player.toggle();
                                }
                            }
                        ]

                        delegate: GroupButtonWithIcon {
                            enabled: modelData?.enabled ?? true
                            baseSize: 45
                            buttonRadius: Rounding.small
                            buttonRadiusPressed: Rounding.large
                            toggled: modelData?.toggled ?? false
                            materialIcon: modelData.icon
                            releaseAction: () => modelData.action()
                        }
                    }
                }
            }
        }
        StyledProgressBar {
            Layout.fillWidth: true
            Layout.preferredHeight: 4
            valueBarGap: 4
            showProgressIndicator: false
            value: root.player?.position / root.player?.duration
        }
    }
}
