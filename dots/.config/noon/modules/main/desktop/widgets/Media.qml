import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Services.Mpris
import qs.services
import qs.common
import qs.common.functions
import qs.common.widgets

ListView {
    id: root
    property bool pill
    property bool expanded
    property real minScale: 0.8
    anchors.centerIn: parent
    clip: true
    orientation: Qt.Horizontal
    highlightRangeMode: ListView.StrictlyEnforceRange
    preferredHighlightBegin: 0
    preferredHighlightEnd: width
    reuseItems: true
    model: BeatsService.meaningfulPlayers
    snapMode: ListView.SnapToItem
    spacing: Padding.massive
    delegate: SquareComponent {
        id: bg
        clip: true
        required property var modelData
        required property int index
        readonly property var player: modelData
        readonly property real delegateCenter: x + width / 2
        readonly property real viewCenter: root.contentX + root.width / 2
        readonly property real distanceFraction: Math.abs(delegateCenter - viewCenter) / root.width
        readonly property bool isPlaying: player.playbackState === MprisPlaybackState.Playing
        readonly property alias isHovered: hoverArea.containsMouse
        scale: Math.max(root.minScale, 1.0 - distanceFraction * (1.0 - root.minScale))
        Behavior on scale {
            Anim {
                duration: 400
            }
        }
        expanded: root.expanded
        pill: root.pill
        width: root.width
        height: root.height
        BlurImage {
            z: 0
            anchors.fill: parent
            source: player.trackArtUrl
            asynchronous: true
            blur: true
            tint: true
            tintLevel: 1
            tintColor: BeatsService.colors.colPrimary
        }
        StyledRect {
            z: 999
            anchors.fill: parent
            opacity: bg.isHovered
            MouseArea {
                id: hoverArea
                anchors.fill: parent
                hoverEnabled: true
                propagateComposedEvents: true
                onClicked: {
                    BeatsService.selectedPlayerIndex = index;
                    NoonUtils.callIpc("sidebar reveal Beats");
                }
            }

            RowLayout {
                anchors.bottomMargin: Padding.massive * 1.25
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                Repeater {
                    model: [
                        {
                            "icon": "skip_previous",
                            "action": () => player?.next()
                        },
                        {
                            "icon": bg.isPlaying ? "pause" : "play_arrow",
                            "action": () => {
                                if (bg.isPlaying) {
                                    player?.pause();
                                } else {
                                    player?.play();
                                }
                            }
                        },
                        {
                            "icon": "skip_next",
                            "action": () => player?.previous()
                        },
                    ]
                    delegate: Symbol {
                        required property var modelData

                        MouseArea {
                            anchors.fill: parent
                            onClicked: () => modelData.action()
                        }
                        text: modelData.icon
                        color: Colors.colOnSurface
                        fill: 1
                        font.pixelSize: 30
                    }
                }
            }
            gradient: Gradient {
                GradientStop {
                    position: 0.1
                    color: "transparent"
                }
                GradientStop {
                    position: 0.9
                    color: Colors.m3.m3shadow
                }
            }
        }
        RowLayout {
            z: 2
            anchors.fill: parent
            anchors.margins: Padding.small
            anchors.leftMargin: Padding.veryhuge
            anchors.rightMargin: Padding.large
            spacing: Padding.massive

            // Cover Art
            MusicCoverArt {
                source: modelData?.trackArtUrl
                visible: player.trackArtUrl.length > 1
                radius: bg.radius - Padding.large
                Layout.preferredWidth: parent.height * 0.86
                Layout.preferredHeight: parent.height * 0.86
            }

            // Track Info
            ColumnLayout {
                visible: root.expanded
                Layout.fillWidth: true
                Layout.rightMargin: Padding.massive
                z: 2
                spacing: 0

                StyledText {
                    font.pixelSize: Fonts.sizes.huge
                    font.variableAxes: Fonts.variableAxes.title
                    color: Colors.colOnLayer0
                    text: player.trackTitle || "No Media Playing"
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
                    text: player.trackArtist || "No Current Artist"
                    elide: Text.ElideRight
                }
            }
        }
    }
}
