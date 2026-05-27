import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import qs.common
import qs.common.widgets
import qs.services
import Quickshell.Services.Pipewire

StyledPanel {
    id: root
    name: "osd"

    property real value
    property string icon
    property var targetScreen
    property var volumeModel
    property bool volumeMode: false
    property PwNode selectedDevice

    readonly property list<PwNode> appPwNodes: Pipewire.nodes.values.filter(node => {
        return node.isStream && node.audio !== null;
    })

    signal valueModified(real newValue)
    signal interactionStarted
    signal interactionEnded
    visible: true

    anchors {
        right: volumeMode
        left: !volumeMode
    }

    mask: Region {
        item: content
    }

    implicitWidth: contentRow.implicitWidth + Sizes.elevationMargin * 2
    implicitHeight: contentRow.implicitHeight + Math.abs(2 * contentRow.anchors.verticalCenterOffset) + Sizes.elevationMargin * 2

    FocusHandler {
        id: grab
        active: root.visible
    }

    Connections {
        target: root
        function onTargetScreenChanged() {
            root.screen = root.targetScreen;
        }
    }

    RowLayout {
        id: contentRow
        anchors {
            centerIn: parent
            verticalCenterOffset: -100
        }
        implicitHeight: childrenRect.height
        implicitWidth: Sizes.osd.sideBay.width * (root.volumeMode ? Math.max(1, root.appPwNodes.length) : 1)
        spacing: Padding.normal

        StyledRect {
            id: content
            implicitWidth: Sizes.osd.sideBay.width
            implicitHeight: Sizes.osd.sideBay.height
            color: Colors.colLayer0
            radius: Rounding.full
            clip: true

            ColumnLayout {
                id: mainContent
                spacing: Padding.normal
                anchors {
                    fill: parent
                    topMargin: Padding.large
                    bottomMargin: Padding.large
                    margins: Padding.normal
                }
                StyledProgressBar {
                    id: valueProgressBar
                    vertical: true
                    Layout.alignment: Qt.AlignCenter
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    value: root.value
                    valueBarGap: 24
                    showProgressIndicator: false
                }
                StyledText {
                    font {
                        family: Fonts.family.numbers
                        variableAxes: Fonts.variableAxes.numbers
                        pixelSize: Fonts.sizes.small
                    }
                    text: Math.round(root.value * 100)
                    color: Colors.colSecondary
                    Layout.alignment: Qt.AlignCenter
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        Repeater {
            id: repeater
            model: root.volumeMode ? root.appPwNodes : []
            SideBayVEntry {
                required property var modelData
                node: modelData
                onInteractionStarted: root.interactionStarted()
                onInteractionEnded: root.interactionEnded()
            }
        }
    }

    component SideBayVEntry: StyledRect {
        id: entryRoot
        implicitWidth: Sizes.osd.sideBay.width
        implicitHeight: Sizes.osd.sideBay.height
        color: Colors.colLayer0
        radius: Rounding.full
        clip: true
        required property PwNode node
        signal interactionStarted
        signal interactionEnded

        PwObjectTracker {
            objects: [entryRoot.node, entryRoot.node.audio]
        }

        ColumnLayout {
            anchors {
                fill: parent
                topMargin: Padding.large
                bottomMargin: Padding.huge
                margins: Padding.normal
            }
            spacing: Padding.normal

            StyledProgressBar {
                id: slider
                vertical: true
                Layout.alignment: Qt.AlignCenter
                Layout.fillWidth: true
                Layout.fillHeight: true
                valueBarGap: 24
                value: entryRoot.node.audio ? entryRoot.node.audio.volume : 0
                showProgressIndicator: false
                MouseArea {
                    anchors.fill: parent
                    onPressed: event => {
                        event.accepted = false;
                    }
                    onEntered: {
                        entryRoot.interactionStarted();
                    }
                    onExited: {
                        entryRoot.interactionEnded();
                    }
                    cursorShape: slider.pressed ? Qt.ClosedHandCursor : Qt.PointingHandCursor
                    onWheel: wheel => {
                        var delta = wheel.angleDelta.y / 1200;
                        var newValue = Math.max(0, Math.min(1, slider.value + delta));
                        if (entryRoot.node.audio) {
                            entryRoot.node.audio.volume = newValue;
                        }
                        wheel.accepted = true;
                    }
                }
            }

            StyledIconImage {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                Layout.maximumHeight: 30
                implicitSize: 28
                source: {
                    var iconName = entryRoot.node.properties["application.icon-name"] || entryRoot.node.name.toLowerCase();
                    return NoonUtils.iconPath(AppSearch.guessIcon(iconName));
                }
            }
        }
    }
}
