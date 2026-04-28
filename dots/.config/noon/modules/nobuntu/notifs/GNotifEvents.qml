import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import qs.common
import qs.services
import qs.common.widgets
import "./../common"

Item {
    id: root
    Layout.fillWidth: true
    Layout.fillHeight: true
    StyledRectangularShadow {
        target: bg
        intensity: 0.2
    }
    StyledRect {
        id: bg
        anchors.fill: parent
        radius: Rounding.verylarge
        color: Colors.colLayer3

        StyledListView {
            anchors.fill: parent
            anchors.margins: Padding.large
            spacing: Padding.normal
            radius: bg.radius - Padding.small
            clip: true
            hint: false
            model: TodoService.list
            delegate: TaskItemComponent {}
        }
    }
    component TaskItemComponent: StyledRect {
        id: root
        required property var modelData
        width: parent.width
        radius: Rounding.large
        color: Colors.colLayer4
        Layout.fillWidth: true
        implicitHeight: 55

        RowLayout {
            anchors.fill: parent
            anchors.margins: Padding.small
            anchors.leftMargin: Padding.huge

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                StyledText {
                    font {
                        pixelSize: Fonts.sizes.small
                        variableAxes: Fonts.variableAxes.title
                        strikeout: modelData.status === TodoService.Status.Done
                    }

                    truncate: true
                    text: modelData.content
                    color: Colors.colOnLayer4
                }
                StyledText {
                    text: {
                        switch (modelData.status) {
                        case TodoService.Status.Todo:
                            return "Not Started";
                        case TodoService.Status.InProgress:
                            return "In Progress";
                        case TodoService.Status.FinalTouches:
                            return "Final Touches";
                        case TodoService.Status.Done:
                            return "Finished";
                        default:
                            return "Not Started";
                        }
                    }
                    opacity: modelData.status === TodoService.Status.Done ? 0.3 : 0.45
                    font.pixelSize: 11
                    color: Colors.colSubtext
                }
            }
            Spacer {}
            StyledIconImage {
                z: 99
                implicitSize: 22
                _source: "window-close-symbolic"

                MouseArea {
                    z: 999
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    // TODO
                    // onClicked: {
                    //     let index = TodoService.list.indexOf(root.modelData)
                    //     TodoService.setStatus(index, 3)
                    //     console.log(index,root.modelData)
                    // }
                }
            }
        }
    }
}
