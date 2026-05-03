import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import Qt5Compat.GraphicalEffects
import qs.common
import qs.common.utils
import qs.store

Menu {
    id: contextMenu
    Material.theme: Material.Dark
    Material.accent: Material.Blue
    Material.roundedScale: Material.SmallScale
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    signal refreshRequested
    signal snapAllRequested
    signal arrangeRequested

    background: Rectangle {
        implicitWidth: 230
        color: Qt.rgba(0.13, 0.13, 0.16, 0.97)
        radius: 10
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            radius: 20
            samples: 41
            color: "#55000000"
            verticalOffset: 6
        }
    }

    Menu {
        title: "Icon Size"
        Material.theme: Material.Dark
        Material.accent: Material.Blue
        Material.roundedScale: Material.SmallScale

        background: Rectangle {
            implicitWidth: 200
            color: Qt.rgba(0.13, 0.13, 0.16, 0.97)
            radius: 10
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                radius: 20
                samples: 41
                color: "#55000000"
                verticalOffset: 6
            }
        }

        Repeater {
            model: [
                {
                    label: "Small",
                    size: 32
                },
                {
                    label: "Medium",
                    size: 48
                },
                {
                    label: "Large",
                    size: 64
                },
                {
                    label: "Extra Large",
                    size: 96
                }
            ]
            delegate: MenuItem {
                required property var modelData
                text: modelData.label
                Material.foreground: root.store.iconSize === modelData.size ? Material.Blue : "white"
                onTriggered: {
                    root.store.iconSize = modelData.size;
                    root.arrangeIcons();
                }
                background: Rectangle {
                    color: parent.highlighted ? Qt.rgba(1, 1, 1, 0.08) : "transparent"
                    radius: 6
                }
            }
        }
    }

    Menu {
        title: "Sort By"
        Material.theme: Material.Dark
        Material.accent: Material.Blue
        Material.roundedScale: Material.SmallScale

        background: Rectangle {
            implicitWidth: 200
            color: Qt.rgba(0.13, 0.13, 0.16, 0.97)
            radius: 10
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                radius: 20
                samples: 41
                color: "#55000000"
                verticalOffset: 6
            }
        }

        Repeater {
            model: [
                {
                    label: "Name",
                    mode: 1
                },
                {
                    label: "Date Modified",
                    mode: 2
                },
                {
                    label: "Type",
                    mode: 3
                }
            ]
            delegate: MenuItem {
                required property var modelData
                text: modelData.label
                Material.foreground: root.store.sortMode === modelData.mode ? Material.Blue : "white"
                onTriggered: {
                    root.store.sortMode = modelData.mode;
                    root.arrangeIcons();
                }
                background: Rectangle {
                    color: parent.highlighted ? Qt.rgba(1, 1, 1, 0.08) : "transparent"
                    radius: 6
                }
            }
        }
    }

    MenuSeparator {
        contentItem: Rectangle {
            implicitHeight: 1
            color: Qt.rgba(1, 1, 1, 0.1)
        }
        background: Item {}
    }

    MenuItem {
        text: "Refresh"
        icon.name: "view-refresh"
        Material.foreground: "white"
        onTriggered: contextMenu.refreshRequested()
        background: Rectangle {
            color: parent.highlighted ? Qt.rgba(1, 1, 1, 0.08) : "transparent"
            radius: 6
        }
    }

    MenuItem {
        text: "Snap All to Grid"
        icon.name: "view-grid"
        Material.foreground: "white"
        onTriggered: contextMenu.snapAllRequested()
        background: Rectangle {
            color: parent.highlighted ? Qt.rgba(1, 1, 1, 0.08) : "transparent"
            radius: 6
        }
    }

    MenuItem {
        text: "Arrange Icons"
        icon.name: "view-sort-ascending"
        Material.foreground: "white"
        onTriggered: contextMenu.arrangeRequested()
        background: Rectangle {
            color: parent.highlighted ? Qt.rgba(1, 1, 1, 0.08) : "transparent"
            radius: 6
        }
    }

    MenuSeparator {
        contentItem: Rectangle {
            implicitHeight: 1
            color: Qt.rgba(1, 1, 1, 0.1)
        }
        background: Item {}
    }

    MenuItem {
        text: "Open Terminal Here"
        icon.name: "utilities-terminal"
        Material.foreground: "white"
        onTriggered: NoonUtils.execDetached(["kitty", "--directory", Directories.standard.home + "/Desktop"])
        background: Rectangle {
            color: parent.highlighted ? Qt.rgba(1, 1, 1, 0.08) : "transparent"
            radius: 6
        }
    }

    MenuItem {
        text: "Open in Files"
        icon.name: "folder-open"
        Material.foreground: "white"
        onTriggered: NoonUtils.execDetached(["gio", "open", Directories.standard.home + "/Desktop"])
        background: Rectangle {
            color: parent.highlighted ? Qt.rgba(1, 1, 1, 0.08) : "transparent"
            radius: 6
        }
    }
}
