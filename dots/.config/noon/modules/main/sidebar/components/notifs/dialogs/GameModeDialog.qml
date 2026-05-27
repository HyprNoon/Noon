import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

BottomDialog {
    id: root
    collapsedHeight: 450
    enableStagedReveal: false

    property var cmd: []
    property var properties: [
        {
            name: "Animations",
            prop: "animations:enabled"
        },
        {
            name: "Shadows",
            prop: "decorations:shadow"
        },
        {
            name: "Blur",
            prop: "decorations:blur:enabled"
        },
        {
            name: "Outer Gaps",
            prop: "general:gaps_out"
        },
        {
            name: "Inner Gaps",
            prop: "general:gaps_in"
        },
        {
            name: "Border",
            prop: "general:border_width"
        }
    ]
    onCmdChanged: Mem.states.services.games.gameModeCommand = cmd
    contentItem: CLayout {
        anchors.fill: parent
        anchors.margins: Padding.massive

        PageHeader {
            title: "Game Mode"
            subTitle: "Choose what to disable"
            target: root
        }
        PageSeparator {}
        Repeater {
            model: root.properties
            delegate: OptionRow {
                title: modelData.name

                onCheckedChanged: {
                    if (checked) {
                        addProp(modelData.prop);
                    } else {
                        remProp(modelData.prop);
                    }
                }
            }
        }
        RLayout {
            Layout.preferredHeight: 50
            Layout.fillWidth: true

            Item {
                Layout.fillWidth: true
            }

            DialogButton {
                buttonText: "Save"
                enabled: true
                onClicked: {
                    root.show = false;
                    console.log(getFinalCommand());
                    Mem.states.services.games.gameModeCommand = getFinalCommand();
                }
            }
        }
    }

    function getFinalCommand() {
        const props = root.cmd.join("; ");
        return `hyprctl --batch "${props}"`;
    }
    function remProp(name) {
        const idx = root.cmd.indexOf("keyword " + name + " 0");
        if (idx !== -1)
            root.cmd.splice(idx, 1);
        root.cmd = root.cmd;
    }

    function addProp(name) {
        root.cmd.push("keyword " + name + " 0");
        root.cmd = root.cmd;
    }

    component OptionRow: RLayout {
        property alias title: text.text
        property alias checked: button.checked
        Layout.fillWidth: true
        Layout.preferredHeight: 55
        Layout.leftMargin: Padding.large
        Layout.rightMargin: Padding.large
        StyledText {
            id: text
            font.pixelSize: Fonts.sizes.small
            font.variableAxes: Fonts.variableAxes.title
            color: Colors.colOnLayer2
            Layout.fillWidth: true
        }
        StyledSwitch {
            id: button
            scale: 0.8
        }
    }
}
