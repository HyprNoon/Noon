import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import QtQuick.Effects
import qs.common.widgets
import qs.services
import qs.common
import qs.common.functions

Item {
    id: root

    z: -1
    visible: opacity > 0
    anchors.fill: parent
    opacity: showContent ? 1 : 0

    Behavior on opacity {
        Anim {}
    }

    readonly property real scale: (parent.height + parent.width) / 1000
    readonly property var displayLines: syncedLines.length > 0 ? syncedLines : plainLines
    readonly property bool loading: LyricsService.state === LyricsService.Loading
    readonly property bool hasError: LyricsService.state === LyricsService.NetworkError
    readonly property bool noLyricsFound: LyricsService.state === LyricsService.NoLyricsFound
    readonly property bool showContent: !loading && displayLines.length > 2
    readonly property int currentLineIndex: getCurrentIndex()

    property var syncedLines: []
    property var plainLines: []

    Connections {
        target: BeatsService
        function onTitleChanged() {
            syncedLines = [];
            plainLines = [];
        }
    }

    readonly property var stateTexts: ({
            [LyricsService.Loading]: "Loading",
            [LyricsService.NetworkError]: "Network error",
            [LyricsService.NoLyricsFound]: "No lyrics",
            [LyricsService.HasSyncedLyrics]: "Synced",
            [LyricsService.HasPlainLyrics]: "Plain"
        })

    readonly property var stateIcons: ({
            [LyricsService.Idle]: "bedtime",
            [LyricsService.NetworkError]: "cloud_off",
            [LyricsService.NoLyricsFound]: "music_off",
            [LyricsService.Loading]: "hourglass_empty"
        })

    function getCurrentIndex() {
        if (!displayLines?.length || !syncedLines.length)
            return -1;

        for (let i = displayLines.length - 1; i >= 0; i--) {
            if (BeatsService.player.position >= displayLines[i].lineTime)
                return i;
        }
        return 0;
    }

    function parseLyrics(text, synced) {
        if (!text)
            return [];

        return text.split("\n").map(line => {
            if (synced) {
                const m = line.match(/\[(\d+):(\d+\.\d+)\](.*)/);
                return m ? {
                    lineTime: parseInt(m[1]) * 60 + parseFloat(m[2]),
                    lineText: m[3].trim()
                } : null;
            }
            return {
                lineTime: 0,
                lineText: line.trim()
            };
        }).filter(l => l && (!synced || l.lineText));
    }

    function updateLyrics() {
        const data = LyricsService.onlineLyricsData;

        syncedLines = data?.syncedLyrics ? parseLyrics(data.syncedLyrics, true) : [];
        plainLines = !syncedLines.length && data?.plainLyrics ? parseLyrics(data.plainLyrics, false) : [];
    }

    Component.onCompleted: updateLyrics()

    Connections {
        target: LyricsService
        function onOnlineLyricsDataChanged() {
            updateLyrics();
        }
    }

    MaterialLoadingIndicator {
        anchors.centerIn: parent
        visible: root.loading
        implicitSize: 240
        color: BeatsService.colors.colPrimary
        shapeColor: BeatsService.colors.colOnPrimary
    }

    StyledFlickable {
        id: flick

        visible: showContent
        anchors {
            fill: parent
            leftMargin: Padding.verylarge
        }
        boundsBehavior: Flickable.StopAtBounds
        interactive: false

        Column {
            id: column
            width: parent.width
            spacing: 22

            Repeater {
                model: displayLines

                delegate: StyledText {
                    required property int index
                    required property var modelData

                    width: column.width
                    font.family: "Rubik"
                    font.variableAxes: Fonts.variableAxes.lyrics
                    font.pixelSize: index === currentLineIndex ? Fonts.sizes.title * scale : Fonts.sizes.verylarge * scale
                    text: modelData.lineText
                    color: BeatsService.colors.colOnLayer2
                    wrapMode: Text.Wrap
                    opacity: Math.max(0.2, 1 - Math.abs(index - currentLineIndex) / 4)

                    Behavior on font.pixelSize {
                        Anim {}
                    }
                    Behavior on opacity {
                        Anim {}
                    }
                }
            }
        }

        Timer {
            interval: 40
            running: showContent && currentLineIndex >= 0 && column.height > flick.height
            repeat: true
            onTriggered: {
                const lineItem = column.children[currentLineIndex];
                if (lineItem) {
                    flick.contentY += (lineItem.y - flick.height / 2 + lineItem.height / 2 - flick.contentY) * 0.4;
                }
            }
        }
    }
}
