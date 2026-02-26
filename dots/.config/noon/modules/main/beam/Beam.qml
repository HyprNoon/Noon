import Noon.Services
import QtQuick
import QtQuick.Layouts
import Quickshell
import QtQuick.Controls

import qs.common
import qs.common.widgets
import qs.common.utils
import qs.services
import qs.store

Variants {
    model: [MonitorsInfo.focused]

    StyledPanel {
        id: root
        name: "slide_layer"
        required property var modelData
        screen: modelData
        readonly property int detectionArea: scrollReveal ? 20 : 4
        readonly property bool scrollReveal: Mem.options.beam.behavior.scrollToReveal
        readonly property bool reveal: GlobalStates.main.showBeam || (Mem.options.beam.behavior.revealOnEmpty && !MonitorsInfo.topLevel.activated)
        readonly property int expandedThreshold: 25
        readonly property int mainRounding: 50
        readonly property int elevationValue: (Mem.options.bar.behavior.position === "bottom" ? Mem.options.bar.appearance.height : 0) + Sizes.elevationMargin

        onRevealChanged: !reveal ? BeamData.query = "" : null

        visible: reveal || scrollReveal
        implicitWidth: Sizes.beamSizeExpanded.width + 999
        implicitHeight: Sizes.beamSize.height + elevationValue + 999
        kbFocus: true
        exclusiveZone: -1

        anchors.left: true
        anchors.right: true
        anchors.bottom: true

        mask: Region {
            item: bg
        }

        // Auto-hide timer
        Timer {
            id: idleTimer
            repeat: true
            running: root.reveal && BeamData.query.length === 0 && !beam_mouse_area.containsMouse
            interval: 5000
            onTriggered: root.hide()
        }

        // Focus handling
        FocusHandler {
            windows: [root]
            active: root.reveal
            onCleared: root.hide()
        }

        Connections {
            id: clip_watcher
            target: ClipboardService
            enabled: clip_watcher.waiting
            ignoreUnknownSignals: true

            property bool waiting: false

            function onEntriesRefreshed() {
                const img = ClipboardService.getImagePath(0);
                if (ClipboardService.isImage(img)) {
                    Ai.attachFile(img);
                    GlobalStates.main.showBeam = true;
                }
                clip_watcher.waiting = false;
            }
        }

        function takeScreenshot() {
            clip_watcher.waiting = true;
            ScreenShotService.takeScreenShot();
        }

        function hide() {
            GlobalStates.main.showBeam = false;
        }

        function sendMessage() {
            BeamData.executeCommand();
            BeamData.reset();
            root.hide();
        }

        MouseArea {
            id: beam_mouse_area
            readonly property int _hidden_offset: -(Sizes.beamSize.height + elevationValue - 2)
            z: 999
            hoverEnabled: true
            anchors.fill: parent
            propagateComposedEvents: true
            scrollGestureEnabled: true
            acceptedButtons: Qt.NoButton
            onWheel: function (wheel) {
                if (!root.scrollReveal)
                    return;

                let scrollSum = 0;
                let toggleThreshold = 20;
                scrollSum += wheel.angleDelta.y;

                if (!root.reveal && scrollSum <= -toggleThreshold) {
                    GlobalStates.main.showBeam = true;
                    scrollSum = 0;
                } else if (root.reveal && scrollSum >= toggleThreshold) {
                    GlobalStates.main.showBeam = false;
                    scrollSum = 0;
                }

                wheel.accepted = true;
            }
            DropArea {
                id: dropArea
                anchors.fill: parent
                keys: ["text/uri-list"]
                onDropped: drop => {
                    let newPaths = drop.urls.map(url => url.toString());
                    const firstItem = newPaths[0];
                    NoonUtils.runDownloader(firstItem);
                }
            }

            ScreenActionHint {
                target: dropArea
            }

            anchors {
                bottomMargin: root.reveal && !GlobalStates.main.showOsdValues ? 0 : _hidden_offset
                Behavior on bottomMargin {
                    Anim {}
                }
            }
            Item {
                id: container
                z: 999
                anchors.fill: parent
                property alias input: inputField
                property string hintText: BeamData.getHint() || ""
                readonly property var appData: DesktopEntries.byId(container.hintText) || {}

                BeamPopup {
                    id: popup
                    mainBg: bg
                    reveal: root.reveal
                }
                StyledRectangularShadow {
                    target: popup
                    intensity: 0.25
                    visible: target.visible
                }
                StyledRect {
                    id: bg
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        bottom: parent.bottom
                        bottomMargin: elevationValue
                    }

                    radius: root.mainRounding
                    enableBorders: true
                    color: Colors.colLayer0

                    implicitHeight: Sizes.beamSize.height
                    implicitWidth: {
                        const hintLength = BeamData.getHint()?.length ?? 0;
                        const queryLength = BeamData.query.length;
                        return (hintLength > root.expandedThreshold || queryLength > root.expandedThreshold) ? Sizes.beamSizeExpanded.width : Sizes.beamSize.width;
                    }

                    Behavior on implicitWidth {
                        Anim {}
                    }

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
                        readonly property string inputText: inputField.text

                        implicitSize: 36
                        color: inputField.focus ? Colors.colPrimary : Colors.colLayer3
                        shape: BeamData.getShape()
                        onInputTextChanged: if (inputField.text.length === 0)
                            rotation = 0

                        RotationAnimation on rotation {
                            running: icon.inputText.length > 0
                            loops: Animation.Infinite
                            from: 0
                            to: 360
                            duration: 9000
                            easing.type: Easing.Linear
                        }
                        Behavior on color {
                            CAnim {}
                        }
                        Behavior on rotation {
                            Anim {}
                        }
                    }
                    StyledRect {
                        anchors {
                            top: parent.top
                            bottom: parent.bottom
                            right: sendButton.left
                            left: icon.right
                            margins: Padding.normal
                            rightMargin: Padding.small
                            leftMargin: Padding.huge
                        }

                        radius: Rounding.full
                        color: Colors.colLayer2

                        TextField {
                            id: inputField
                            z: 10
                            anchors.fill: parent
                            focus: root.reveal
                            objectName: "inputField"
                            placeholderText: BeamData.config?.placeholder || "Ask any thing ..."
                            text: BeamData.query
                            background: null
                            selectionColor: Colors.colPrimaryContainer
                            selectedTextColor: Colors.m3.m3onPrimaryContainer
                            color: Colors.colOnLayer0
                            placeholderTextColor: Colors.colSubtext
                            selectByMouse: true
                            leftPadding: Padding.huge
                            rightPadding: Padding.huge + osrButton.width
                            onTextChanged: {
                                BeamData.updateStateFromQuery(text);
                            }

                            font {
                                pixelSize: Fonts.sizes.normal
                                family: Fonts.family.main
                            }

                            Keys.onPressed: event => {
                                if (event.key === Qt.Key_Escape) {
                                    root.hide();
                                    event.accepted = true;
                                }

                                if (event.key === Qt.Key_Return) {
                                    root.sendMessage();
                                    event.accepted = true;
                                }

                                if (event.key === Qt.Key_Tab) {
                                    const hint = BeamData.getHint();
                                    if (hint) {
                                        BeamData.query = BeamData.autocomplete(hint);
                                        event.accepted = true;
                                    }
                                }

                                if (event.modifiers === Qt.ControlModifier && event.key === Qt.Key_S) {
                                    root.takeScreenshot();
                                    event.accepted = true;
                                }
                            }
                        }

                        RippleButtonWithIcon {
                            id: osrButton
                            z: 999
                            buttonRadius: root.mainRounding
                            releaseAction: () => root.takeScreenshot()
                            colBackground: "transparent"
                            materialIcon: "screenshot_region"
                            implicitSize: bg.height * 0.75
                            enabled: !ScreenShotService.isBusy
                            visible: BeamData.config?.showOsrButton || false
                            Behavior on opacity {
                                Anim {}
                            }
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            anchors.rightMargin: Padding.large
                        }
                    }

                    RippleButtonWithIcon {
                        id: sendButton
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: Padding.large
                        releaseAction: () => root.sendMessage()
                        buttonRadius: root.mainRounding
                        colBackground: "transparent"
                        materialIcon: "send"
                        implicitSize: bg.height * 0.75
                        Behavior on opacity {
                            Anim {}
                        }
                    }
                }

                StyledRectangularShadow {
                    show: root.reveal
                    target: bg
                }
            }
        }
    }
}
