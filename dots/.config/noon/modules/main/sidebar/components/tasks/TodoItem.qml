import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

StyledRect {
    id: root

    property var taskData
    property alias symbol: symb.text
    property alias colSymbol: symb.color
    property bool isEditing: false
    readonly property string daysRemaining: {
        if (!modelData.due)
            return "";
        const parts = modelData.due.split("/");
        if (parts.length !== 2)
            return "";
        const now = new Date();
        const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
        const due = new Date(now.getFullYear(), parseInt(parts[1]) - 1, parseInt(parts[0]));
        if (due < today)
            due.setFullYear(due.getFullYear() + 1);
        const diff = Math.ceil((due - today) / 86400000);
        return diff === 0 ? "today" : diff === 1 ? "tomorrow" : "in " + diff + " days";
    }

    width: 100
    height: 70
    radius: Rounding.large
    opacity: 0.9
    color: index % 2 === 0 ? "transparent" : Colors.colLayer2

    StyledRect {
        visible: height > 0
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        width: root.isSelected ? 4 : 0
        height: root.isSelected ? 40 : 0
        rightRadius: Rounding.large
        color: Colors.colPrimary
    }

    onIsEditingChanged: {
        if (isEditing) {
            textArea.forceActiveFocus();
        }
    }
    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Padding.massive
        spacing: Padding.massive

        Symbol {
            id: symb
            text: {
                const dic = {
                    [0]: "radio_button_unchecked",
                    [1]: "work_history",
                    [2]: "auto_fix_high",
                    [3]: "check_circle"
                };
                return dic[taskData.status] ?? 0;
            }
            fill: 1
            font.pixelSize: 24
            color: Colors.colOnLayer3
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: -1
            TextArea {
                id: textArea
                opacity: taskData.status === TodoService.status_done ? 0.7 : 1
                Layout.fillWidth: true
                wrapMode: TextEdit.Wrap
                renderType: Text.NativeRendering
                readOnly: !root.isEditing
                font {
                    strikeout: taskData.status === TodoService.status_done
                    family: Fonts.family.reading
                    hintingPreference: Font.PreferNoHinting
                    pixelSize: Fonts.sizes.large
                }
                selectByMouse: root.isEditing
                selectedTextColor: Colors.m3.m3onSecondaryContainer
                selectionColor: Colors.colSecondaryContainer
                color: Colors.colOnLayer1
                text: taskData.content
                onTextChanged: {
                    if (root.isEditing) {
                        TodoService.editItem(root.index, text);
                    }
                }
            }

            StyledText {
                id: date
                visible: text !== -1
                color: Colors.colSubtext
                text: modelData.due + " " + daysRemaining
                font.pixelSize: 14
                horizontalAlignment: Text.AlignRight
                Layout.fillWidth: true
                rightPadding: Padding.massive
            }
        }
    }
}
