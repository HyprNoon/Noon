import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import qs.services
import qs.common
import qs.common.widgets

Item {
    id: root

    z: -1
    visible: opacity > 0
    anchors.fill: parent
    opacity: showContent ? 1 : 0

    readonly property bool isSynced: syncedLines.length > 0
    readonly property var displayLines: isSynced ? syncedLines : plainLines
    readonly property bool loading: LyricsService.state === "loading"
    readonly property bool showContent: !loading && displayLines.length > 0
    property int currentLine: -1

    property var syncedLines: []
    property var plainLines: []

    Behavior on opacity {
        Anim {}
    }

    function parseLyrics(text, synced) {
        if (!text)
            return [];

        const lines = text.split("\n");
        const result = [];

        for (let i = 0; i < lines.length; i++) {
            const l = lines[i];
            if (!l)
                continue;

            if (synced) {
                if (l[0] === "[" && l.indexOf("]") > 0) {
                    const closeIdx = l.indexOf("]");
                    const timeStr = l.substring(1, closeIdx);
                    const lyricsStr = l.substring(closeIdx + 1).trim();

                    if (!lyricsStr)
                        continue;

                    const splitTime = timeStr.split(":");
                    if (splitTime.length === 2) {
                        result.push({
                            t: parseInt(splitTime[0]) * 60 + parseFloat(splitTime[1]),
                            s: lyricsStr
                        });
                    }
                }
            } else {
                const plainStr = l.trim();
                if (plainStr) {
                    result.push({
                        t: 0,
                        s: plainStr
                    });
                }
            }
        }
        return result;
    }

    function updateLyrics() {
        syncedLines = LyricsService.syncedLyrics ? parseLyrics(LyricsService.syncedLyrics, true) : [];
        if (!isSynced)
            plainLines = LyricsService.plainLyrics ? parseLyrics(LyricsService.plainLyrics, false) : [];
    }

    Component.onCompleted: updateLyrics()

    Connections {
        target: LyricsService
        function onStateChanged() {
            if (LyricsService.state === "loaded")
                updateLyrics();
        }
    }

    Connections {
        target: BeatsService
        function onTitleChanged() {
            syncedLines = [];
            plainLines = [];
            currentLine = -1;
        }
    }

    Timer {
        running: isSynced
        interval: 100
        repeat: true
        onTriggered: {
            let idx = 0;
            const currentPos = BeatsService.player.position;
            for (let i = syncedLines.length - 1; i >= 0; i--) {
                if (currentPos >= syncedLines[i].t) {
                    idx = i;
                    break;
                }
            }
            if (idx !== currentLine) {
                currentLine = idx;
                list.currentIndex = idx;
            }
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

        ListView {
            id: list
            interactive: !isSynced
            spacing: isSynced ? 30 : 16
            model: displayLines
            highlightMoveDuration: 300
            highlightMoveVelocity: -1
            anchors.fill: parent

            preferredHighlightBegin: height / 2 - (currentItem ? currentItem.height / 2 : 0)
            preferredHighlightEnd: height / 2 + (currentItem ? currentItem.height / 2 : 0)
            highlightRangeMode: isSynced ? ListView.StrictlyEnforceRange : ListView.ApplyRange

            delegate: StyledText {
                id: textItem
                required property int index
                required property var modelData
                readonly property bool active: root.isSynced && index === currentLine
                readonly property int dist: Math.abs(index - currentLine)

                anchors.left: parent?.left
                anchors.right: parent?.right

                text: modelData.s
                font.family: Fonts.family.title
                font.pixelSize: Fonts.sizes.title
                font.weight: 750
                color: BeatsService.colors.colOnLayer2
                wrapMode: Text.Wrap
                horizontalAlignment: isSynced ? Text.AlignLeft : Text.AlignCenter

                Behavior on opacity {
                    Anim {}
                }
                Behavior on font.weight {
                    Anim {}
                }

                opacity: active || !isSynced ? 1 : Math.max(0.1, 0.5 - dist * 0.1)

                layer.enabled: isSynced && dist > 0
                layer.effect: FastBlur {
                    radius: Math.max(20, dist * 5)
                    transparentBorder: true
                }
            }
        }
    }
}
