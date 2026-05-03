import QtQuick

Item {
    id: emote
    property string emoji: "💬"
    width: 28
    height: 28

    Text {
        anchors.centerIn: parent
        text: emote.emoji
        font.pixelSize: 20
    }

    SequentialAnimation {
        running: true
        ParallelAnimation {
            NumberAnimation {
                target: emote
                property: "y"
                to: emote.y - 60
                duration: 1200
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                target: emote
                property: "opacity"
                from: 1
                to: 0
                duration: 1200
                easing.type: Easing.InQuad
            }
        }
        ScriptAction {
            script: emote.destroy()
        }
    }
}
