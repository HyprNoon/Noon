import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Qt.labs.folderlistmodel

import qs.common
import qs.common.functions
import qs.common.widgets
import qs.services

BottomDialog {
    id: root
    collapsedHeight: parent.height * 0.6
    enableStagedReveal: true
    bottomAreaReveal: true
    hoverHeight: 300
    color: Colors.colLayer2
    function addNote() {
        NotesService.createNote(inputArea.text.trim() + ".md");
        Qt.callLater(() => {
            inputArea.text = "";
        });
    }
    contentItem: CLayout {
        anchors.fill: parent
        anchors.margins: Padding.large

        PageHeader {
            title: "Notes"
            subTitle: NotesService.filePath.replace(Directories.standard.home, '~ ')
        }

        StyledListView {
            Layout.fillHeight: true
            Layout.fillWidth: true
            model: filesModel
            hint: false
            delegate: StyledDelegateItem {
                required property var modelData
                required property int index
                width: parent.width
                title: modelData.fileBaseName
                subtext: modelData.fileModified
                materialIcon: "draft"
                fill: 1
                releaseAction: () => {
                    NotesService.openNote(modelData.fileName);
                }
            }
        }

        RLayout {
            Layout.maximumHeight: 50
            Layout.rightMargin: Padding.large
            Layout.leftMargin: Padding.large

            Layout.fillWidth: true
            spacing: Padding.huge

            MaterialShapeWrappedSymbol {
                padding: 8
                iconSize: 20
                text: "new_window"
                Layout.alignment: Qt.AlignVCenter
                Layout.fillHeight: true
                color: inputArea.focus ? Colors.colPrimary : Colors.colPrimaryContainer
                colSymbol: inputArea.focus ? Colors.colOnPrimary : Colors.colOnPrimaryContainer
                shape: inputArea.focus ? MaterialShape.Shape.Cookie12Sided : MaterialShape.Shape.Cookie6Sided
                MouseArea {
                    z: 9999
                    anchors.fill: parent
                    enabled: inputArea.text.length > 0
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.addNote()
                }
            }
            StyledRect {
                Layout.fillWidth: true
                radius: Rounding.verylarge
                height: 46
                color: inputArea.focus ? Colors.colSecondaryContainer : Colors.colLayer3

                StyledTextArea {
                    id: inputArea
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.left: parent.left
                    background: null
                    placeholderText: "Enter file name"
                    Keys.onReturnPressed: root.addNote()
                }
            }
        }
        FolderListModel {
            id: filesModel
            nameFilters: ["*.md"]
            folder: Directories.standard.documents + "/Notes"
            showDirs: false
        }
    }
}
