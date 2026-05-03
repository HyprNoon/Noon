import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import QtQuick.Effects
import Qt5Compat.GraphicalEffects
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

    readonly property real scale: (parent.height + parent.width) / 1000
    readonly property var displayLines: syncedLines.length > 0 ? syncedLines : plainLines
    readonly property bool loading: LyricsService.state === LyricsService.Loading
    readonly property bool showContent: !loading && displayLines.length > 2
    readonly property int currentLineIndex: getCurrentIndex()

    property var syncedLines: []
    property var plainLines: []

    Behavior on opacity {
        Anim {}
    }

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

    Connections {
        target: BeatsService
        function onTitleChanged() {
            syncedLines = [];
            plainLines = [];
        }
    }

    MaterialLoadingIndicator {
        anchors.centerIn: parent
        visible: root.loading
        implicitSize: 240
        color: BeatsService.colors.colPrimary
        shapeColor: BeatsService.colors.colOnPrimary
    }

    Item {
        id: viewContainer
        anchors.fill: parent
        visible: showContent
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: LinearGradient {
                width: viewContainer.width
                height: viewContainer.height
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: "transparent"
                    }
                    GradientStop {
                        position: 0.3
                        color: Colors.colOnLayer0
                    }
                    GradientStop {
                        position: 0.7
                        color: Colors.colOnLayer0
                    }
                    GradientStop {
                        position: 1.0
                        color: "transparent"
                    }
                }
            }
        }

        StyledFlickable {
            id: flick
            anchors.fill: parent
            anchors.leftMargin: Padding.massive
            contentHeight: column.height
            interactive: false
            boundsBehavior: Flickable.StopAtBounds
            Component.onCompleted: syncCurrentLine()

            Column {
                id: column
                width: parent.width - Padding.huge
                spacing: 30

                topPadding: flick.height / 2
                bottomPadding: flick.height / 2

                Repeater {
                    model: displayLines
                    delegate: Item {
                        id: lineWrapper
                        width: column.width
                        height: lineTextItem.height

                        required property int index
                        required property var modelData
                        readonly property bool isCurrent: index === currentLineIndex

                        readonly property int distance: Math.abs(index - currentLineIndex)

                        StyledText {
                            id: lineTextItem
                            width: parent.width
                            text: modelData.lineText
                            font.family: "SF Arabic Rounded"
                            font.weight: isCurrent ? 700 : 600
                            font.pixelSize: Math.max(Fonts.sizes.huge, (isCurrent ? 1.1 : 1.0) * Fonts.sizes.title * scale)
                            font.letterSpacing: -0.5
                            color: BeatsService.colors.colOnLayer2
                            wrapMode: Text.Wrap

                            Behavior on opacity {
                                Anim {}
                            }

                            Behavior on font.pixelSize {
                                Anim {}
                            }

                            opacity: {
                                if (isCurrent)
                                    return 1.0;
                                return Math.max(0.1, 0.5 - (distance * 0.1));
                            }

                            layer.enabled: distance > 0
                            layer.effect: FastBlur {
                                anchors.fill: parent
                                radius: Math.max(15, distance * 4)
                                transparentBorder: true
                            }
                        }
                    }
                }
            }
        }
    }
    function syncCurrentLine() {
        if (currentLineIndex >= 0 && column.children[currentLineIndex]) {
            const lineItem = column.children[currentLineIndex];
            flick.contentY = lineItem.y - (flick.height / 2) + (lineItem.height / 2);
        }
    }
    onCurrentLineIndexChanged: syncCurrentLine()
}
