import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.common
import qs.common.widgets

GroupButton {
    id: button

    property string buttonText: ""
    property string buttonIcon: ""
    property color colText: toggled ? Colors.m3.m3onPrimary : Colors.colOnLayer1

    baseWidth: content.implicitWidth + 10 * 2
    baseHeight: 30
    buttonRadius: baseHeight / 2
    buttonRadiusPressed: Rounding.small
    colBackground: Colors.colLayer2
    colBackgroundHover: Colors.colLayer2Hover
    colBackgroundActive: Colors.colLayer2Active

    contentItem: Item {
        id: content

        anchors.fill: parent
        implicitWidth: contentRowLayout.implicitWidth
        implicitHeight: contentRowLayout.implicitHeight

        RowLayout {
            id: contentRowLayout

            anchors.centerIn: parent
            spacing: 5

            Symbol {
                icon: buttonIcon
                font.pixelSize: Fonts.sizes.large
                color: button.colText
            }

            StyledText {
                text: buttonText
                font.pixelSize: Fonts.sizes.small
                color: button.colText
            }
        }
    }
}
