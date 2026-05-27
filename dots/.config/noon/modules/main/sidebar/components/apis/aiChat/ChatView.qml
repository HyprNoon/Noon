import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.services
import qs.common.widgets

StyledRect {
    id: chatView
    clip: true
    color: "transparent"
    radius: Rounding.small

    property alias listView: messageListView
    // Usage of ScriptModel - StyledListView Adds Overhead and messes Wheel Behavior
    ListView {
        id: messageListView
        z: 0
        anchors.fill: parent
        spacing: Padding.veryhuge
        reuseItems: false
        property bool userScrolledUp: false
        onMovementStarted: userScrolledUp = !atYEnd
        onCountChanged: if (!userScrolledUp)
            Qt.callLater(positionViewAtEnd)
        model: Ai.messageIDs.filter(id => Ai.messageByID[id]?.visibleToUser ?? true)

        Keys.onPressed: event => {
            if (event.modifiers === Qt.NoModifier) {
                if (event.key === Qt.Key_PageUp) {
                    contentY = Math.max(0, contentY - height / 2);
                    event.accepted = true;
                } else if (event.key === Qt.Key_PageDown) {
                    contentY = Math.min(contentHeight - height, contentY + height / 2);
                    event.accepted = true;
                } else if (event.key === Qt.Key_Home) {
                    contentY = 0;
                    userScrolledUp = true;
                    event.accepted = true;
                } else if (event.key === Qt.Key_End) {
                    positionViewAtEnd();
                    userScrolledUp = false;
                    event.accepted = true;
                }
            }
        }
        Behavior on contentY {
            enabled: false
        }
        delegate: Item {
            required property var modelData
            required property int index

            readonly property var msg: Ai.messageByID[modelData]
            readonly property Component userComp: UserMessage {
                messageIndex: index
                messageData: msg
                messageInputField: root.inputField
            }
            readonly property Component aiComp: AiMessage {
                messageIndex: index
                messageData: msg
                messageInputField: root.inputField
            }

            anchors.left: parent?.left
            anchors.right: parent?.right
            implicitHeight: loader?.implicitHeight

            Loader {
                id: loader
                anchors.left: parent.left
                anchors.right: parent.right
                sourceComponent: parent.msg?.role === "user" ? userComp : aiComp
            }
        }
    }

    PagePlaceholder {
        z: 2
        shown: Ai.messageIDs.length === 0
        icon: "neurology"
        title: "AI"
        description: "access various AI models\n press '/' for more options "
        shape: MaterialShape.Shape.PixelCircle
    }
}
