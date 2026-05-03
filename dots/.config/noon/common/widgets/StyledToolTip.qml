import qs.common
import qs.common.widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ToolTip {
    id: root
    property string content
    property alias textArea: tooltipTextObject
    property alias bg: backgroundRectangle
    property alias color: backgroundRectangle.color
    property bool extraVisibleCondition: true
    property bool alternativeVisibleCondition: false
    property bool internalVisibleCondition: {
        const ans = (extraVisibleCondition && (parent.hovered === undefined || parent?.hovered)) || alternativeVisibleCondition;
        return ans;
    }

    verticalPadding: 7
    horizontalPadding: 14
    opacity: internalVisibleCondition ? 1 : 0
    visible: opacity > 0

    Behavior on opacity {
        Anim {}
    }

    background: null

    contentItem: Item {
        id: contentItemBackground
        implicitWidth: tooltipTextObject.width + 2 * root.horizontalPadding
        implicitHeight: tooltipTextObject.height + 2 * root.verticalPadding

        StyledRect {
            id: backgroundRectangle
            anchors.bottom: contentItemBackground.bottom
            anchors.horizontalCenter: contentItemBackground.horizontalCenter
            color: Colors.m3.m3surfaceContainerHigh
            radius: Rounding.small ?? 7
            width: internalVisibleCondition ? (tooltipTextObject.width + 2 * root.horizontalPadding) : 0
            height: internalVisibleCondition ? (tooltipTextObject.height + 2 * root.verticalPadding) : 0

            StyledText {
                id: tooltipTextObject
                anchors.centerIn: parent
                text: content
                font {
                    pixelSize: Fonts.sizes.small - 2 ?? 14
                    hintingPreference: Font.PreferFullHinting
                    family: Fonts.family.reading
                }
                color: Colors.m3.m3onSurface
                wrapMode: Text.Wrap
            }
        }
    }
}
