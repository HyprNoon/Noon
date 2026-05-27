import QtQuick
import QtQuick.Layouts
import qs.common
import qs.services
import qs.common.functions

StyledRect {
    id: root
    property var account: SysInfoService.oauthData[0]?.account ?? {}
    color: "transparent" // Colors.colLayer2
    radius: Rounding.verylarge

    Layout.fillWidth: true
    height: 80

    RowLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        // anchors.leftMargin: Padding.veryhuge
        // anchors.rightMargin: Padding.veryhuge
        anchors.verticalCenter: parent.verticalCenter
        spacing: Padding.huge

        StyledRect {
            implicitSize: 70
            color: Colors.colLayer1
            radius: Rounding.full
            clip: true
            CroppedImage {
                anchors.fill: parent
                visible: account.image.length > 0
                source: account?.image
            }
            Symbol {
                anchors.centerIn: parent
                font.pixelSize: 28
                color: Colors.colOnLayer2
                fill: 1
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft
            spacing: 0
            StyledText {
                truncate: true
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignLeft
                text: StringUtils.capitalizeFirstLetter(account.name)
                color: Colors.colOnLayer2
                font.pixelSize: Fonts.sizes.huge
                font.variableAxes: Fonts.variableAxes.title
            }

            StyledText {
                truncate: true
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignLeft
                text: account.handler
                color: Colors.colSubtext
                font.pixelSize: Fonts.sizes.small
                font.variableAxes: Fonts.variableAxes.title
            }
        }
    }
}
