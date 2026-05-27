import QtQuick
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

Variants {
    model: MonitorsInfo.main
    StyledPanel {
        id: root
        name: "noanim_blurred_layer"
        _layer: "Overlay"
        exclusiveZone: 0
        aboveWindows: true
        color: "transparent"
        screen: modelData
        fill: true
        required property var modelData

        mask: Region {
            item: container
        }

        Item {
            id: container
            readonly property bool rightMode: !GlobalStates.main?.sidebar?.rightMode
            anchors.right: rightMode ? parent.right : undefined
            anchors.left: rightMode ? undefined : parent.left
            anchors.bottom: parent.bottom
            anchors.margins: Sizes.elevationMargin
            implicitHeight: listview.implicitHeight
            implicitWidth: Sizes.toastWidth

            StyledListView {
                id: listview
                implicitHeight: listview.contentItem.childrenRect.height
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                hint: false
                reverseRemoveDirection: !container.rightMode
                verticalLayoutDirection: ListView.BottomToTop
                reuseItems: false
                spacing: Padding.normal
                _model: GlobalStates.toasts.data
                delegate: Toast {
                    anchors.horizontalCenter: parent?.horizontalCenter
                    width: Sizes.toastWidth
                    list: listview
                }
            }
        }
    }
}
