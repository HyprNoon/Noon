import QtQuick
import QtQuick3D
import QtQuick3D.AssetUtils
import Quickshell
import qs.common
import qs.common.widgets
import qs.services

StyledRect {
    id: root

    property bool expanded
    property int modelSize: 65
    property real minScale: 50
    property real maxScale: 80
    readonly property var latestMsg: Ai.messageIDs.length > 0 ? Ai.messageByID[Ai.messageIDs[Ai.messageIDs.length - 1]] : null

    // state: "idle" | "thinking" | "responding"
    readonly property string modelState: {
        if (!Ai.isResponding)
            return "idle";
        if (latestMsg?.thinking)
            return "thinking";
        return "responding";
    }

    property string response: ""
    color: "transparent"
    radius: Rounding.verylarge
    clip: true

    Connections {
        target: Ai
        function onResponseFinished() {
            let ids = Ai.messageIDs;
            if (ids.length === 0) {
                root.response = "";
                return;
            }
            let msg = Ai.messageByID[ids[ids.length - 1]];
            root.response = (msg?.role === "assistant" && msg?.content) ? msg.content : "";
        }
    }

    DragHandler {
        target: null
        property real lastX: 0
        onActiveChanged: if (active)
            lastX = centroid.position.x
        onCentroidChanged: if (active) {
            let deltaX = centroid.position.x - lastX;
            model.eulerRotation.y += deltaX * 0.1;
            lastX = centroid.position.x;
        }
    }

    PinchHandler {
        target: null
        property real startScale: 1
        onActiveChanged: if (active)
            startScale = model.scale.x
        onScaleChanged: {
            let s = Math.min(root.maxScale, Math.max(root.minScale, startScale * activeScale));
            model.scale = Qt.vector3d(s, s, s);
        }
    }

    WheelHandler {
        target: null
        onWheel: event => {
            let s = Math.min(root.maxScale, Math.max(root.minScale, model.scale.x + event.angleDelta.y * 0.02));
            model.scale = Qt.vector3d(s, s, s);
        }
    }

    View3D {
        anchors.fill: parent

        environment: SceneEnvironment {
            clearColor: "transparent"
            backgroundMode: SceneEnvironment.Color
            antialiasingMode: SceneEnvironment.MSAA
            antialiasingQuality: SceneEnvironment.High
            // lightProbe: Texture {
            //     textureData: ProceduralSkyTextureData {}
            // }
        }

        RuntimeLoader {
            id: model
            source: Directories.standard.home + "/Desktop/noon.glb"
            scale: Qt.vector3d(root.modelSize, root.modelSize, root.modelSize)
            y: -1.25 * root.modelSize

            onStatusChanged: {
                if (status === RuntimeLoader.Ready) {
                    console.log("Loaded! Bounds:", bounds.minimum, bounds.maximum);
                    console.log("Animations:", animations.length);
                    for (let i = 0; i < animations.length; i++)
                        console.log(" [" + i + "]", animations[i].name);
                } else if (status === RuntimeLoader.Error) {
                    console.log("Error:", errorString);
                }
            }

            // state-driven y bobbing — placeholder until real animations land
            SequentialAnimation on y {
                loops: Animation.Infinite
                running: root.modelState === "thinking"
                NumberAnimation {
                    to: model.y - (root.modelSize * 0.01)
                    duration: 900
                    easing.type: Easing.InOutSine
                }
                NumberAnimation {
                    to: model.y
                    duration: 900
                    easing.type: Easing.InOutSine
                }
            }

            SequentialAnimation on eulerRotation.y {
                loops: Animation.Infinite
                running: root.modelState === "responding"
                NumberAnimation {
                    to: model.eulerRotation.y + 3
                    duration: 300
                    easing.type: Easing.InOutSine
                }
                NumberAnimation {
                    to: model.eulerRotation.y - 3
                    duration: 300
                    easing.type: Easing.InOutSine
                }
            }
        }

        DirectionalLight {
            eulerRotation.x: -30
            brightness: 2.0
        }
        DirectionalLight {
            eulerRotation.x: 30
            eulerRotation.y: -135
            brightness: 1.0
        }
        DirectionalLight {
            eulerRotation.y: 45
            brightness: 0.8
        }

        PerspectiveCamera {
            z: 100
            clipNear: 0.1
            clipFar: 10000
        }
    }

    // state badge
    StyledRect {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: Padding.massive
        width: moodLabel.contentWidth + Padding.huge
        height: 38
        radius: Rounding.large
        color: {
            switch (root.modelState) {
            case "thinking":
                return Colors.colSecondary;
            case "responding":
                return Colors.colPrimary;
            default:
                return Colors.colSurfaceContainerHigh;
            }
        }
        opacity: 0.92

        StyledText {
            id: moodLabel
            anchors.centerIn: parent
            text: {
                switch (root.modelState) {
                case "thinking":
                    return "💭  Thinking";
                case "responding":
                    return "💬  Responding";
                default:
                    return "💤  Idle";
                }
            }
            font.pixelSize: 16
            color: {
                switch (root.modelState) {
                case "thinking":
                    return Colors.colOnSecondary;
                case "responding":
                    return Colors.colOnPrimary;
                default:
                    return Colors.colOnSurface;
                }
            }
        }
    }

    // response subtitle
    StyledRect {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: Padding.massive
        height: subtitleText.implicitHeight + Padding.massive
        radius: Rounding.small
        color: Colors.colSurfaceContainerHigh
        opacity: root.response.length > 0 ? 0.92 : 0
        visible: opacity > 0

        Behavior on opacity {
            Anim {}
        }

        StyledText {
            id: subtitleText
            anchors.fill: parent
            anchors.margins: Padding.large
            text: root.response
            font.pixelSize: Fonts.sizes.large
            font.family: Fonts.family.reading
            color: Colors.colOnSurface
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }
    }
}
