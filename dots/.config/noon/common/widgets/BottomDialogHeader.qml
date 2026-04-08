import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.functions
import qs.common.widgets

RowLayout {
    id: root
    property var target: parent?.parent.parent ?? null
    property alias title: titleArea.text
    property alias subTitle: subTitleArea.text
    property QtObject colors: Colors
    property bool showCloseButton: true
    Layout.fillWidth: true
    Layout.preferredHeight: 50
    Layout.margins: Padding.large

    ColumnLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true
        spacing: Padding.small

        StyledText {
            id: titleArea
            truncate: true
            Layout.fillWidth: true
            font.variableAxes: Fonts.variableAxes.title
            font.pixelSize: Fonts.sizes.subTitle
            color: root.colors.colOnLayer2
        }

        StyledText {
            id: subTitleArea
            visible: text.length > 0
            truncate: true
            Layout.fillWidth: true
            font.variableAxes: Fonts.variableAxes.main
            font.pixelSize: Fonts.sizes.normal
            color: root.colors.colSubtext
        }
    }

    Item {
        Layout.fillWidth: true
    }
    RippleButtonWithIcon {
        visible: root.showCloseButton && root.target
        materialIcon: "close"
        implicitSize: 42
        colors: root.colors
        releaseAction: () => {
            root.target.show = false;
        }
    }
}
