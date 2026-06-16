import "../common"
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import qs.common
import qs.common.widgets
import qs.services

ListView {
    id: root

    property real viewScale: 1
    property real bgHeight
    property int cap

    Layout.fillWidth: true
    Layout.preferredHeight: childrenRect.height
    spacing: 0
    maximumFlickVelocity: 1000
    boundsBehavior: Flickable.StopAtBounds

    delegate: Rectangle {
        id: item
        visible: cap ? index < cap : true
        implicitWidth: parent.width
        implicitHeight: root.bgHeight * viewScale || 70 * viewScale
        color: eventArea.containsMouse ? XColors.colors.colPrimary : "transparent"
        MouseArea {
            id: eventArea
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            anchors.fill: parent
            onClicked: {
                DesktopEntries.byId(modelData).execute();
                Globals.xp.showStartMenu = false;
            }
        }
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: XPadding.small * viewScale
            spacing: XPadding.small
            StyledIconImage {
                implicitSize: root.bgHeight * viewScale * 0.7 || 48 * viewScale
                source: NoonUtils.iconPath(modelData)
            }
            ColumnLayout {
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: XPadding.small
                XText {
                    Layout.fillWidth: true
                    Layout.rightMargin: XPadding.normal
                    text: DesktopEntries.byId(modelData).name
                    elide: Text.ElideRight
                    wrapMode: Text.Wrap
                    maximumLineCount: 1
                    font.family: XFonts.family.title
                    font.weight: 900
                    font.pixelSize: XFonts.sizes.normal * viewScale
                    color: eventArea.containsMouse ? XColors.colors.colOnPrimary : "#212121"
                    horizontalAlignment: Qt.AlignLeft
                }
                StyledText {
                    visible: false
                    Layout.fillWidth: true
                    text: DesktopEntries.byId(modelData).description
                    font.pixelSize: XFonts.sizes.small * viewScale
                    color: "#8F8F8F"
                    horizontalAlignment: Qt.AlignLeft
                }
            }
        }
    }
}
