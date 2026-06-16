import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.common
import qs.common.functions
import qs.common.widgets
import qs.services
import "./../common"

Item {
    id: root
    property alias searchQuery: searchInput.text
    property alias searchInput: searchInput
    property var results
    implicitHeight: 45
    implicitWidth: 400
    focus: true
    z: -1
    Layout.alignment: Qt.AlignHCenter
    StyledTextField {
        id: searchInput
        placeholderText: "Search"
        leftInset: 20
        leftPadding: 50
        placeholderTextColor: Colors.colOnLayer0
        anchors.fill: parent
        color: Colors.colOnLayer0
        font {
            family: "Roboto"
            pixelSize: 16
        }
        onFocusChanged: if (!focus)
            text = ""
        Keys.onReturnPressed: {
            if (results.length > 0) {
                results[0].execute();
            }
            Globals.nobuntu.overview.show = false;
        }
        IconImage {
            z: 999
            anchors {
                left: parent.left
                leftMargin: Padding.huge
                verticalCenter: parent.verticalCenter
            }
            source: NoonUtils.iconPath("folder-saved-search-symbolic")
            implicitSize: 24
        }
        IconImage {
            visible: searchInput.text.length > 0
            anchors {
                right: parent.right
                rightMargin: Padding.huge
                verticalCenter: parent.verticalCenter
            }
            MouseArea {
                anchors.fill: parent
                onClicked: searchInput.text = ""
            }
            implicitSize: 24
            source: NoonUtils.iconPath("window-close")
        }
        background: StyledRect {
            anchors.fill: parent
            color: "transparent"
            radius: Rounding.full

            border {
                width: 2
                color: parent.focus ? Colors.colPrimary : ColorUtils.transparentize(Colors.colSubtext, 0.5)
                Behavior on color {
                    CAnim {}
                }
            }
        }
    }
}
