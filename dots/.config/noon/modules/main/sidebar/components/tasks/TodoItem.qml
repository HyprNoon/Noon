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

    anchors.rightMargin: Padding.normal
    anchors.leftMargin: Padding.normal
    height: Math.max(70, textArea.contentHeight + Padding.massive)
    radius: Rounding.large
    opacity: 0.9
    color: index % 2 !== 0 ? "transparent" : Colors.colLayer2

    StyledRect {
        visible: height > 0
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        width: root.isSelected ? 4 : 0
        height: root.isSelected ? 40 : 0
        rightRadius: Rounding.large
        color: Colors.colPrimary
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
            spacing: Padding.verysmall

            StyledText {
                id: textArea
                opacity: taskData.status === TodoService.Status.Done ? 0.7 : 1
                Layout.fillWidth: true
                wrapMode: TextEdit.Wrap
                font {
                    strikeout: taskData.status === TodoService.Status.Done
                    family: Fonts.family.reading
                    hintingPreference: Font.PreferNoHinting
                    pixelSize: Fonts.sizes.large
                }
                color: Colors.colOnLayer1
                text: taskData.content
            }
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 24
                spacing: Padding.large

                StyledText {
                    id: date
                    visible: modelData.due !== -1
                    color: Colors.colSubtext
                    text: modelData.due + " " + daysRemaining
                    font.pixelSize: 13
                    horizontalAlignment: Text.AlignLeft
                    rightPadding: Padding.massive
                }

                Flow {
                    id: tags
                    spacing: Padding.verysmall
                    Layout.preferredHeight: 22
                    Layout.rightMargin: Padding.huge
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignRight
                    layoutDirection: Qt.RightToLeft
                    Repeater {
                        model: root.taskData.tags
                        delegate: StyledRect {
                            height: 22
                            width: tagText.contentWidth + Padding.huge
                            radius: Rounding.large
                            color: Colors.colSecondaryContainer
                            StyledText {
                                id: tagText
                                text: modelData
                                anchors.centerIn: parent
                                color: Colors.colOnSecondaryContainer
                                font.pixelSize: Fonts.sizes.verysmall
                            }
                        }
                    }
                }
            }
        }
    }
}
