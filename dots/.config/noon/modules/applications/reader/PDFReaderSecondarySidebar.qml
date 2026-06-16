import QtQuick
import QtQuick.Pdf
import QtQuick.Controls
import QtQuick.Layouts
import qs.common
import qs.common.widgets

Item {
    id: root
    property string currentFile: Mem.states.applications.reader.currentFile

    ColumnLayout {
        anchors.fill: parent
        spacing: Padding.normal

        TreeView {
            id: treeView

            Layout.fillWidth: true
            Layout.preferredHeight: Math.round(root.height * 0.6)
            clip: true

            model: PdfBookmarkModel {
                document: PdfDocument {
                    id: document
                    source: Qt.resolvedUrl(currentFile)
                }
            }

            delegate: TreeViewDelegate {
                id: treeDelegate
                implicitWidth: root.width
                implicitHeight: 32
                background: null

                Rectangle {
                    anchors.fill: parent
                    z: -1
                    color: model.page % 2 === 0 ? Colors.colLayer0 : Colors.colLayer4
                    implicitWidth: root.width
                }
                leftMargin: Padding.normal
                contentItem: StyledText {
                    text: model.display
                    font.pointSize: Fonts.sizes.verysmall
                    font.family: Fonts.family.monospace
                    color: Colors.colOnLayer2
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                onClicked: if (model.page !== undefined && model.page >= 0)
                    Globals.applications.reader.document_page_view.goToPage(model.page)
            }
        }
        Separator {}
        Spacer {}
    }

    PagePlaceholder {
        id: pagePlaceholder
        z: 999
        anchors.centerIn: parent
        shape: MaterialShape.Shape.Cookie6Sided
        icon: "bookmark"
        title: "No File Selected"
        description: "Select a file to show bookmarks"
        shown: currentFile.length === 0
    }
}
