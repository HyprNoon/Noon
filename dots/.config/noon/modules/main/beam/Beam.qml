import QtQuick
import QtQuick.Layouts
import Quickshell
import QtQuick.Controls

import qs.common
import qs.common.widgets
import qs.common.utils
import qs.services
import qs.store

StyledPanel {
    id: root
    name: "noanim_blurred_layer"
    property real scrollSum: 0
    property bool hasAttachedFile: false
    readonly property bool reveal: Globals.main.showBeam
    readonly property int mainRounding: Rounding.full
    readonly property int elevationValue: Sizes.elevationMargin + (Mem.options.bar.behavior.position === "bottom" ? Mem.options.bar.appearance.size : 0)
    readonly property int beamTargetWidth: {
        const hint = BeamData.getHint();
        const query = BeamData.query;
        return Math.max(hint, query) > 25 ? Sizes.beamSizeExpanded.width : Sizes.beamSize.width;
    }

    visible: true
    keyboardFocus: true
    exclusiveZone: -1
    fill: true

    mask: Region {
        Region {
            item: beamBg
        }
        Region {
            item: hoverArea
        }
        // Region {
        //     item: popup
        // }
    }

    function hide() {
        Globals.main.showBeam = false;
    }

    function sendMessage() {
        BeamData.executeCommand();
        BeamData.reset();
        hide();
    }

    function takeScreenshot() {
        ScreenShotService.request({
            temp: true,
            region: ScreenShotService.Regions.Window
        });
        ScreenShotService.screenshotCompleted.connect(path => {
            root.hasAttachedFile = path.length > 0;
            Ai.attachFile(Qt.resolvedUrl(ScreenShotService.tempPath));
            Qt.callLater(hide);
        });
    }

    FocusHandler {
        windows: [root]
        active: root.reveal
        onCleared: root.hide()
    }

    ScreenActionHintPanel {
        target: dropArea
        hint: {
            "icon": "keyboard_double_arrow_down",
            "text": "You Can Drop Now"
        }
    }

    MouseArea {
        id: hoverArea
        // enabled: !root.reveal
        z: -1
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        implicitHeight: Math.max(0, Sizes.hyprland.gapsOut - 2)
        hoverEnabled: true
        propagateComposedEvents: true
        acceptedButtons: Qt.NoButton
        scrollGestureEnabled: true

        Timer {
            id: idleTimer
            repeat: true
            interval: 5000
            running: root.reveal && BeamData.query.length === 0 && !hoverArea.containsMouse
            onTriggered: root.hide()
        }

        onWheel: wheel => {
            if (wheel.modifiers === Qt.ControlModifier) {
                Globals.main.sysDialogs.mode = wheel.angleDelta.y < 0 ? "incubate" : "";
                wheel.accepted = true;
                return;
            }
            if (wheel.modifiers === Qt.ShiftModifier) {
                Globals.main.sysDialogs.mode = wheel.angleDelta.y < 0 ? "cheats" : "";
                wheel.accepted = true;
                return;
            }

            root.scrollSum += wheel.angleDelta.y;

            if (!root.reveal && root.scrollSum <= -20) {
                Globals.main.showBeam = true;
                root.scrollSum = 0;
            } else if (root.reveal && root.scrollSum >= 20) {
                Globals.main.showBeam = false;
                root.scrollSum = 0;
            }

            wheel.accepted = true;
        }

        DropArea {
            id: dropArea
            anchors.fill: parent
            keys: ["text/uri-list"]
            onDropped: drop => {
                if (!drop || !drop.hasUrls || drop.urls.length === 0)
                    return;

                let urlStrings = drop.urls.map(url => url.toString());
                let firstUrl = urlStrings[0];

                if (firstUrl.startsWith("http")) {
                    NoonUtils.runDownloader(firstUrl);
                } else if (firstUrl.startsWith("file://")) {
                    Mem.states.sidebar.shelf.filePaths = [...Mem.states.sidebar.shelf.filePaths, ...urlStrings];
                }
            }
        }
    }

    BeamPopup {
        id: popup
        mainBg: beamBg
        reveal: root.reveal
    }

    StyledRectangularShadow {
        target: popup
        transparency: 0.6
    }

    StyledRectangularShadow {
        target: beamBg
        transparency: 0.6
    }

    BeamBg {
        id: beamBg
        reveal: root.reveal && !Globals.main.showOsdValues
        rounding: root.mainRounding
        elevationValue: root.elevationValue

        implicitHeight: Sizes.beamSize.height
        implicitWidth: root.beamTargetWidth

        Symbol {
            z: 999
            font.pixelSize: 18
            fill: 1
            color: inputField.focus ? Colors.colOnPrimary : Colors.colOnLayer3
            anchors.centerIn: icon
            text: BeamData.getIcon()
        }

        MaterialShape {
            id: icon
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: Padding.gigantic
            }
            implicitSize: 36
            color: inputField.focus ? Colors.colPrimary : Colors.colLayer3
            shape: BeamData.getShape()

            property alias inputText: inputField.text
            onInputTextChanged: if (inputField.text.length === 0)
                rotation = 0

            Behavior on color {
                CAnim {}
            }

            RotationAnimation on rotation {
                running: inputField.text.length > 0
                loops: Animation.Infinite
                from: 0
                to: 360
                duration: 9000
                easing.type: Easing.Linear
            }
        }

        LayerRect {
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: icon.right
                right: sendButton.left
                leftMargin: Padding.huge
                rightMargin: Padding.small
                margins: Padding.normal
            }
            radius: Rounding.full

            TextField {
                id: inputField
                anchors.fill: parent
                z: 10
                focus: root.reveal
                objectName: "inputField"
                placeholderText: BeamData.config?.placeholder ?? "Ask any thing ..."
                text: BeamData.query
                background: null
                selectionColor: Colors.colPrimaryContainer
                selectedTextColor: Colors.m3.m3onPrimaryContainer
                color: Colors.colOnLayer0
                placeholderTextColor: Colors.colSubtext
                selectByMouse: true
                leftPadding: Padding.veryhuge
                rightPadding: Padding.veryhuge + osrButton.width
                font.pixelSize: Fonts.sizes.normal
                font.family: Fonts.family.main

                onTextChanged: BeamData.updateStateFromQuery(text)

                Keys.onPressed: event => {
                    switch (event.key) {
                    case Qt.Key_Escape:
                        root.hide();
                        event.accepted = true;
                        break;
                    case Qt.Key_Return:
                        root.sendMessage();
                        event.accepted = true;
                        break;
                    case Qt.Key_Tab:
                        const hint = BeamData.getHint();
                        if (hint) {
                            BeamData.query = BeamData.autocomplete(hint);
                            event.accepted = true;
                        }
                        break;
                    default:
                        if (event.modifiers === Qt.ControlModifier && event.key === Qt.Key_S) {
                            root.takeScreenshot();
                            event.accepted = true;
                        }
                    }
                }
            }

            GroupButtonWithIcon {
                id: osrButton
                z: 999
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    right: parent.right
                    rightMargin: Padding.large
                }
                buttonRadius: root.mainRounding
                releaseAction: () => root.takeScreenshot()
                colBackground: "transparent"
                materialIcon: "screenshot_region"
                implicitSize: beamBg.implicitHeight * 0.75
                enabled: !ScreenShotService.isBusy
                visible: BeamData.config?.showOsrButton ?? false
                Behavior on opacity {
                    Anim {}
                }
            }
        }

        GroupButtonWithIcon {
            id: sendButton
            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: Padding.large
            }
            releaseAction: () => root.sendMessage()
            buttonRadius: root.mainRounding
            colBackground: BeamData.query.length > 0 ? Colors.colPrimaryContainer : "transparent"
            iconSize: 22
            implicitSize: beamBg.implicitHeight * 0.6
            animateIcon: true
            materialIcon: BeamData.query.length === 0 && BeamData.activeState === "ai" ? "mic" : root.isResponding ? "stop" : "arrow_upward"
            Behavior on opacity {
                Anim {}
            }
        }
    }
}
