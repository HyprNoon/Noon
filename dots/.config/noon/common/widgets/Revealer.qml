import QtQuick
import Quickshell
import qs.common

/**
 * Recreation of GTK revealer. Expects one single child.
 */
Item {
    id: root

    property bool reveal
    property bool vertical: false
    property Item revealChild: children.length > 0 ? children[0] : null

    clip: true
    implicitWidth: vertical ? (revealChild ? revealChild.implicitWidth : 0) : (reveal ? (revealChild ? revealChild.implicitWidth : 0) : 0)
    implicitHeight: !vertical ? (revealChild ? revealChild.implicitHeight : 0) : (reveal ? (revealChild ? revealChild.implicitHeight : 0) : 0)
    visible: reveal || (width > 0 && height > 0)
    onRevealChildChanged: {
        if (revealChild)
            revealChild.anchors.fill = root;
    }

    Behavior on implicitWidth {
        enabled: !vertical

        Anim {}
    }

    Behavior on implicitHeight {
        enabled: vertical

        Anim {}
    }
}
