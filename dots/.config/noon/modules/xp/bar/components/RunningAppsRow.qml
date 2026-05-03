import "../../common"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Qt5Compat.GraphicalEffects
import qs.services
import qs.common
import qs.common.functions
import QtQuick.Effects
import qs.common.widgets

Item {
    id: pinnedAppsRow
    readonly property var activeAppData: ToplevelManager.activeToplevel
    readonly property var appData: ToplevelManager.toplevels
    Layout.fillHeight: true
    Layout.fillWidth: true
    // Layout.leftMargin: XPadding.small
    clip: true
    ScrollView {
        anchors.fill: parent
        contentWidth: 100 // Scrolling per time
        contentHeight: childrenRect.height
        ScrollBar.vertical.policy: ScrollBar.AlwaysOff
        RowLayout {
            spacing: -XPadding.tiny
            anchors.fill: parent
            Repeater {
                model: appData
                StyledRect {
                    id: rect
                    property bool active: modelData.activated
                    Layout.fillHeight: true
                    Layout.margins: XPadding.tiny
                    Layout.minimumWidth: 200
                    border.width: active ? 2 : 0
                    border.color: ColorUtils.transparentize(XColors.colors.colSecondaryBorder, 0.5)
                    color: active ? XColors.colors.colSecondaryDim : eventArea.containsMouse ? XColors.colors.colSecondaryHover : XColors.colors.colSecondary
                    radius: XRounding.small
                    MouseArea {
                        id: eventArea
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onPressed: event => {
                            switch (event.button) {
                            case Qt.LeftButton:
                                modelData.activate();
                                break;
                            case Qt.RightButton:
                                appMenu.popup();
                                break;
                            case Qt.MiddleButton:
                                modelData.close();
                                break;
                            default:
                                modelData.activate();
                            }
                        }
                    }

                    RLayout {
                        anchors.fill: parent
                        anchors.leftMargin: XPadding.large
                        anchors.rightMargin: XPadding.large

                        StyledIconImage {
                            implicitSize: 24
                            source: NoonUtils.iconPath(modelData.appId)
                        }
                        StyledText {
                            truncate: true
                            horizontalAlignment: Text.AlignLeft
                            Layout.fillWidth: true
                            Layout.rightMargin: XPadding.large
                            text: modelData.title
                            color: XColors.colors.colOnSecondary
                        }
                    }
                }
            }

            Spacer {}
        }
    }
}
