import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.Mpris
import qs.common
import qs.services
import qs.common.widgets
import "./../common"

StyledRect {
    id: root
    required property var player
    readonly property bool isPlaying: player.playbackState === MprisPlaybackState.Playing
    property alias hovered: _hoverArea.containsMouse
    Layout.fillWidth: true
    implicitHeight: 65
    color: Colors.colLayer3
    radius: Rounding.verylarge
    enableBorders: isPlaying

    MouseArea {
        id: _hoverArea
        z: 999
        anchors.fill: parent
        hoverEnabled: true
        // propagateComposedEvents: true
        acceptedButtons: Qt.NoButton
        // preventStealing: true
    }

    StyledRectangularShadow {
        target: bg
    }

    StyledRect {
        id: bg
        z: 0
        anchors.fill: parent
        radius: Rounding.verylarge
        color: "transparent"
        clip: true

        BlurImage {
            id: backdrop
            z: 1
            blur: true
            anchors.fill: parent
            source: player?.trackArtUrl ?? ""
            tint: true
            tintColor: Colors.colScrim
            tintLevel: 0.15
        }
        RowLayout {
            id: content
            z: 2

            anchors.fill: parent
            anchors.margins: Padding.normal
            anchors.rightMargin: Padding.huge
            spacing: Padding.normal

            MusicCoverArt {
                source: player?.trackArtUrl ?? ""
                Layout.fillHeight: true
                Layout.preferredWidth: height
                Layout.margins: Padding.tiny
                radius: Rounding.verylarge - Padding.small
            }

            ColumnLayout {
                spacing: Padding.small
                Layout.fillWidth: true
                StyledText {
                    text: root.player?.trackTitle ?? "No Title"
                    font {
                        pixelSize: Fonts.sizes.small
                        variableAxes: Fonts.variableAxes.title
                    }
                    truncate: true
                    Layout.fillWidth: true
                    color: Colors.colOnLayer0
                }
                StyledText {
                    text: root.player?.trackArtist ?? "No Artist"
                    font {
                        pixelSize: Fonts.sizes.verysmall
                        variableAxes: Fonts.variableAxes.main
                    }
                    truncate: true
                    Layout.fillWidth: true
                    color: Colors.colSubtext
                }
            }
            RowLayout {
                Repeater {
                    model: [
                        {
                            "icon": "go-previous-symbolic",
                            "action": function () {
                                root.player.previous();
                            }
                        },
                        {
                            "icon": root.isPlaying ? "media-playback-pause-symbolic" : "media-playback-start-symbolic",
                            "action": function () {
                                root.player.togglePlaying();
                            }
                        },
                        {
                            "icon": "go-next-symbolic",
                            "action": function () {
                                root.player.next();
                            }
                        }
                    ]
                    delegate: StyledIconImage {
                        required property var modelData
                        source: NoonUtils.iconPath(modelData.icon)
                        implicitSize: 20
                        MouseArea {
                            anchors.fill: parent
                            onClicked: () => modelData.action()
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                }
            }
        }
    }
}
