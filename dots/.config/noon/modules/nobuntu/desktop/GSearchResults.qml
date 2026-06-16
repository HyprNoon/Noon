import QtQuick
import QtQuick.Effects
import Qt5Compat.GraphicalEffects
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.common
import qs.common.functions
import qs.common.widgets
import qs.services
import "./../common"

Item {
    id: root
    property string searchQuery: ""
    property var searchResults: []
    implicitHeight: row.implicitHeight + Padding.massive
    implicitWidth: row.implicitWidth + Padding.massive
    Layout.alignment: Qt.AlignHCenter
    RowLayout {
        id: row
        spacing: Padding.normal
        anchors.centerIn: parent
        Repeater {
            model: {
                const apps = [...DesktopEntries.applications.values];
                const filtered = apps.filter(app => {
                    if (root.searchQuery === "")
                        return true;
                    return app.name.toLowerCase().includes(root.searchQuery.toLowerCase());
                });
                root.searchResults = filtered.slice(0, 5);
                return root.searchResults;
            }

            delegate: Item {
                required property var modelData

                implicitHeight: 125
                implicitWidth: 125

                StyledRect {
                    id: bg
                    enableBorders: true
                    anchors.fill: parent
                    clip: true
                    color: {
                        if (_event_area.containsMouse && !_event_area.pressed)
                            return ColorUtils.transparentize(Colors.colLayer0Hover, 0.9);
                        else if (_event_area.pressed)
                            return ColorUtils.transparentize(Colors.colLayer0Active, 0.9);
                        else
                            return ColorUtils.transparentize(Colors.colLayer0, 0.9);
                    }
                    radius: Rounding.massive
                    StyledIconImage {
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: -10
                        implicitSize: 64
                        source: NoonUtils.iconPath(modelData.icon)
                    }

                    StyledText {
                        text: modelData.name
                        anchors {
                            bottom: parent.bottom
                            bottomMargin: 12
                            right: parent.right
                            left: parent.left
                        }
                        elide: Text.ElideRight
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.Wrap
                        maximumLineCount: 2
                        font.pixelSize: 12
                    }
                    MouseArea {
                        id: _event_area
                        z: 99
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            modelData.execute();
                            Globals.nobuntu.overview.show = false;
                        }
                    }
                }

                MultiEffect {
                    source: bg
                    anchors.fill: bg
                    blurEnabled: false
                    blur: 0.5
                    blurMax: 4
                }
            }
        }
    }
}
