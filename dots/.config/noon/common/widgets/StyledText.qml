import QtQuick
import QtQuick.Layouts
import qs.common

Text {
    id: root

    property bool animateChange: false
    property real animationDistanceX: 0
    property real animationDistanceY: 6
    property bool truncate: false
    property int animationDuration: Animations.durations.normal
    elide: truncate ? Text.ElideRight : Text.ElideNone
    wrapMode: truncate ? Text.NoWrap : Text.Wrap
    maximumLineCount: truncate ? 1 : undefined
    font.variableAxes: Fonts.family.isMono ? ({}) : Fonts.variableAxes.main
    font.family: Fonts.family.main
    renderType: Text.NativeRendering
    verticalAlignment: Text.AlignVCenter
    color: Colors.m3.m3onBackground ?? "black"
    linkColor: Colors.m3.m3primary
    Component.onCompleted: {
        textAnimationBehavior.originalX = root.x;
        textAnimationBehavior.originalY = root.y;
    }

    Behavior on text {
        id: textAnimationBehavior

        property real originalX: root.x
        property real originalY: root.y

        enabled: root.animateChange

        SequentialAnimation {
            alwaysRunToEnd: true

            ParallelAnimation {
                Anim {
                    target: root
                    property: "x"
                    to: textAnimationBehavior.originalX - root.animationDistanceX
                    duration: root.animationDuration
                    easing.type: Easing.InSine
                }

                Anim {
                    target: root
                    property: "y"
                    to: textAnimationBehavior.originalY - root.animationDistanceY
                    duration: root.animationDuration
                    easing.type: Easing.InSine
                }

                Anim {
                    target: root
                    property: "opacity"
                    to: 0
                    duration: root.animationDuration
                    easing.type: Easing.InSine
                }
            }
            // Tie the text update to this point (we don't want it to happen during the first slide+fade)

            PropertyAction {}

            PropertyAction {
                target: root
                property: "x"
                value: textAnimationBehavior.originalX + root.animationDistanceX
            }

            PropertyAction {
                target: root
                property: "y"
                value: textAnimationBehavior.originalY + root.animationDistanceY
            }

            ParallelAnimation {
                Anim {
                    target: root
                    property: "x"
                    to: textAnimationBehavior.originalX
                    duration: root.animationDuration
                    easing.type: Easing.OutSine
                }

                Anim {
                    target: root
                    property: "y"
                    to: textAnimationBehavior.originalY
                    duration: root.animationDuration
                    easing.type: Easing.OutSine
                }

                Anim {
                    target: root
                    property: "opacity"
                    to: 1
                    easing.type: Easing.OutSine
                    duration: root.animationDuration
                }
            }
        }
    }
}
