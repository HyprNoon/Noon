import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.common
import qs.common.widgets

Item {
    id: root
    required property var pdf
    required property var pdf_view

    anchors {
        bottom: parent.bottom
        right: parent.right
        margins: Padding.massive
    }

    implicitHeight: bg.height
    implicitWidth: bg.width

    StyledRect {
        id: bg
        color: Colors.m3.m3surfaceContainer
        anchors.fill: parent
        enableBorders: true
        radius: Rounding.verylarge
        implicitHeight: 45
        implicitWidth: 90
        Loader {
            id: content_laoder
            asynchronous: true
            anchors.centerIn: parent
            sourceComponent: info_component
        }

        // MouseArea {
        //     id: event_area
        //     anchors.fill: parent
        //     acceptedButtons: Qt.NoButton
        //     propagateComposedEvents: true
        //     hoverEnabled: true
        // }

    }

    StyledRectangularShadow {
        target: bg
    }
    Component {
        id: controls_component
        RowLayout {
            id: content_row
            anchors.centerIn: parent
            spacing: Padding.large
            RippleButtonWithIcon {
                materialIcon: "add"
                iconColor: Colors.colOnLayer0
            }
            VerticalSeparator {}
            RippleButtonWithIcon {
                materialIcon: "remove"
                iconColor: Colors.colOnLayer0
            }
        }
    }
    Component {
        id: info_component
        RowLayout {
            id: content_row
            anchors.centerIn: parent
            spacing: 0

            StyledText {
                Layout.fillHeight: true
                Layout.preferredWidth: 45
                animateChange: true
                font {
                    pixelSize: Fonts.sizes.small
                    family: Fonts.family.numbers
                    variableAxes: Fonts.variableAxes.numbers
                }
                horizontalAlignment: Text.AlignHCenter
                text: pdf.pageCount
            }

            VerticalSeparator {
                opacity: 0.7
                implicitHeight: 40
            }

            Item {
                Layout.fillHeight: true
                Layout.preferredWidth: 45
                TextField {
                    anchors.centerIn: parent
                    anchors.horizontalCenterOffset: -4
                    font {
                        pixelSize: Fonts.sizes.small
                        family: Fonts.family.numbers
                        variableAxes: Fonts.variableAxes.numbers
                    }
                    renderType: Text.NativeRendering
                    selectedTextColor: Colors.colOnSecondaryContainer
                    selectionColor: Colors.colSecondaryContainer
                    horizontalAlignment: Text.AlignLeft

                    background: null
                    text: pdf_view.currentPage + 1 // To Count from 1
                    onAccepted: pdf_view.goToPage(text - 1)
                }
            }
        }
    }
}
