import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets

BottomDialog {
    id: root
    required property var db

    collapsedHeight: 650
    enableStagedReveal: false
    bottomAreaReveal: true
    hoverHeight: 200

    contentItem: ColumnLayout {
        anchors.fill: parent
        anchors.margins: Padding.huge
        spacing: Padding.large

        PageHeader {
            title: "Your Widgets"
            subTitle: "You Have " + (root.db.length - Mem.states.sidebar.widgets.enabled.length) + " disabled widgets !"
        }

        StyledListView {
            clip: true
            radius: Rounding.verylarge
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 4
            _model: root.db
            delegate: StyledDelegateItem {
                anchors.right: parent?.right
                anchors.left: parent?.left
                height: 70
                title: modelData?.name
                subtext: {
                    let props = [];
                    if (modelData.expandable)
                        props.push("Expandable");
                    if (Mem.states.sidebar.widgets.pilled.indexOf(modelData.id) !== -1)
                        props.push("Pill");
                    else
                        props.push("Square");
                    if (Mem.states.sidebar.widgets.pinned.indexOf(modelData.id) !== -1)
                        props.push("Pinned");
                    if (Mem.states.sidebar.widgets.expanded.indexOf(modelData.id) !== -1)
                        props.push("Expanded");
                    return props.length > 0 ? props.join(" • ") : "Standard widget";
                }
                colSubtext: Colors.colSubtext
                colTitle: Colors.colOnLayer2
                materialIcon: modelData.icon || "widgets"
                enabled: Mem.states.sidebar.widgets.enabled.indexOf(modelData.id) === -1
                opacity: Mem.states.sidebar.widgets.enabled.indexOf(modelData.id) !== -1 ? 0.5 : 1
                buttonRadius: Rounding.tiny
                releaseAction: () => {
                    if (enabled)
                        Mem.states.sidebar.widgets.enabled.push(modelData.id);
                }
            }
        }
    }
}
