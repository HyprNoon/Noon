import qs.services
import qs.common
import qs.common.widgets
import qs.common.functions

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland

Item {
    id: root
    Layout.fillHeight: true
    implicitWidth: listView.implicitWidth
    StyledListView {
        id: listView
        spacing: 2
        orientation: ListView.Horizontal
        anchors {
            top: parent.top
            bottom: parent.bottom
        }
        implicitWidth: contentWidth
        Behavior on implicitWidth {
            Anim {}
        }

        model: ScriptModel {
            objectProp: "appId"
            values: {
                const pinned = Mem.states.favorites.apps.map(app => app.appId) ?? [];
                const values = [];
                const pinnedSet = new Set();

                // Add pinned apps
                for (const appId of pinned) {
                    const id = appId.toLowerCase();
                    pinnedSet.add(id);
                    values.push({
                        appId: id,
                        pinned: true,
                        toplevels: ToplevelManager.toplevels.values.filter(t => t.appId.toLowerCase() === id)
                    });
                }

                // Check if there are unpinned open apps
                const unpinnedApps = ToplevelManager.toplevels.values.filter(t => !pinnedSet.has(t.appId.toLowerCase()));

                if (pinned.length > 0 && unpinnedApps.length > 0) {
                    values.push({
                        appId: "SEPARATOR",
                        pinned: false,
                        toplevels: []
                    });
                }

                // Add unpinned open apps
                const seen = new Set();
                for (const toplevel of unpinnedApps) {
                    const id = toplevel.appId.toLowerCase();
                    if (!seen.has(id)) {
                        seen.add(id);
                        values.push({
                            appId: id,
                            pinned: false,
                            toplevels: unpinnedApps.filter(t => t.appId.toLowerCase() === id)
                        });
                    }
                }

                return values;
            }
        }

        delegate: StyledLoader {
            required property var modelData
            required property var index
            sourceComponent: {
                switch (modelData) {
                case "SEPARATOR":
                    return separatorComp;
                    break;
                case "VERTICALSEPARATOR":
                    return verticalSeparatorComp;
                    break;
                default:
                    return appComp;
                }
            }
            onLoaded: {
                if ("appToplevel" in _item) {
                    _item.appToplevel = Qt.binding(() => modelData);
                }
            }
        }
    }
    readonly property Component verticalSeparatorComp: VerticalSeparator {
        anchors {
            top: parent.top
            bottom: parent.bottom
            margins: 8
            horizontalCenter: parent.horizontalCenter
        }
    }

    readonly property Component separatorComp: Separator {
        anchors {
            margins: 8
            verticalCenter: parent.verticalCenter
            right: parent.right
            left: parent.left
        }
    }

    readonly property Component appComp: RippleButton {
        id: root

        property var appToplevel
        colBackground: appIsActive ? colBackgroundHover : "transparent"
        anchors.verticalCenter: parent.verticalCenter
        implicitWidth: height
        implicitHeight: 40
        buttonRadius: Rounding.normal

        property int lastFocused: -1
        readonly property real iconSize: 30
        readonly property bool appIsActive: appToplevel.toplevels.find(t => (t.activated == true)) !== undefined

        readonly property var desktopEntry: DesktopEntries?.byId(appToplevel.appId)

        MouseArea {
            id: mouseArea
            enabled: appToplevel.toplevels.length > 0
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
            onEntered: lastFocused = appToplevel.toplevels.length - 1
        }
        StyledToolTip {
            content: root?.desktopEntry?.name ?? ""
            extraVisibleCondition: parent.hovered && content !== ""
        }
        onClicked: {
            if (appToplevel.toplevels.find(item => item.id === appToplevel.toplevels[lastFocused].id)) {
                appToplevel.toplevels[lastFocused].activate();
                return;
            } else {
                root.desktopEntry?.execute();
                lastFocused = (lastFocused + 1) % appToplevel.toplevels.length;
            }
        }

        middleClickAction: () => {
            root.desktopEntry?.execute();
        }

        contentItem: Item {

            IconImage {
                id: icon
                anchors.centerIn: parent
                source: NoonUtils.iconPath(AppSearch.guessIcon(appToplevel.appId))
                implicitSize: root.iconSize
            }

            RowLayout {
                spacing: 2
                anchors {
                    top: icon.bottom
                    topMargin: 4
                    horizontalCenter: parent.horizontalCenter
                }
                Repeater {
                    model: Math.min(appToplevel.toplevels.length, 3)
                    delegate: StyledRect {
                        required property int index
                        radius: Rounding.full
                        implicitWidth: (appToplevel.toplevels.length <= 3) ? (icon.width - Padding.small) / appToplevel.toplevels.length : height // Circles when too many
                        implicitHeight: 3
                        color: appIsActive ? Colors.colPrimary : ColorUtils.transparentize(Colors.colOnLayer0, 0.4)
                    }
                }
            }
        }
    }
}
