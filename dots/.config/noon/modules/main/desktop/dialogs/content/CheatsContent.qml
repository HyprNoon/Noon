import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.common
import qs.common.widgets
import qs.common.functions
import qs.store
import qs.services
import qs.modules.main.sidebar

Item {
    id: root
    readonly property var keybinds: KeybindsService.keybinds
    anchors.fill: parent
    anchors.margins: Padding.massive * 2

    property var macSymbolMap: ({
            "Ctrl": "󰘴",
            "Alt": "󰘵",
            "Shift": "󰘶",
            "Space": "󱁐",
            "Tab": "↹",
            "Equal": "󰇼",
            "Minus": "",
            "Print": "",
            "BackSpace": "󰭜",
            "Delete": "⌦",
            "Return": "󰌑",
            "Period": ".",
            "Escape": "⎋"
        })
    property var functionSymbolMap: ({
            "F1": "󱊫",
            "F2": "󱊬",
            "F3": "󱊭",
            "F4": "󱊮",
            "F5": "󱊯",
            "F6": "󱊰",
            "F7": "󱊱",
            "F8": "󱊲",
            "F9": "󱊳",
            "F10": "󱊴",
            "F11": "󱊵",
            "F12": "󱊶"
        })

    property var mouseSymbolMap: ({
            "mouse_up": "󱕐",
            "mouse_down": "󱕑",
            "mouse:272": "L󰍽",
            "mouse:273": "R󰍽",
            "Scroll ↑/↓": "󱕒",
            "Page_↑/↓": "⇞/⇟"
        })

    property var keyBlacklist: ["Super_L"]
    property var keySubstitutions: Object.assign({
        "Super": "",
        "mouse_up": "Scroll ↓",
        "mouse_down": "Scroll ↑",
        "mouse:272": "LMB",
        "mouse:273": "RMB",
        "mouse:275": "MouseBack",
        "Slash": "/",
        "Hash": "#",
        "Return": "Enter"
    }, !!Mem.options.cheats.superKey ? {
        "Super": Mem.options.cheats.superKey
    } : {}, Mem.options.cheats.useMacSymbol ? macSymbolMap : {}, Mem.options.cheats.useFnSymbol ? functionSymbolMap : {}, Mem.options.cheats.useMouseSymbol ? mouseSymbolMap : {})

    StyledFlickable {
        id: flickable
        anchors.fill: parent
        contentWidth: twoColLayout.implicitWidth
        contentHeight: twoColLayout.implicitHeight
        clip: true
        flickableDirection: Flickable.VerticalFlick

        GridLayout {
            id: twoColLayout
            columns: 2
            columnSpacing: Padding.massive * 2
            rowSpacing: Padding.massive * 2
            anchors.fill: parent
            Repeater {
                id: repeater
                model: keybinds.children

                delegate: ColumnLayout {
                    required property var modelData
                    spacing: Padding.massive * 2
                    Layout.alignment: Qt.AlignTop
                    Layout.fillWidth: true
                    Layout.preferredWidth: flickable.width / 2
                    Repeater {
                        model: modelData.children

                        delegate: Item {
                            id: keybindSection
                            required property var modelData
                            implicitWidth: sectionColumn.implicitWidth
                            implicitHeight: sectionColumn.implicitHeight

                            Column {
                                id: sectionColumn
                                anchors.top: parent.top
                                spacing: Padding.veryhuge

                                StyledText {
                                    id: sectionTitle
                                    font {
                                        family: Fonts.family.title
                                        pixelSize: Fonts.sizes.subTitle
                                        variableAxes: Fonts.variableAxes.title
                                    }
                                    color: Colors.colOnLayer0
                                    text: keybindSection.modelData.name
                                }

                                GridLayout {
                                    id: keybindGrid
                                    columns: 2
                                    columnSpacing: 4
                                    rowSpacing: 4

                                    Repeater {
                                        model: ScriptModel {
                                            values: {
                                                var result = [];
                                                for (var i = 0; i < keybindSection.modelData.keybinds.length; i++) {
                                                    const keybind = keybindSection.modelData.keybinds[i];

                                                    if (!Mem.options.cheats.splitButtons) {
                                                        for (var j = 0; j < keybind.mods.length; j++) {
                                                            keybind.mods[j] = keySubstitutions[keybind.mods[j]] || keybind.mods[j];
                                                        }
                                                        keybind.mods = [keybind.mods.join(' ')];
                                                        keybind.mods[0] += !keyBlacklist.includes(keybind.key) && keybind.mods[0].length ? ' ' : '';
                                                        keybind.mods[0] += !keyBlacklist.includes(keybind.key) ? (keySubstitutions[keybind.key] || keybind.key) : '';
                                                    }

                                                    result.push({
                                                        "type": "keys",
                                                        "mods": keybind.mods,
                                                        "key": keybind.key
                                                    });
                                                    result.push({
                                                        "type": "comment",
                                                        "comment": keybind.comment
                                                    });
                                                }
                                                return result;
                                            }
                                        }

                                        delegate: Item {
                                            required property var modelData
                                            implicitWidth: keybindLoader.implicitWidth
                                            implicitHeight: keybindLoader.implicitHeight

                                            Loader {
                                                id: keybindLoader
                                                sourceComponent: (modelData.type === "keys") ? keysComponent : commentComponent
                                            }

                                            Component {
                                                id: keysComponent
                                                Row {
                                                    spacing: 4
                                                    Repeater {
                                                        model: modelData.mods
                                                        delegate: KeyboardKey {
                                                            required property var modelData
                                                            key: keySubstitutions[modelData] || modelData
                                                            pixelSize: Mem.options.cheats.fontSize.key
                                                        }
                                                    }
                                                    StyledText {
                                                        id: keybindPlus
                                                        visible: Mem.options.cheats.splitButtons && !keyBlacklist.includes(modelData.key) && modelData.mods.length > 0
                                                        text: "+"
                                                    }
                                                    KeyboardKey {
                                                        id: keybindKey
                                                        visible: Mem.options.cheats.splitButtons && !keyBlacklist.includes(modelData.key)
                                                        key: keySubstitutions[modelData.key] || modelData.key
                                                        pixelSize: Mem.options.cheats.fontSize.key
                                                        color: Colors.colOnLayer0
                                                    }
                                                }
                                            }

                                            Component {
                                                id: commentComponent
                                                Item {
                                                    id: commentItem
                                                    implicitWidth: commentText.implicitWidth + 8 * 2
                                                    implicitHeight: commentText.implicitHeight

                                                    StyledText {
                                                        id: commentText
                                                        anchors.centerIn: parent
                                                        font.pixelSize: Mem.options.cheats.fontSize.comment || Fonts.sizes.small
                                                        text: modelData.comment
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    RippleButtonWithIcon {
        id: refreshButton
        anchors {
            bottom: parent.bottom
            right: parent.right
            margins: Padding.massive
        }
        toggled: true
        implicitSize: 64
        buttonRadius: Rounding.normal
        materialIcon: "refresh"
        releaseAction: () => KeybindsService.reload()
    }
}
