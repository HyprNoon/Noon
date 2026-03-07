import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import qs.common
import qs.common.widgets
import qs.services

StyledRect {
    id: root

    clip: true
    radius: Rounding.verylarge
    color: "transparent"
    property bool detached: false
    property bool expanded: false
    readonly property bool playing: BeatsService.player?.playbackState === MprisPlaybackState.Playing
    readonly property bool displayingLyrics: LyricsService.lyrics.length > 0
    property QtObject colors: BeatsService.colors
    Component.onCompleted: {
        BeatsService.checkConnection();
        BeatsService.refreshSocket();
    }
    Behavior on width {
        enabled: false
    }

    Keys.onPressed: event => {
        const ctrl = event.modifiers & Qt.ControlModifier;
        const shift = event.modifiers & Qt.ShiftModifier;
        const player = BeatsService.player;

        if (ctrl && shift) {
            switch (event.key) {
            case Qt.Key_R:
                LyricsService.fetchLyrics(BeatsService.artist || "", BeatsService.title || "");
                break;
            case Qt.Key_Right:
                player?.canControl && player.next();
                break;
            case Qt.Key_Left:
                player?.canControl && player.previous();
                break;
            case Qt.Key_D:
                BeatsService.downloadCurrentSong();
                break;
            case Qt.Key_S:
                player && (player.shuffle = !player.shuffle);
                break;
            default:
                return;
            }
        } else if (ctrl && event.key === Qt.Key_R) {
            BeatsService.cycleRepeat();
        } else {
            switch (event.key) {
            case Qt.Key_Up:
                AudioService?.sink?.audio && (AudioService.sink.audio.volume = Math.min(1.0, AudioService.sink.audio.volume + 0.05));
                break;
            case Qt.Key_Down:
                AudioService?.sink?.audio && (AudioService.sink.audio.volume = Math.max(0.0, AudioService.sink.audio.volume - 0.05));
                break;
            case Qt.Key_Space:
                player?.togglePlaying();
                break;
            case Qt.Key_Right:
                player?.canSeek && player.length && (player.position = Math.min(player.length, player.position + 10));
                break;
            case Qt.Key_Left:
                player?.canSeek && player.length && (player.position = Math.max(0, player.position - 10));
                break;
            default:
                return;
            }
        }
        event.accepted = true;
    }

    Loader {
        z: -2
        active: Mem.options.mediaPlayer.useBlur
        anchors.fill: parent
        sourceComponent: BlurImage {
            anchors.fill: parent
            source: BeatsService.artUrl
            asynchronous: true
            blur: true
            tint: true
            tintLevel: 0.65
            tintColor: root.colors.colSecondaryContainer
        }
    }

    RLayout {
        spacing: Padding.huge

        anchors {
            fill: parent
            margins: detached ? Padding.massive : Padding.large
            rightMargin: 0
        }

        Item {
            id: content
            Layout.fillWidth: true
            Layout.fillHeight: true

            SpotifyLyrics {}

            StyledLoader {
                anchors.centerIn: parent
                width: 300
                height: 300
                fade: true
                asynchronous: true
                active: !root.displayingLyrics
                visible: !root.displayingLyrics
                sourceComponent: MusicCoverArt {
                    anchors.fill: parent
                    clip: true
                    radius: Rounding.massive
                    enableBorders: false
                }
            }

            Visualizer {
                active: Mem.options.mediaPlayer.showVisualizer && root.playing
                mode: Mem.options.mediaPlayer.visualizerMode
                visualizerColor: root.colors.colPrimary
                radius: Rounding.massive
            }

            ColumnLayout {
                spacing: Padding.massive
                anchors.fill: parent
                anchors.margins: Padding.huge

                Spacer {}
                PlayerSelector {}
                MediaPlayerControls {
                    spermFrequency: root.expanded ? Math.round(root.width * 0.014) : 7
                    showCover: root.displayingLyrics
                }

                // StyledLoader {
                //     id: controlsLoader
                //     fade: true
                //     height: _item.implicitHeight
                //     Layout.fillWidth: true
                //     sourceComponent: root.detached ? detachedControls : controls
                //     Component {
                //         id: detachedControls
                //         DetachedMediaPlayerControls {}
                //     }
                //     Component {
                //         id: controls
                //         MediaPlayerControls {
                //             spermFrequency: root.expanded ? Math.round(root.width * 0.014) : 7
                //             showCover: root.displayingLyrics
                //         }
                //     }
                // }
            }
        }

        Item {
            visible: root.expanded
            Layout.maximumWidth: 360
            Layout.rightMargin: root.detached ? Padding.massive : 0
            Layout.fillWidth: true
            Layout.fillHeight: true

            ExpandedTracksList {
                id: expandedTrackList
                anchors.fill: parent
                colors: root.colors
            }

            StyledRectangularShadow {
                visible: root.expanded
                target: expandedTrackList
                intensity: 0.4
            }
        }
    }

    StyledLoader {
        active: !root.expanded
        visible: !root.expanded
        asynchronous: true
        anchors.fill: parent
        sourceComponent: BottomTracksDialog {}
        onLoaded: _item.colors = root.colors
    }

    gradient: Gradient {
        GradientStop {
            color: "transparent"
            Anim on position {
                from: 0
                to: 0.95
                duration: Animations.durations.verylarge
            }
        }
        GradientStop {
            position: 0.05
            color: root.colors.colSecondaryContainer
            CAnim on color {
                from: "transparent"
                to: Mem.options.mediaPlayer.enableGrad ? root.colors.colSecondaryContainer : "transparent"
                duration: Animations.durations.small
            }
        }
    }
}
