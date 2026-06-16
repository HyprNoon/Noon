import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Pdf
import qs.common
import qs.common.widgets
import qs.common.functions

Item {
    id: root
    focus: true
    property bool _manual_scale_triggered: false

    readonly property string currentFile: Mem.states.applications.reader.currentFile
    readonly property var document: document_item
    readonly property var document_page_view: document_page_view
    readonly property bool fit_to_page_width: true
    readonly property int currentPage: Mem.states.applications.reader.currentPage

    Rectangle {
        id: main_container
        anchors.fill: parent
        // visible: root.currentFile.length > 0
        color: Colors.colLayer0
        Component.onCompleted: fit_scale_timer.restart()

        PdfMultiPageView {
            id: document_page_view
            anchors.fill: parent
            document: PdfDocument {
                id: document_item
                source: root.currentFile
            }
        }

        PDFReaderControls {
            pdf: root.document
            pdf_view: root.document_page_view
        }
        PDFReaderDocumentProgressBar {
            pdf: root.document
            pdf_view: root.document_page_view
        }
    }
    Binding {
        target: Globals.applications.reader
        property: "document_page_view"
        value: root.document_page_view
    }

    Timer {
        id: fit_scale_timer
        interval: 200
        onTriggered: if (root.fit_to_page_width && !root._manual_scale_triggered)
            fit_width_to_scale()
    }
    function fit_width_to_scale() {
        document_page_view.scaleToWidth(root.width - (2 * Padding.massive));
    }
    PagePlaceholder {
        z: 99
        anchors.centerIn: parent
        icon: "docs"
        shapePadding: Padding.massive
        shape: MaterialShape.Shape.Ghostish
        shown: root.currentFile.length === 0
        title: "No File Opened"
        description: "Choose a file or drop it to edit"
    }
    Keys.onPressed: event => {
        if (root.currentFile.length === 0)
            return;

        switch (event.key) {
        case Qt.Key_Up:
        case Qt.Key_Left:
        case Qt.Key_PageUp:
            document_page_view.goToPage(document_page_view.currentPage - 1);
            event.accepted = true;
            break;
        case Qt.Key_Down:
        case Qt.Key_Right:
        case Qt.Key_PageDown:
        case Qt.Key_Space:
            document_page_view.goToPage(document_page_view.currentPage + 1);
            event.accepted = true;
            break;
        case Qt.Key_Home:
            document_page_view.goToPage(0);
            event.accepted = true;
            break;
        case Qt.Key_End:
            document_page_view.goToPage(document_item.pageCount - 1);
            event.accepted = true;
            break;
        case Qt.Key_End:
            document_page_view.goToPage(document_item.pageCount - 1);
            event.accepted = true;
            break;
        case Qt.Key_0:
            if (event.modifiers & Qt.ControlModifier & Qt.ShiftModifier) {
                root.fit_width_to_scale();
                _manual_scale_triggered = false;
                event.accepted = true;
            }
            break;
        case Qt.Key_0:
            if (event.modifiers & Qt.ControlModifier) {
                document_page_view.resetScale();
                _manual_scale_triggered = false;
                event.accepted = true;
            }
            break;
        case Qt.Key_Minus:
            if (event.modifiers & Qt.ControlModifier) {
                document_page_view.scaleToWidth(document_page_view.width - (root.width * 0.25));
                _manual_scale_triggered = true;
                event.accepted = true;
            }
            break;
        case Qt.Key_Plus:
            if (event.modifiers & Qt.ControlModifier) {
                document_page_view.scaleToWidth(document_page_view.width + (root.width * 0.25));
                _manual_scale_triggered = true;
                event.accepted = true;
            }
            break;
        }
    }
}
