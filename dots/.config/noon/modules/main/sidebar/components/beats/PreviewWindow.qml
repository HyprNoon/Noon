import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import qs.services
import qs.common
import qs.common.widgets

Item {
    id: root
    property alias container: bg
    required property var songData
    readonly property bool _currentSong: player.trackTitle === songData?.title
    readonly property bool _playing: player?.playbackState === MprisPlaybackState.Playing && _currentSong
    readonly property var player: {
        BeatsServices.meaningfulPlayers.find(p => {
            if (p.dbusName === "mpv" && p.trackTitle === songData?.title);
            return p;
        });
    }
    Component.onCompleted: BeatsService.previewURL(songData?.url)
    width: 390
    height: 180
    signal dismiss
    MouseArea {
        z: 99
        anchors.fill: parent
        onClicked: dismiss()
    }
    StyledRectangularShadow {
        target: bg
    }

    StyledRect {
        id: bg
        z: 999
        anchors.margins: Padding.normal
        anchors.fill: parent
        color: Colors.colLayer3
        radius: Rounding.huge
        clip: true
        Visualizer {
            active: true
        }
        RowLayout {
            anchors.fill: parent
            anchors.margins: Padding.huge
            spacing: Padding.massive
            MusicCoverArt {
                implicitSize: 136
                source: songData?.thumbnail ?? ""
            }
            ColumnLayout {
                Layout.fillWidth: true
                StyledText {
                    font.weight: 800
                    Layout.fillWidth: true
                    font.pixelSize: Fonts.sizes.large
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
                        model:[
                            {
                                icon: "close",
                                action: () => {
                                    root.dismiss();
                                }
                            },
                            {
                                icon: "download",
                                action: () => {
                                    BeatsService.downloadSong(modelData.url);
                                    root.dismiss();
                                }
                            },
                            {
                                toggled: root._playing,
                                icon: root._playing ? "pause" : "play_arrow",
                                action: () => root.player.togglePlaying();
                            }
                        ]

                        delegate: GroupButtonWithIcon {
                            baseSize: 45
                            buttonRadius: Rounding.small
                            buttonRadiusPressed: Rounding.large
                            toggled: modelData.toggled
                            materialIcon: modelData.icon
                            releaseAction: () => {
                                modelData.action();
                            }
                        }
                    }
                }
            }
        }
    }
}
