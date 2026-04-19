import QtQuick
import Quickshell

import qs.common
import qs.common.widgets
import qs.services

Item {
    id: root
    // Model
    property var content
    anchors.fill: parent
    Component.onCompleted: console.log("Done")
    StyledRectangularShadow {
        target: bg
    }
    StyledRect {
        id: bg
        radius: Rounding.silly
        color: Colors.colLayer1
        anchors.fill: parent
        StyledListView {
            anchors.fill: parent
            clip: true
            model: root.content
            delegate: StyledDelegateItem {
                required property var modelData
                required property int index
                anchors.right: parent?.right
                anchors.left: parent?.left
                height: 72
                materialIcon: "folder"
                title: modelData?.name
                subtext: modelData?.path
            }
        }
    }
}
