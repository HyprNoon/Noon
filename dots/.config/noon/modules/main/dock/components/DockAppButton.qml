import qs.services
import qs.common
import qs.common.widgets
import qs.common.functions
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

DockButton {
    id: root

    property int lastFocused: -1
    property real countDotWidth: 10

    property var desktopEntry: DesktopEntries.byId(appToplevel.appId)
    colBackground: "transparent"

    StyledToolTip {
        bg.enableBorders: true
        bg.color: Colors.colLayer1
        bg.anchors.bottomMargin: root.iconSize / 10
        content: appToplevel.appId
    }

    Loader {
        anchors.fill: parent
        active: appToplevel.toplevels.length > 0
        sourceComponent: MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
            onEntered: {
                appListRoot.lastHoveredButton = root;
                appListRoot.buttonHovered = true;
                lastFocused = appToplevel.toplevels.length - 1;
            }
            onExited: {
                if (appListRoot.lastHoveredButton === root)
                    appListRoot.buttonHovered = false;
            }
        }
    }

    releaseAction: () => {
        if (dragHandlerActive)
            return;
        if (appToplevel.toplevels.find(item => item.id === appToplevel.toplevels[lastFocused].id)) {
            appToplevel.toplevels[lastFocused].activate();
            return;
        } else {
            root.desktopEntry?.execute();
            lastFocused = (lastFocused + 1) % appToplevel.toplevels.length;
        }
    }

    altAction: () => {
        if (Mem.states.favorites.apps.find(a => a.appId === appToplevel.appId)) {
            Mem.states.favorites.apps = Mem.states.favorites.apps.filter(a => a.appId !== appToplevel.appId);
        } else {
            Mem.states.favorites.apps = Mem.states.favorites.apps.concat([
                {
                    appId: appToplevel.appId,
                    gid: null
                }
            ]);
        }
    }

    contentItem: Item {
        anchors.fill: parent

        Loader {
            id: iconImageLoader
            anchors.centerIn: parent
            width: root.iconSize - Padding.large
            height: root.iconSize - Padding.large
            sourceComponent: StyledIconImage {
                cache: false
                source: NoonUtils.iconPath(root.desktopEntry ? (root.desktopEntry.icon || root.desktopEntry.genericIcon || "applications-system") : appToplevel.appId)
            }
        }

        RowLayout {
            spacing: 2
            height: countDotHeight
            width: countDotWidth * Math.min(appToplevel.toplevels.length, 2)
            anchors {
                top: iconImageLoader.bottom
                topMargin: countDotHeight
                horizontalCenter: parent.horizontalCenter
            }
            Repeater {
                model: Math.min(appToplevel.toplevels.length, 3)
                delegate: StyledRect {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    required property int index
                    radius: Rounding.full
                    Layout.maximumWidth: (appToplevel.toplevels.length <= 3) ? Sizes.infinity : root.countDotHeight
                    implicitHeight: root.countDotHeight
                    color: appIsActive ? Colors.colPrimary : ColorUtils.transparentize(Colors.colOnLayer0, 0.4)
                }
            }
        }
    }
}
