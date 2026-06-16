import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import qs.common
import qs.services
import "./../common"
import qs.common.widgets

PopupWindow {
    id: root
    property var bar
    visible: true
    color: "transparent"
    implicitWidth: bg.implicitWidth + Padding.massive * 3
    implicitHeight: bg.implicitHeight + Padding.massive * 3
    FocusHandler {
        windows: [bar]
        onCleared: root.visible = false
        active: visible
    }
    anchor {
        window: bar
        adjustment: PopupAdjustment.None
        gravity: Edges.Bottom | Edges.Right
        edges: Edges.Bottom | Edges.right
        rect {
            x: bar.width - width - Padding.massive
            y: bar.height - Padding.massive
        }
    }

    Item {
        anchors.fill: parent
        StyledRect {
            id: bg
            implicitWidth: 300
            implicitHeight: 450
            anchors.centerIn: parent
            radius: 30
            enableBorders: true
            color: Colors.colLayer3
            ColumnLayout {
                id: content
                anchors.fill: parent
                anchors.margins: Padding.large

                RowLayout {
                    StyledText {
                        Layout.fillWidth: true
                        Layout.leftMargin: Padding.large
                        Layout.preferredHeight: 50
                        text: "Clipboard"
                        font.pixelSize: 24
                        font.family: "Roboto"
                        font.weight: Font.DemiBold
                        color: Colors.colOnLayer3
                    }
                    GButtonWithIcon {
                        iconSource: "window-close-symbolic"
                        implicitSize: 30
                        iconSize: 20
                        Layout.rightMargin: Padding.large
                        onPressed: root.visible = false
                    }
                }
                Separator {}
                StyledListView {
                    id: list
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    clip: true
                    radius: bg.radius - content.anchors.margins
                    model: ClipboardService.entries
                    delegate: StyledRect {
                        required property var modelData
                        width: list.width
                        height: 40
                        radius: Rounding.large
                        color: {
                            if (_event_area.containsMouse && !_event_area.pressed)
                                Colors.colLayer4Hover;
                            else if (_event_area.pressed)
                                Colors.colLayer4Active;
                            else
                                Colors.colLayer3;
                        }
                        MouseArea {
                            id: _event_area
                            z: 99
                            hoverEnabled: true
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onPressed: {
                                ClipboardService.copy(modelData);
                                Qt.callLater(() => root.visible = false);
                            }
                        }

                        StyledText {
                            id: text
                            anchors {
                                fill: parent
                                leftMargin: Padding.large
                                rightMargin: Padding.massive
                            }
                            text: modelData
                            elide: Text.ElideRight
                            wrapMode: Text.Wrap
                            maximumLineCount: 1

                            font {
                                pixelSize: 16
                                family: "Roboto"
                                weight: Font.Normal
                            }
                        }
                    }
                }
            }
        }
        StyledRectangularShadow {
            target: bg
        }
    }
}
