import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

StyledRect {
    id: popup
    property bool active: false
    property var appsData: []
    property string categoryTitle: ""
    property int startX: 0
    property int startY: 0
    property int startW: 0
    property int startH: 0

    z: 100
    color: Colors.colLayer2
    radius: active ? Rounding.verylarge : Rounding.large
    visible: opacity > 0
    clip: true

    // Initial state
    x: startX
    y: startY
    width: startW
    height: startH
    opacity: 0

    states: [
        State {
            name: "open"
            when: popup.active
            PropertyChanges {
                target: popup
                x: 0
                y: 0
                width: root.width
                height: root.height
                opacity: 1
            }
        },
        State {
            name: "close"
            when: !popup.active
            PropertyChanges {
                target: popup
                x: startX
                y: startY
                width: 0
                height: 0
                opacity: 0
            }
        }
    ]
    transitions: Transition {
        Anim {
            properties: "x,y,width,height,opacity"
            duration: 400
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Padding.huge
        spacing: Padding.massive
        visible: popup.active

        RowLayout {
            Layout.preferredHeight: 50
            StyledText {
                text: popup.categoryTitle
                font.pixelSize: Fonts.sizes.huge
                font.variableAxes: Fonts.variableAxes.title
                color: Colors.colOnLayer2
                Layout.fillWidth: true
                Layout.leftMargin: Padding.large
            }
            GroupButtonWithIcon {
                baseSize: 36
                materialIcon: "close"
                releaseAction: () => popup.active = false
            }
        }

        StyledListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: popup.appsData
            spacing: Padding.small
            hint: false
            clip: true
            radius: Rounding.huge
            delegate: StyledDelegateItem {
                id: delegateListItem
                required property var modelData
                required property int index
                iconSource: NoonUtils.iconPath(modelData?.icon) ?? ""
                title: modelData?.name ?? ""
                subtext: modelData?.description ?? ""
                colBackground: index % 2 !== 0 ? "transparent" : Colors.colLayer3
                releaseAction: () => {
                    popup.active = false;
                    root.dismiss();
                    modelData.execute();
                }
                altAction: () => contextMenu.popup()
                AppContextMenu {
                    id: contextMenu
                    modelData: delegateListItem.modelData
                    onDismiss: root.dismiss()
                }
            }
        }
    }
}
