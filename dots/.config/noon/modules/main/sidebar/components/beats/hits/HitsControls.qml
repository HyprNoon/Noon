import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.services

StyledRect {
    id: bg
    z: 9999
    clip: true

    property var songData
    property string mode: ""

    property bool _expanded: mode !== ""
    property alias inputArea: bottomRow.inputArea

    onModeChanged: if (mode)
        _expanded = true

    anchors.margins: Padding.huge
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter

    radius: Rounding.huge
    color: Colors.m3.m3surfaceContainerHighest

    states: [
        State {
            name: "expanded"
            when: _expanded

            PropertyChanges {
                target: bg
                width: parent?.width - (anchors.margins * 2)
                height: 225
            }
        },
        State {
            name: "collapsed"
            when: !_expanded

            PropertyChanges {
                target: bg
                width: root?.isSearching ? 320 : bottomRow?.contentWidth
                height: 65
            }
        }
    ]

    StyledLoader {
        shown: bg._expanded
        fade: true
        anchors.bottom: bottomRow.top
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left

        anchors.leftMargin: Padding.huge
        anchors.rightMargin: Padding.huge

        sourceComponent: dict[bg.mode]

        readonly property var dict: {
            "options": optionsComponent,
            "preview": previewComponent
        }
        readonly property Component optionsComponent: HitsOptions {}
        readonly property Component previewComponent: HitsPreview {}

        onLoaded: {
            if ("songData" in _item)
                _item.songData = Qt.binding(() => bg.songData);
        }
    }
    HitsBottomRow {
        id: bottomRow
        inputArea.text: BeatsHitsService.lastQuery
    }
}
