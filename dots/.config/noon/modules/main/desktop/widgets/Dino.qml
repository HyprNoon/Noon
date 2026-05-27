import QtQuick
import Qt5Compat.GraphicalEffects
import qs.common
import qs.common.widgets

WidgetContainer {
    Item {
        id: dino
        anchors.fill: parent

        Image {
            id: img
            fillMode: Image.PreserveAspectFit
            source: Directories.assets + "/icons/dino.png"
            sourceSize: Qt.size(width, height)
            anchors.fill: parent
            anchors.margins: Padding.massive
        }

        ColorOverlay {
            anchors.fill: img
            source: img
            color: Colors.colSecondary
        }
    }
    MouseArea {
        z: 99
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        property string bgColor: Colors.colOnLayer0.substring(1)
        property string fgColor: Colors.colLayer0.substring(1)
        property string dinoUrl: "file://" + Directories.assets + `/etc/t-rex-runner/index.html?bg=${bgColor}&fg=${fgColor}`

        onPressed: NoonUtils.execDetached(["gio", "open", `${dinoUrl}`])
    }
    StyledText {
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            bottomMargin: Padding.huge
        }
        text: "Dino"
        font {
            pixelSize: Fonts.sizes.small
            variableAxes: Fonts.variableAxes.title
        }
        color: Colors.colSecondary
    }
}
