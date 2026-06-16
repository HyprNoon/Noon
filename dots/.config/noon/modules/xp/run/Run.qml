import "../common"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Qt5Compat.GraphicalEffects
import qs.services
import qs.common
import QtQuick.Effects
import qs.common.widgets

AppWindow {
    id: root
    title: "run"
    visible: Globals.xp.showRun
    maximumSize: XSizes.run.sizeMax
    minimumSize: XSizes.run.size
    onVisibleChanged: {
        inputField.focus = true;
        selectedEntry = null;
        inputField.text = "";
        suggestionPopup.close();
    }
    property var selectedEntry
    property alias suggestions: suggestions
    ScriptModel {
        id: suggestions
        values: {
            const source = DesktopEntries.applications.values;
            const query = inputField.text.toLowerCase();
            if (query.length === 0)
                return [];
            return source.filter(entry => !entry.noDisplay && entry.name.toLowerCase().startsWith(query)).sort((a, b) => a.name.localeCompare(b.name)).slice(0, 8);
        }
    }

    StyledRect {
        anchors.centerIn: parent
        implicitHeight: XSizes.run.size.height
        implicitWidth: XSizes.run.size.width
        color: "#EDEAD9"
        ColumnLayout {
            anchors.fill: parent
            spacing: XPadding.large
            anchors {
                topMargin: XPadding.verylarge
                margins: XPadding.large
            }
            RowLayout {
                id: topArea
                spacing: XPadding.small
                StyledImage {
                    Layout.topMargin: 6
                    source: Directories.assets + "/icons/run.png"
                    implicitSize: 46
                }
                ColumnLayout {
                    spacing: 0
                    XText {
                        text: "Type the name of a program, folder, document, or"
                        color: "#0F0C0C"
                        font {
                            pixelSize: XFonts.sizes.verysmall
                            weight: Font.Light
                        }
                        Layout.alignment: Qt.AlignLeft
                        Layout.fillWidth: true
                        horizontalAlignment: Qt.AlignLeft
                    }
                    XText {
                        text: "Internet resource, and Noon will open it for you."
                        color: "#0F0C0C"
                        font {
                            pixelSize: XFonts.sizes.verysmall
                            weight: Font.Light
                        }
                        Layout.alignment: Qt.AlignLeft
                        Layout.fillWidth: true
                        horizontalAlignment: Qt.AlignLeft
                    }
                }
            }
            RowLayout {
                id: centerArea
                Layout.fillWidth: true
                spacing: XPadding.small
                XText {
                    text: "Open: "
                    color: "#0F0C0C"
                    font {
                        pixelSize: XFonts.sizes.verysmall
                        weight: Font.Light
                    }
                }
                Item {
                    id: inputWrapper
                    Layout.fillWidth: true
                    implicitHeight: 30

                    StyledRect {
                        anchors.fill: parent
                        radius: 0
                        color: "#FEFEFC"
                        border {
                            color: "#A2A5AA"
                            width: 1
                        }
                    }

                    TextArea {
                        id: inputField
                        anchors {
                            left: parent.left
                            top: parent.top
                            bottom: parent.bottom
                            right: dropBtn.left
                        }
                        renderType: Text.NativeRendering
                        color: "#0F0C0C"
                        selectedTextColor: XColors.colors.colOnPrimary
                        selectionColor: XColors.colors.colPrimary
                        placeholderText: ""
                        background: Item {}
                        font {
                            family: XFonts.family.main
                            pixelSize: XFonts.sizes.small + 1
                        }
                        Keys.onDownPressed: {
                            if (root.suggestions.values.length > 0)
                                suggestList.currentIndex = 0;
                            suggestList.forceActiveFocus();
                        }
                        Keys.onEscapePressed: suggestionPopup.close()
                        Keys.onReturnPressed: {
                            if (root.selectedEntry) {
                                root.selectedEntry.execute();
                            }
                            Globals.xp.showRun = false;
                        }
                        onTextChanged: {
                            if (root.suggestions.values.length > 0)
                                suggestionPopup.open();
                            else
                                suggestionPopup.close();
                        }
                    }

                    Rectangle {
                        id: dropBtn
                        anchors {
                            top: parent.top
                            right: parent.right
                            bottom: parent.bottom
                            margins: 2
                        }
                        implicitWidth: 28
                        color: "#B2CBF1"
                        Text {
                            anchors.centerIn: parent
                            anchors.verticalCenterOffset: 2
                            font {
                                family: XFonts.family.monospace
                                pixelSize: 24
                            }
                            text: "󰅀"
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (suggestionPopup.visible)
                                    suggestionPopup.close();
                                else if (suggestList.count > 0)
                                    suggestionPopup.open();
                            }
                        }
                    }

                    Popup {
                        id: suggestionPopup
                        y: parent.height
                        height: Math.min(suggestList.count * 22, 176)
                        width: parent.width
                        padding: 0
                        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
                        background: Rectangle {
                            color: "#FEFEFC"
                            border.color: "#A2A5AA"
                            border.width: 1
                        }
                        contentItem: ListView {
                            id: suggestList
                            anchors.fill: parent
                            implicitHeight: Math.min(count * 22, 176)
                            model: root.suggestions
                            clip: true
                            keyNavigationEnabled: true
                            Keys.onReturnPressed: {
                                if (currentIndex >= 0)
                                    root.selectedEntry = model.values[currentIndex];
                                suggestionPopup.close();
                                inputField.forceActiveFocus();
                            }
                            Keys.onEscapePressed: {
                                suggestionPopup.close();
                                inputField.forceActiveFocus();
                            }
                            onCountChanged: if (count === 1) {
                                root.selectedEntry = model.values[currentIndex];
                            }
                            delegate: Rectangle {
                                required property var modelData
                                required property int index
                                readonly property int isCurrent: suggestList.currentIndex === index

                                anchors.right: parent?.right
                                anchors.left: parent?.left
                                height: 22
                                color: isCurrent ? "#316AC5" : "transparent"
                                XText {
                                    anchors {
                                        left: parent.left
                                        leftMargin: 4
                                        verticalCenter: parent.verticalCenter
                                    }
                                    text: modelData.name
                                    color: isCurrent ? "#FFFFFF" : "#0F0C0C"
                                    font.pixelSize: XFonts.sizes.verysmall
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onEntered: suggestList.currentIndex = index
                                    onClicked: {
                                        root.selectedEntry = modelData;
                                        inputField.text = modelData.name;
                                        suggestionPopup.close();
                                        inputField.forceActiveFocus();
                                    }
                                }
                            }
                        }
                    }
                }
            }
            RowLayout {
                id: bottomArea
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.bottomMargin: -XPadding.small
                Spacer {}
                RowLayout {
                    BottomRunButton {
                        text: "Ok"
                        downAction: () => {
                            if (root.selectedEntry) {
                                root.selectedEntry.execute();
                                Globals.xp.showRun = false;
                            }
                        }
                    }
                    BottomRunButton {
                        text: "Cancel"
                        downAction: () => {
                            Globals.xp.showRun = false;
                        }
                    }
                    BottomRunButton {
                        text: "Browse"
                    }
                }
            }
        }
    }
    component BottomRunButton: Rectangle {
        property var downAction
        property alias text: text.text
        border.color: "#364B56"
        border.width: 1
        Layout.preferredHeight: 28
        Layout.preferredWidth: 80
        radius: 4
        MouseArea {
            id: eventArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                if (downAction) {
                    downAction();
                }
            }
        }
        XText {
            id: text
            font.pixelSize: 13
            color: "#484547"
            anchors.centerIn: parent
        }
    }
}
