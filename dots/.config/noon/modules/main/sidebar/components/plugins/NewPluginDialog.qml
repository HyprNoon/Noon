import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

BottomDialog {
    id: root
    z: 999
    collapsedHeight: 260
    enableStagedReveal: false
    bottomAreaReveal: true
    hoverHeight: 300
    color: Colors.colLayer2

    contentItem: ColumnLayout {
        anchors.fill: parent
        anchors.margins: Padding.large
        anchors.rightMargin: Padding.massive * 1.5
        anchors.leftMargin: Padding.massive * 1.5
        spacing: Padding.normal

        StyledText {
            text: "Add Plugin"
            font {
                pixelSize: Fonts.sizes.subTitle
                variableAxes: Fonts.variableAxes.title
            }
            Layout.topMargin: Padding.massive
            color: Colors.colOnLayer3
        }

        RLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            StyledText {
                Layout.preferredWidth: 100
                color: Colors.colOnLayer3
                text: "Group: "
            }
            StyledComboBox {
                id: groupCombo
                implicitHeight: 45
                currentIndex: 0
                model: PluginsManager.plugins
                onActivated: index => {
                    if (index >= 0 && index < model.length) {
                        root.selectedGroup = model[index].trim();
                        console.log(model[index]);
                    }
                }
            }
        }

        Spacer {}

        RLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            Item {
                Layout.fillWidth: true
            }
            DialogButton {
                toggled: PluginsManager.selectedLocation.length > 0
                buttonText: toggled ? "Selected" : "Select"
                onClicked: PluginsManager.select()
            }
            DialogButton {
                buttonText: "Cancel"
                onClicked: root.show = false
            }
            DialogButton {
                buttonText: "OK"
                onClicked: root.addPlugin()
            }
        }
    }
    function addPlugin() {
        if (PluginsManager.selectedLocation) {
            PluginsManager.install(groupCombo.model[groupCombo.currentIndex]);
            root.show = false;
        }
    }
}
