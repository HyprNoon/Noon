import QtQuick
import qs.store
import qs.common
import qs.common.widgets

AppWindow {
    id: root
    property string category
    property bool expanded: width > Sizes.sidebar.quarter * 0.9

    ContentChild {
        anchors.fill: parent
        anchors.margins: Padding.massive
        category: root.category
        parentRoot: root
    }

    Component.onCompleted: SidebarData.detachedContent.push(root.category)
    onVisibleChanged: !visible ? kill() : null

    function kill() {
        let states = SidebarData.detachedContent;
        let item = states.filter(item => item === root.category);
        states.pop(states.indexOf(item));
    }
}
