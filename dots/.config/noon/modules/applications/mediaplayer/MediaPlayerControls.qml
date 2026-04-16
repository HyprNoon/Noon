import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.utils
import qs.common.widgets

Item {
    id: root

    required property var window
    required property var player
    property bool show: false
    property int seekOffset: 10000 // milliseconds
    implicitWidth: controlsRow.implicitWidth + 2 * Padding.large
    anchors {
        bottom: parent.bottom
        horizontalCenter: parent.horizontalCenter
        bottomMargin: Padding.massive
    }
    Behavior on opacity {
        Anim {}
    }
    Connections {
        target: player
        function on_PlayingChanged() {
            if (player._playing)
                opacity = 1;
        }
    }
    function hide() {
        opacity = 0;
    }
    StyledRect {
        id: bg
        anchors.fill: parent
        color: Colors.m3.m3surfaceContainerHigh
        radius: Rounding.verylarge
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Padding.normal
            RowLayout {
                id: controlsRow
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignHCenter
                spacing: Padding.normal
                Repeater {
                    model: [
                        {
                            "icon": "skip_previous",
                            "action": () => {}
                        },
                        {
                            "icon": "keyboard_double_arrow_left",
                            "action": () => {
                                player.video.position = player.video.position - seekOffset;
                            }
                        },
                        {
                            "icon": player._playing ? "pause" : "play_arrow",
                            "action": () => {
                                if (player._playing) {
                                    player.pause();
                                } else {
                                    player.play();
                                }
                            }
                        },
                        {
                            "icon": "keyboard_double_arrow_right",
                            "action": () => {
                                player.video.position = player.video.position + seekOffset;
                            }
                        },
                        {
                            "icon": "skip_next",
                            "action": () => {}
                        },
                        {
                            "icon": "fullscreen",
                            "action": () => {
                                root.window.fullscreen = !root.window.fullscreen;
                            }
                        }
                    ]
                    delegate: GroupButtonWithIcon {
                        required property var modelData
                        baseSize: bg.height * 0.5
                        materialIcon: modelData.icon
                        releaseAction: () => modelData.action()
                    }
                }
            }
            StyledProgressBar {
                id: progressBar
                visible: root.player._playing
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredHeight: 16
                sperm: true
                value: root.player.position / root.player.duration
                valueBarGap: 8
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onPressed: mouse => {
                        seekTo(mouse.x);
                    }
                    onPositionChanged: mouse => {
                        seekTo(mouse.x);
                    }
                    function seekTo(x) {
                        const ratio = Math.max(0, Math.min(1, x / progressBar.implicitWidth));
                        root.player.position = ratio * root.player.length;
                    }
                }
            }
        }
    }
    StyledRectangularShadow {
        target: bg
    }
    Anim on implicitHeight {
        from: -Sizes.mediaPlayer.controlsSize.height
        to: Sizes.mediaPlayer.controlsSize.height
        duration: 600
    }
}
