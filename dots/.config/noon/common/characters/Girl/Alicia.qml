import QtQuick
import QtQuick3D
import qs.services

Node {
    id: node
    readonly property var schema: Ai.modelPoses

    property bool isResponding: false
    property bool isIdle: true
    property bool isThinking: false

    property real jawOpen: 0
    property real eyeBlink: 0
    property real eyeSmile: 0
    property real mouthSmile: 0

    function applyWeight(value, targets) {
        for (let i = 0; i < targets.length; i++) {
            if (targets[i])
                targets[i].weight = value;
        }
    }

    onJawOpenChanged: applyWeight(jawOpen, [bs_face_mouth_a_morphtarget45, bs_face_mouth_a_morphtarget94, bs_face_mouth_a_morphtarget])
    onEyeBlinkChanged: applyWeight(eyeBlink, [bs_face_eye_blink_morphtarget69, bs_face_eye_blink_morphtarget118, bs_face_eye_blink_morphtarget])

    SequentialAnimation {
        running: isIdle
        loops: Animation.Infinite
        NumberAnimation {
            target: node
            property: "jawOpen"
            from: 0.0
            to: 0.04
            duration: 3000
            easing.type: Easing.InOutSine
        }
        NumberAnimation {
            target: node
            property: "jawOpen"
            from: 0.04
            to: 0.0
            duration: 3000
            easing.type: Easing.InOutSine
        }
    }

    Timer {
        interval: Math.random() * 5000 + 2000
        running: true
        repeat: true
        onTriggered: blinkAnim.restart()
    }

    SequentialAnimation {
        id: blinkAnim
        NumberAnimation {
            target: node
            property: "eyeBlink"
            to: 1.0
            duration: 60
        }
        NumberAnimation {
            target: node
            property: "eyeBlink"
            to: 0.0
            duration: 60
        }
    }

    states: [
        State {
            name: "thinking"
            when: isThinking
            PropertyChanges {
                target: leftArm
                eulerRotation: Qt.vector3d(0, 0, 0)
            }
            PropertyChanges {
                target: leftForeArm
                eulerRotation: Qt.vector3d(0, 0, 0)
            }
        },
        State {
            name: "idle"
            when: false //isIdle
            /*
                Rules: child nodes inherit the angle of the parent node
                    ie: forearm if 0 it will be on a straight line with arm
            */
            // < || > move arm: 20,-20 .. foreArm: 120
            // \ || / Yay move arm
            // |_||_| Muscles Move arm 0,0 .. -90,90
            PropertyChanges {
                target: leftArm
                eulerRotation: Qt.vector3d(0, 0, 0)
            }
            PropertyChanges {
                target: rightArm
                eulerRotation: Qt.vector3d(0, 0, 0)
            }
            PropertyChanges {
                target: leftForeArm
                eulerRotation: Qt.vector3d(0, 0, -90)
            }
            PropertyChanges {
                target: rightForeArm
                eulerRotation: Qt.vector3d(0, 0, 90)
            }
        }
    ]

    transitions: [
        Transition {
            from: "idle"
            to: "thinking"
            NumberAnimation {
                properties: "eulerRotation.x,eulerRotation.y,eulerRotation.z"
                duration: 600
                easing.type: Easing.InOutQuad
            }
        },
        Transition {
            from: "thinking"
            to: "idle"
            NumberAnimation {
                properties: "eulerRotation.x,eulerRotation.y,eulerRotation.z"
                duration: 600
                easing.type: Easing.InOutQuad
            }
        }
    ]

    // Texture Definitions
    property url textureData: "maps/textureData.png"
    property url textureData6: "maps/textureData6.png"
    property url textureData208: "maps/textureData208.png"
    property url textureData10: "maps/textureData10.png"
    property url textureData40: "maps/textureData40.png"
    property url textureData195: "maps/textureData195.png"

    Texture {
        id: _2_texture
        source: node.textureData
    }
    Texture {
        id: _5_texture
        source: node.textureData208
    }
    Texture {
        id: _3_texture
        source: node.textureData40
    }
    Texture {
        id: _4_texture
        source: node.textureData195
    }
    Texture {
        id: _1_texture
        source: node.textureData10
    }
    Texture {
        id: _0_texture
        source: node.textureData6
    }

    MorphTarget {
        id: bs_face_mouth_e_morphtarget
        objectName: "bs_face.mouth_e"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_u_morphtarget
        objectName: "bs_face.mouth_u"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_o_morphtarget
        objectName: "bs_face.mouth_o"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_a2_morphtarget
        objectName: "bs_face.mouth_a2"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_n_morphtarget
        objectName: "bs_face.mouth_n"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_i_morphtarget
        objectName: "bs_face.mouth_i"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_Tu_morphtarget
        objectName: "bs_face.mouth_Tu"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_Triangle_morphtarget
        objectName: "bs_face.mouth_Triangle"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_lambda_morphtarget
        objectName: "bs_face.mouth_lambda"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_a_morphtarget
        objectName: "bs_face.mouth_a"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_Square_morphtarget
        objectName: "bs_face.mouth_Square"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_wa_morphtarget
        objectName: "bs_face.mouth_wa"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_wa2_morphtarget
        objectName: "bs_face.mouth_wa2"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_shock_morphtarget
        objectName: "bs_face.mouth_shock"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_angry_morphtarget
        objectName: "bs_face.mouth_angry"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_smile_morphtarget
        objectName: "bs_face.mouth_smile"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_spear_morphtarget
        objectName: "bs_face.mouth_spear"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_spear2_morphtarget
        objectName: "bs_face.mouth_spear2"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_ornerUp_morphtarget
        objectName: "bs_face.mouth_ornerUp"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_cornerDown_morphtarget
        objectName: "bs_face.mouth_cornerDown"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_cornerSpread_morphtarget
        objectName: "bs_face.mouth_cornerSpread"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_noTeethUp_morphtarget
        objectName: "bs_face.mouth_noTeethUp"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_noTeethDown_morphtarget
        objectName: "bs_face.mouth_noTeethDown"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye_smile_morphtarget
        objectName: "bs_face.eye_smile"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eyebrow_serious_morphtarget
        objectName: "bs_face.eyebrow_serious"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_other2_other_shy2_morphtarget
        objectName: "bs_other2.other_shy2"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye_winkL_morphtarget
        objectName: "bs_face.eye_winkL"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye_winkR_morphtarget
        objectName: "bs_face.eye_winkR"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye_winkL2_morphtarget
        objectName: "bs_face.eye_winkL2"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye_winkR2_morphtarget
        objectName: "bs_face.eye_winkR2"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye_Calm_morphtarget
        objectName: "bs_face.eye_Calm"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye___Shape_morphtarget
        objectName: "bs_face.eye___Shape"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye_surprised_morphtarget
        objectName: "bs_face.eye_surprised"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye_TT_morphtarget
        objectName: "bs_face.eye_TT"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye_serious_morphtarget
        objectName: "bs_face.eye_serious"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye_none_morphtarget
        objectName: "bs_face.eye_none"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye_up_morphtarget
        objectName: "bs_face.eye_up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eyebrow_trouble_morphtarget
        objectName: "bs_face.eyebrow_trouble"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eyeblow_smile_morphtarget
        objectName: "bs_face.eyeblow_smile"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eyeblow_angry_morphtarget
        objectName: "bs_face.eyeblow_angry"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eyeblow_up_morphtarget
        objectName: "bs_face.eyeblow_up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eyeblow_down_morphtarget
        objectName: "bs_face.eyeblow_down"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eyeblow_gather_morphtarget
        objectName: "bs_face.eyeblow_gather"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_sface_view_morphtarget
        objectName: "bs_face.sface_view"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_sface_right_morphtarget
        objectName: "bs_face.sface_right"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_sface_left_morphtarget
        objectName: "bs_face.sface_left"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_tongue_morphtarget
        objectName: "bs_face.tongue"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_mortifying_morphtarget
        objectName: "bs_face.mouth_mortifying"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    PrincipledMaterial {
        id: alicia_other_zwrite_material
        objectName: "Alicia_other_zwrite"
        baseColorMap: _5_texture
        roughness: 0.8999999761581421
        alphaMode: PrincipledMaterial.Blend
        lighting: PrincipledMaterial.NoLighting
    }
    MorphTarget {
        id: bs_face_mouth_mortifying_morphtarget190
        objectName: "bs_face.mouth_mortifying"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye_up_morphtarget191
        objectName: "bs_face.eye_up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    PrincipledMaterial {
        id: alicia_hair_material
        objectName: "Alicia_hair"
        baseColorMap: _4_texture
        roughness: 0.8999999761581421
        alphaMode: PrincipledMaterial.Opaque
        lighting: PrincipledMaterial.NoLighting
    }
    PrincipledMaterial {
        id: alicia_hair_trans_zwrite_material
        objectName: "Alicia_hair_trans_zwrite"
        baseColorMap: _4_texture
        roughness: 0.8999999761581421
        alphaMode: PrincipledMaterial.Blend
        lighting: PrincipledMaterial.NoLighting
    }
    PrincipledMaterial {
        id: alicia_hair_wear_material
        objectName: "Alicia_hair_wear"
        baseColorMap: _4_texture
        roughness: 0.8999999761581421
        alphaMode: PrincipledMaterial.Opaque
        lighting: PrincipledMaterial.NoLighting
    }
    PrincipledMaterial {
        id: alicia_hair_trans_material
        objectName: "Alicia_hair_trans"
        baseColorMap: _4_texture
        roughness: 0.8999999761581421
        alphaMode: PrincipledMaterial.Blend
        lighting: PrincipledMaterial.NoLighting
    }
    Skin {
        id: skin
        joints: [head, mituami_F, hair_01_01, hair_02_01, hair_03_01, ribbon_L, ribbon_R, eye_L, eye_light_L, eye_R, eye_light_R, mituami1, hair1_L, hair1_R, headEnd, hair_01_02, hair_02_02, hair_03_02, mituami2, hair2_L, hair2_R, mituami3, hair3_L, hair3_R, tongue03, mituami4, hair4_L, hair4_R, hair5_L, hair5_R, hair6_L, hair6_R, hair7_L, hair7_R, hair8_L, hair8_R]

        inverseBindPoses: [Qt.matrix4x4(1, 0, 0, -3.63736e-08, 0, 1, 0, -1.34677, 0, 0, 1, -0.00104968, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.038323, 0, 1, 0, -1.49125, 0, 0, 1, -0.0112826, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.000240231, 0, 1, 0, -1.5003, 0, 0, 1, 0.0691135, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0341102, 0, 1, 0, -1.50155, 0, 0, 1, 0.064079, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0601437, 0, 1, 0, -1.50155, 0, 0, 1, 0.0454457, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.00970001, 0, 1, 0, -1.54841, 0, 0, 1, -0.00612266, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.00969999, 0, 1, 0, -1.54841, 0, 0, 1, -0.00612269, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0276441, 0, 1, 0, -1.39318, 0, 0, 1, 0.0105538, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0276441, 0, 1, 0, -1.39318, 0, 0, 1, 0.0123537, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.027645, 0, 1, 0, -1.39318, 0, 0, 1, 0.0105538, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.027645, 0, 1, 0, -1.39318, 0, 0, 1, 0.0123537, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.108901, 0, 1, 0, -1.46428, 0, 0, 1, -0.0710791, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0657243, 0, 1, 0, -1.46746, 0, 0, 1, -0.0817376, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.06572, 0, 1, 0, -1.46746, 0, 0, 1, -0.0817377, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -1.913e-08, 0, 1, 0, -1.41881, 0, 0, 1, -0.00119323, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.00493737, 0, 1, 0, -1.45374, 0, 0, 1, 0.0903812, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0516167, 0, 1, 0, -1.45405, 0, 0, 1, 0.0772843, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0823608, 0, 1, 0, -1.45342, 0, 0, 1, 0.0452114, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.132326, 0, 1, 0, -1.38792, 0, 0, 1, -0.0764605, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0719042, 0, 1, 0, -1.3481, 0, 0, 1, -0.0913885, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.0719079, 0, 1, 0, -1.3481, 0, 0, 1, -0.0913917, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.153373, 0, 1, 0, -1.31931, 0, 0, 1, -0.0812956, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0880213, 0, 1, 0, -1.24937, 0, 0, 1, -0.108912, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.0880243, 0, 1, 0, -1.24937, 0, 0, 1, -0.108914, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -7.14813e-08, 0, 1, 0, -1.33304, 0, 0, 1, 0.0657129, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.175793, 0, 1, 0, -1.24622, 0, 0, 1, -0.0864459, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.123352, 0, 1, 0, -1.11048, 0, 0, 1, -0.134016, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.12335, 0, 1, 0, -1.11047, 0, 0, 1, -0.134017, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.193812, 0, 1, 0, -0.992575, 0, 0, 1, -0.182018, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.193811, 0, 1, 0, -0.992571, 0, 0, 1, -0.182019, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.313815, 0, 1, 0, -0.854199, 0, 0, 1, -0.249119, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.312386, 0, 1, 0, -0.856169, 0, 0, 1, -0.248268, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.400865, 0, 1, 0, -0.759555, 0, 0, 1, -0.292185, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.399437, 0, 1, 0, -0.761526, 0, 0, 1, -0.291334, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.441034, 0, 1, 0, -0.702476, 0, 0, 1, -0.306455, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.439605, 0, 1, 0, -0.704446, 0, 0, 1, -0.305605, 0, 0, 0, 1)]
    }
    Skin {
        id: skin203
        joints: [neck1, head, eye_L, eye_R, eye_light_R, mouth, tongue01, tongue02, tongue03, neck, spine3]
        inverseBindPoses: [Qt.matrix4x4(1, 0, 0, -4.56088e-08, 0, 1, 0, -1.30789, 0, 0, 1, -0.00119322, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -3.63736e-08, 0, 1, 0, -1.34677, 0, 0, 1, -0.00104968, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0276441, 0, 1, 0, -1.39318, 0, 0, 1, 0.0105538, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.027645, 0, 1, 0, -1.39318, 0, 0, 1, 0.0105538, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.027645, 0, 1, 0, -1.39318, 0, 0, 1, 0.0123537, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -6.50576e-08, 0, 1, 0, -1.33588, 0, 0, 1, 0.0536577, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -5.72844e-08, 0, 1, 0, -1.3402, 0, 0, 1, 0.0395193, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -6.42263e-08, 0, 1, 0, -1.3367, 0, 0, 1, 0.0523273, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -7.14813e-08, 0, 1, 0, -1.33304, 0, 0, 1, 0.0657129, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -5.47024e-08, 0, 1, 0, -1.26989, 0, 0, 1, -0.00104969, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -2.136e-08, 0, 1, 0, -1.13005, 0, 0, 1, 0.01323, 0, 0, 0, 1)]
    }
    MorphTarget {
        id: bs_face_tongue_morphtarget189
        objectName: "bs_face.tongue"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    Skin {
        id: skin209
        joints: [head, mituami_F, hair_01_01, hair_02_01, eye_L, eye_light_L, eye_R, eye_light_R, headEnd, hair_01_02, hair_02_02, hair_03_02, tongue03]
        inverseBindPoses: [Qt.matrix4x4(1, 0, 0, -3.63736e-08, 0, 1, 0, -1.34677, 0, 0, 1, -0.00104968, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.038323, 0, 1, 0, -1.49125, 0, 0, 1, -0.0112826, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.000240231, 0, 1, 0, -1.5003, 0, 0, 1, 0.0691135, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0341102, 0, 1, 0, -1.50155, 0, 0, 1, 0.064079, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0276441, 0, 1, 0, -1.39318, 0, 0, 1, 0.0105538, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0276441, 0, 1, 0, -1.39318, 0, 0, 1, 0.0123537, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.027645, 0, 1, 0, -1.39318, 0, 0, 1, 0.0105538, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.027645, 0, 1, 0, -1.39318, 0, 0, 1, 0.0123537, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -1.913e-08, 0, 1, 0, -1.41881, 0, 0, 1, -0.00119323, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.00493737, 0, 1, 0, -1.45374, 0, 0, 1, 0.0903812, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0516167, 0, 1, 0, -1.45405, 0, 0, 1, 0.0772843, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0823608, 0, 1, 0, -1.45342, 0, 0, 1, 0.0452114, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -7.14813e-08, 0, 1, 0, -1.33304, 0, 0, 1, 0.0657129, 0, 0, 0, 1)]
    }
    MorphTarget {
        id: bs_other1_sother_shy_morphtarget
        objectName: "bs_other1.sother_shy"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_other1_eye___2Shape_morphtarget
        objectName: "bs_other1.eye___2Shape"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_other1_eye_h1_morphtarget
        objectName: "bs_other1.eye_h1"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_other1_eye_h2_morphtarget
        objectName: "bs_other1.eye_h2"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_other1_eye_h3_morphtarget
        objectName: "bs_other1.eye_h3"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_other1_oher_shocked_morphtarget
        objectName: "bs_other1.oher_shocked"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_other1_sother_tear_morphtarget
        objectName: "bs_other1.sother_tear"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    Skin {
        id: skin219
        joints: [head, eye_L, eye_light_L, eye_R, eye_light_R, headEnd]
        inverseBindPoses: [Qt.matrix4x4(1, 0, 0, -3.63736e-08, 0, 1, 0, -1.34677, 0, 0, 1, -0.00104968, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0276441, 0, 1, 0, -1.39318, 0, 0, 1, 0.0105538, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0276441, 0, 1, 0, -1.39318, 0, 0, 1, 0.0123537, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.027645, 0, 1, 0, -1.39318, 0, 0, 1, 0.0105538, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.027645, 0, 1, 0, -1.39318, 0, 0, 1, 0.0123537, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -1.913e-08, 0, 1, 0, -1.41881, 0, 0, 1, -0.00119323, 0, 0, 0, 1)]
    }
    PrincipledMaterial {
        id: alicia_body_material
        objectName: "Alicia_body"
        baseColorMap: _0_texture
        roughness: 0.8999999761581421
        alphaMode: PrincipledMaterial.Opaque
        lighting: PrincipledMaterial.NoLighting
    }
    MorphTarget {
        id: bs_face_eye_none_morphtarget178
        objectName: "bs_face.eye_none"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye_blink_morphtarget
        objectName: "bs_face.eye_blink"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye_smile_morphtarget168
        objectName: "bs_face.eye_smile"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye_winkL_morphtarget169
        objectName: "bs_face.eye_winkL"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye_winkR_morphtarget170
        objectName: "bs_face.eye_winkR"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye_winkL2_morphtarget171
        objectName: "bs_face.eye_winkL2"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye_winkR2_morphtarget172
        objectName: "bs_face.eye_winkR2"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye_Calm_morphtarget173
        objectName: "bs_face.eye_Calm"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye___Shape_morphtarget174
        objectName: "bs_face.eye___Shape"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye_surprised_morphtarget175
        objectName: "bs_face.eye_surprised"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye_TT_morphtarget176
        objectName: "bs_face.eye_TT"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye_serious_morphtarget177
        objectName: "bs_face.eye_serious"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_be_morphtarget
        objectName: "bs_face.mouth_be"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eyebrow_serious_morphtarget179
        objectName: "bs_face.eyebrow_serious"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eyebrow_trouble_morphtarget180
        objectName: "bs_face.eyebrow_trouble"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eyeblow_smile_morphtarget181
        objectName: "bs_face.eyeblow_smile"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eyeblow_angry_morphtarget182
        objectName: "bs_face.eyeblow_angry"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eyeblow_up_morphtarget183
        objectName: "bs_face.eyeblow_up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eyeblow_down_morphtarget184
        objectName: "bs_face.eyeblow_down"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eyeblow_gather_morphtarget185
        objectName: "bs_face.eyeblow_gather"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_sface_view_morphtarget186
        objectName: "bs_face.sface_view"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_sface_right_morphtarget187
        objectName: "bs_face.sface_right"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_sface_left_morphtarget188
        objectName: "bs_face.sface_left"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_shock_morphtarget57
        objectName: "bs_face.mouth_shock"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_a_morphtarget45
        objectName: "bs_face.mouth_a"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_i_morphtarget46
        objectName: "bs_face.mouth_i"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_u_morphtarget47
        objectName: "bs_face.mouth_u"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_e_morphtarget48
        objectName: "bs_face.mouth_e"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_o_morphtarget49
        objectName: "bs_face.mouth_o"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_a2_morphtarget50
        objectName: "bs_face.mouth_a2"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_n_morphtarget51
        objectName: "bs_face.mouth_n"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_Triangle_morphtarget52
        objectName: "bs_face.mouth_Triangle"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_lambda_morphtarget53
        objectName: "bs_face.mouth_lambda"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_Square_morphtarget54
        objectName: "bs_face.mouth_Square"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_wa_morphtarget55
        objectName: "bs_face.mouth_wa"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_wa2_morphtarget56
        objectName: "bs_face.mouth_wa2"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    Skin {
        id: skin44
        joints: [neck, neck1, head, mituami_F, hair_01_01, hair_02_01, hair_03_01, ribbon_R, eye_L, eye_light_L, eye_R, eye_light_R, mouth, hair1_L, headEnd, hair_01_02, hair_02_02, hair_03_02, tongue01, hair2_L, tongue02, tongue03]
        inverseBindPoses: [Qt.matrix4x4(1, 0, 0, -5.47024e-08, 0, 1, 0, -1.26989, 0, 0, 1, -0.00104969, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -4.56088e-08, 0, 1, 0, -1.30789, 0, 0, 1, -0.00119322, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -3.63736e-08, 0, 1, 0, -1.34677, 0, 0, 1, -0.00104968, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.038323, 0, 1, 0, -1.49125, 0, 0, 1, -0.0112826, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.000240231, 0, 1, 0, -1.5003, 0, 0, 1, 0.0691135, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0341102, 0, 1, 0, -1.50155, 0, 0, 1, 0.064079, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0601437, 0, 1, 0, -1.50155, 0, 0, 1, 0.0454457, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.00969999, 0, 1, 0, -1.54841, 0, 0, 1, -0.00612269, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0276441, 0, 1, 0, -1.39318, 0, 0, 1, 0.0105538, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0276441, 0, 1, 0, -1.39318, 0, 0, 1, 0.0123537, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.027645, 0, 1, 0, -1.39318, 0, 0, 1, 0.0105538, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.027645, 0, 1, 0, -1.39318, 0, 0, 1, 0.0123537, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -6.50576e-08, 0, 1, 0, -1.33588, 0, 0, 1, 0.0536577, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0657243, 0, 1, 0, -1.46746, 0, 0, 1, -0.0817376, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -1.913e-08, 0, 1, 0, -1.41881, 0, 0, 1, -0.00119323, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.00493737, 0, 1, 0, -1.45374, 0, 0, 1, 0.0903812, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0516167, 0, 1, 0, -1.45405, 0, 0, 1, 0.0772843, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0823608, 0, 1, 0, -1.45342, 0, 0, 1, 0.0452114, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -5.72844e-08, 0, 1, 0, -1.3402, 0, 0, 1, 0.0395193, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0719042, 0, 1, 0, -1.3481, 0, 0, 1, -0.0913885, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -6.42263e-08, 0, 1, 0, -1.3367, 0, 0, 1, 0.0523273, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -7.14813e-08, 0, 1, 0, -1.33304, 0, 0, 1, 0.0657129, 0, 0, 0, 1)]
    }
    MorphTarget {
        id: bs_face_mouth_angry_morphtarget58
        objectName: "bs_face.mouth_angry"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_smile_morphtarget59
        objectName: "bs_face.mouth_smile"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_spear_morphtarget60
        objectName: "bs_face.mouth_spear"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_spear2_morphtarget61
        objectName: "bs_face.mouth_spear2"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_ornerUp_morphtarget62
        objectName: "bs_face.mouth_ornerUp"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_cornerDown_morphtarget63
        objectName: "bs_face.mouth_cornerDown"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_cornerSpread_morphtarget64
        objectName: "bs_face.mouth_cornerSpread"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_noTeethUp_morphtarget65
        objectName: "bs_face.mouth_noTeethUp"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_noTeethDown_morphtarget66
        objectName: "bs_face.mouth_noTeethDown"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_Tu_morphtarget67
        objectName: "bs_face.mouth_Tu"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_be_morphtarget68
        objectName: "bs_face.mouth_be"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    PrincipledMaterial {
        id: alicia_body_wear_material
        objectName: "Alicia_body_wear"
        baseColorMap: _0_texture
        roughness: 0.8999999761581421
        alphaMode: PrincipledMaterial.Opaque
        lighting: PrincipledMaterial.NoLighting
    }
    PrincipledMaterial {
        id: alicia_wear_material
        objectName: "Alicia_wear"
        baseColorMap: _1_texture
        roughness: 0.8999999761581421
        alphaMode: PrincipledMaterial.Opaque
        lighting: PrincipledMaterial.NoLighting
    }
    Skin {
        id: skin12
        joints: [spine3, leftShoulder, rightShoulder, leftArm, rightArm, leftForeArm, rightForeArm, leftHand, rightHand, leftFingersBase, rightFingersBase, leftHandThumb1, leftHandPinky1, leftHandRing1, leftHandMiddle1, leftHandIndex1, rightHandIndex1, rightHandMiddle1, rightHandRing1, rightHandPinky1, rightHandThumb1, leftHandThumb2, leftHandPinky2, leftHandRing2, leftHandMiddle2, leftHandIndex2, rightHandIndex2, rightHandMiddle2, rightHandRing2, rightHandPinky2, rightHandThumb2, leftHandThumb3, leftHandPinky3, leftHandRing3, leftHandMiddle3, leftHandIndex3, rightHandIndex3, rightHandMiddle3, rightHandRing3, rightHandPinky3, rightHandThumb3, leftHandThumb4, leftHandPinky4, leftHandRing4, leftHandMiddle4, leftHandIndex4, rightHandIndex4, rightHandMiddle4, rightHandRing4, rightHandPinky4, rightHandThumb4, neck, neck1, head, tit_R, tit_L, spine, spine1, spine2, hips, rightUpLeg, leftUpLeg]
        inverseBindPoses: [Qt.matrix4x4(1, 0, 0, -2.136e-08, 0, 1, 0, -1.13005, 0, 0, 1, 0.01323, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0164333, 0, 1, 0, -1.26721, 0, 0, 1, -0.00937791, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.0164301, 0, 1, 0, -1.26721, 0, 0, 1, -0.00937791, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0707422, 0, 1, 0, -1.27052, 0, 0, 1, -0.00937789, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.0707554, 0, 1, 0, -1.27024, 0, 0, 1, -0.00937783, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.279694, 0, 1, 0, -1.26484, 0, 0, 1, -0.00862363, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.279678, 0, 1, 0, -1.2636, 0, 0, 1, -0.00846217, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.49742, 0, 1, 0, -1.26387, 0, 0, 1, -0.00751136, 0, 0, 0, 1) // leftHand[cite: 1]
            , Qt.matrix4x4(1, 0, 0, -0.497403, 0, 1, 0, -1.26257, 0, 0, 1, -0.00711707, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.500687, 0, 1, 0, -1.264, 0, 0, 1, -0.00750485, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.502182, 0, 1, 0, -1.26251, 0, 0, 1, -0.00702277, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.507438, 0, 1, 0, -1.25528, 0, 0, 1, 0.00798679, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.546004, 0, 1, 0, -1.2627, 0, 0, 1, -0.0297059, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.550142, 0, 1, 0, -1.26632, 0, 0, 1, -0.0185573, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.550466, 0, 1, 0, -1.26864, 0, 0, 1, -0.00550765, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.549841, 0, 1, 0, -1.26801, 0, 0, 1, 0.00818418, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.549807, 0, 1, 0, -1.26658, 0, 0, 1, 0.00866651, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.550447, 0, 1, 0, -1.2673, 0, 0, 1, -0.00501965, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.550138, 0, 1, 0, -1.26508, 0, 0, 1, -0.0180865, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.54601, 0, 1, 0, -1.26155, 0, 0, 1, -0.0292661, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.507401, 0, 1, 0, -1.25386, 0, 0, 1, 0.00832818, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.535676, 0, 1, 0, -1.24789, 0, 0, 1, 0.022026, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.565785, 0, 1, 0, -1.26164, 0, 0, 1, -0.0286247, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.573931, 0, 1, 0, -1.26509, 0, 0, 1, -0.0175577, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.581266, 0, 1, 0, -1.26683, 0, 0, 1, -0.00550853, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.576725, 0, 1, 0, -1.26625, 0, 0, 1, 0.00746303, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.576692, 0, 1, 0, -1.26482, 0, 0, 1, 0.00796661, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.581247, 0, 1, 0, -1.26549, 0, 0, 1, -0.00499733, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.573925, 0, 1, 0, -1.26384, 0, 0, 1, -0.0170716, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.56579, 0, 1, 0, -1.26048, 0, 0, 1, -0.0281738, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.535616, 0, 1, 0, -1.24638, 0, 0, 1, 0.0223653, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.555337, 0, 1, 0, -1.23986, 0, 0, 1, 0.0237325, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.579196, 0, 1, 0, -1.2609, 0, 0, 1, -0.0280792, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.589992, 0, 1, 0, -1.26427, 0, 0, 1, -0.0170528, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.600063, 0, 1, 0, -1.26572, 0, 0, 1, -0.00549515, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.594005, 0, 1, 0, -1.26512, 0, 0, 1, 0.00720973, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.593972, 0, 1, 0, -1.26368, 0, 0, 1, 0.00772692, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.600043, 0, 1, 0, -1.26437, 0, 0, 1, -0.00496987, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.589986, 0, 1, 0, -1.26302, 0, 0, 1, -0.0165563, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.579201, 0, 1, 0, -1.25973, 0, 0, 1, -0.0276209, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.555281, 0, 1, 0, -1.23836, 0, 0, 1, 0.0240614, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.55963, 0, 1, 0, -1.23908, 0, 0, 1, 0.0241766, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.585724, 0, 1, 0, -1.26089, 0, 0, 1, -0.0280839, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.597379, 0, 1, 0, -1.26393, 0, 0, 1, -0.0175918, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.607617, 0, 1, 0, -1.26572, 0, 0, 1, -0.00557373, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.599772, 0, 1, 0, -1.26535, 0, 0, 1, 0.0072141, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.606857, 0, 1, 0, -1.2619, 0, 0, 1, 0.00663674, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.611341, 0, 1, 0, -1.26383, 0, 0, 1, -0.00633908, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.601366, 0, 1, 0, -1.26261, 0, 0, 1, -0.0181935, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.587235, 0, 1, 0, -1.2592, 0, 0, 1, -0.0294176, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.562008, 0, 1, 0, -1.23573, 0, 0, 1, 0.0230623, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -5.47024e-08, 0, 1, 0, -1.26989, 0, 0, 1, -0.00104969, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -4.56088e-08, 0, 1, 0, -1.30789, 0, 0, 1, -0.00119322, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -3.63736e-08, 0, 1, 0, -1.34677, 0, 0, 1, -0.00104968, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.032, 0, 1, 0, -1.1959, 0, 0, 1, 0.00571341, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.032, 0, 1, 0, -1.1959, 0, 0, 1, 0.00571349, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0, 0, 1, 0, -0.984177, 0, 0, 1, 0.01323, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0, 0, 1, 0, -1.04046, 0, 0, 1, 0.0138706, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -1.05657e-08, 0, 1, 0, -1.08477, 0, 0, 1, 0.0128835, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0, 0, 1, 0, -0.97146, 0, 0, 1, 2.15708e-16, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.0603889, 0, 1, 0, -0.885984, 0, 0, 1, 0.000916982, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0603868, 0, 1, 0, -0.885984, 0, 0, 1, 0.000916982, 0, 0, 0, 1)]
    }

    Skin {
        id: skin15
        joints: [spine3, tit_R, tit_L, spine, spine1, spine2, hips, rightUpLeg, leftUpLeg, rightLeg, leftLeg, rightFoot, leftFoot, rightToeBase, leftToeBase, rightToeEnd, leftToeEnd]
        inverseBindPoses: [Qt.matrix4x4(1, 0, 0, -2.136e-08, 0, 1, 0, -1.13005, 0, 0, 1, 0.01323, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.032, 0, 1, 0, -1.1959, 0, 0, 1, 0.00571341, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.032, 0, 1, 0, -1.1959, 0, 0, 1, 0.00571349, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0, 0, 1, 0, -0.984177, 0, 0, 1, 0.01323, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0, 0, 1, 0, -1.04046, 0, 0, 1, 0.0138706, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -1.05657e-08, 0, 1, 0, -1.08477, 0, 0, 1, 0.0128835, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0, 0, 1, 0, -0.97146, 0, 0, 1, 2.15708e-16, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.0603889, 0, 1, 0, -0.885984, 0, 0, 1, 0.000916982, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0603868, 0, 1, 0, -0.885984, 0, 0, 1, 0.000916982, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.0536633, 0, 1, 0, -0.522665, 0, 0, 1, 0.00227664, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0536618, 0, 1, 0, -0.522665, 0, 0, 1, 0.00227643, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.0411367, 0, 1, 0, -0.103158, 0, 0, 1, -0.0178923, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0411365, 0, 1, 0, -0.103158, 0, 0, 1, -0.0178927, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.0377021, 0, 1, 0, -0.0201504, 0, 0, 1, 0.0595897, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0377025, 0, 1, 0, -0.0201504, 0, 0, 1, 0.0595891, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.037697, 0, 1, 0, -0.0203746, 0, 0, 1, 0.0795885, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0376974, 0, 1, 0, -0.0203744, 0, 0, 1, 0.0795879, 0, 0, 0, 1)]
    }
    Skin {
        id: skin18
        joints: [hips, spine, rightUpLeg, leftUpLeg, skirt_08_01, skirt_09_01, skirt_01_01, skirt_02_01, skirt_10_01, skirt_03_01, skirt_04_01, skirt_06_01, skirt_05_01, skirt_07_01, spine1, skirt_08_02, skirt_09_02, skirt_01_02, skirt_02_02, skirt_10_02, skirt_03_02, skirt_04_02, skirt_06_02, skirt_05_02, skirt_07_02, spine2, spine3, tit_R, tit_L]
        inverseBindPoses: [Qt.matrix4x4(1, 0, 0, 0, 0, 1, 0, -0.97146, 0, 0, 1, 2.15708e-16, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0, 0, 1, 0, -0.984177, 0, 0, 1, 0.01323, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.0603889, 0, 1, 0, -0.885984, 0, 0, 1, 0.000916982, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0603868, 0, 1, 0, -0.885984, 0, 0, 1, 0.000916982, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.09333, 0, 1, 0, -0.984845, 0, 0, 1, -0.0236452, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.10022, 0, 1, 0, -0.985393, 0, 0, 1, 0.0256662, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0, 0, 1, 0, -0.988037, 0, 0, 1, 0.0869725, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.066668, 0, 1, 0, -0.983055, 0, 0, 1, 0.0718427, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.06667, 0, 1, 0, -0.983055, 0, 0, 1, 0.0718427, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.100217, 0, 1, 0, -0.985393, 0, 0, 1, 0.0256662, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0933305, 0, 1, 0, -0.984845, 0, 0, 1, -0.0236452, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -1.02712e-08, 0, 1, 0, -0.980549, 0, 0, 1, -0.0850501, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0537138, 0, 1, 0, -0.984845, 0, 0, 1, -0.0650195, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.05371, 0, 1, 0, -0.984845, 0, 0, 1, -0.0650195, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0, 0, 1, 0, -1.04046, 0, 0, 1, 0.0138706, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.168068, 0, 1, 0, -0.856324, 0, 0, 1, -0.0611558, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.176842, 0, 1, 0, -0.848593, 0, 0, 1, 0.0377194, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0, 0, 1, 0, -0.8377, 0, 0, 1, 0.151193, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.116737, 0, 1, 0, -0.841361, 0, 0, 1, 0.125394, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.116739, 0, 1, 0, -0.841361, 0, 0, 1, 0.125394, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.176839, 0, 1, 0, -0.848593, 0, 0, 1, 0.0377194, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.168069, 0, 1, 0, -0.856324, 0, 0, 1, -0.0611557, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -1.02712e-08, 0, 1, 0, -0.852027, 0, 0, 1, -0.168673, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0982686, 0, 1, 0, -0.856324, 0, 0, 1, -0.135785, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.0982648, 0, 1, 0, -0.856324, 0, 0, 1, -0.135785, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -1.05657e-08, 0, 1, 0, -1.08477, 0, 0, 1, 0.0128835, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -2.136e-08, 0, 1, 0, -1.13005, 0, 0, 1, 0.01323, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.032, 0, 1, 0, -1.1959, 0, 0, 1, 0.00571341, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.032, 0, 1, 0, -1.1959, 0, 0, 1, 0.00571349, 0, 0, 0, 1)]
    }
    Skin {
        id: skin21
        joints: [hips, spine, rightUpLeg, leftUpLeg, skirt_08_01, skirt_09_01, skirt_01_01, skirt_02_01, skirt_10_01, skirt_03_01, skirt_04_01, skirt_06_01, skirt_05_01, skirt_07_01, skirt_08_02, skirt_09_02, skirt_01_02, skirt_02_02, skirt_10_02, skirt_03_02, skirt_04_02, skirt_06_02, skirt_05_02, skirt_07_02]
        inverseBindPoses: [Qt.matrix4x4(1, 0, 0, 0, 0, 1, 0, -0.97146, 0, 0, 1, 2.15708e-16, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0, 0, 1, 0, -0.984177, 0, 0, 1, 0.01323, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.0603889, 0, 1, 0, -0.885984, 0, 0, 1, 0.000916982, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0603868, 0, 1, 0, -0.885984, 0, 0, 1, 0.000916982, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.09333, 0, 1, 0, -0.984845, 0, 0, 1, -0.0236452, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.10022, 0, 1, 0, -0.985393, 0, 0, 1, 0.0256662, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0, 0, 1, 0, -0.988037, 0, 0, 1, 0.0869725, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.066668, 0, 1, 0, -0.983055, 0, 0, 1, 0.0718427, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.06667, 0, 1, 0, -0.983055, 0, 0, 1, 0.0718427, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.100217, 0, 1, 0, -0.985393, 0, 0, 1, 0.0256662, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0933305, 0, 1, 0, -0.984845, 0, 0, 1, -0.0236452, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -1.02712e-08, 0, 1, 0, -0.980549, 0, 0, 1, -0.0850501, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0537138, 0, 1, 0, -0.984845, 0, 0, 1, -0.0650195, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.05371, 0, 1, 0, -0.984845, 0, 0, 1, -0.0650195, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.168068, 0, 1, 0, -0.856324, 0, 0, 1, -0.0611558, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.176842, 0, 1, 0, -0.848593, 0, 0, 1, 0.0377194, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0, 0, 1, 0, -0.8377, 0, 0, 1, 0.151193, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.116737, 0, 1, 0, -0.841361, 0, 0, 1, 0.125394, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.116739, 0, 1, 0, -0.841361, 0, 0, 1, 0.125394, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.176839, 0, 1, 0, -0.848593, 0, 0, 1, 0.0377194, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.168069, 0, 1, 0, -0.856324, 0, 0, 1, -0.0611557, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -1.02712e-08, 0, 1, 0, -0.852027, 0, 0, 1, -0.168673, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0982686, 0, 1, 0, -0.856324, 0, 0, 1, -0.135785, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.0982648, 0, 1, 0, -0.856324, 0, 0, 1, -0.135785, 0, 0, 0, 1)]
    }
    Skin {
        id: skin24
        joints: [hips, spine, skirt_08_01, skirt_09_01, skirt_01_01, skirt_02_01, skirt_10_01, skirt_03_01, skirt_04_01, skirt_06_01, skirt_05_01, skirt_07_01, skirt_08_02, skirt_09_02, skirt_01_02, skirt_02_02, skirt_10_02, skirt_03_02, skirt_04_02, skirt_06_02, skirt_05_02, skirt_07_02]
        inverseBindPoses: [Qt.matrix4x4(1, 0, 0, 0, 0, 1, 0, -0.97146, 0, 0, 1, 2.15708e-16, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0, 0, 1, 0, -0.984177, 0, 0, 1, 0.01323, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.09333, 0, 1, 0, -0.984845, 0, 0, 1, -0.0236452, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.10022, 0, 1, 0, -0.985393, 0, 0, 1, 0.0256662, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0, 0, 1, 0, -0.988037, 0, 0, 1, 0.0869725, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.066668, 0, 1, 0, -0.983055, 0, 0, 1, 0.0718427, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.06667, 0, 1, 0, -0.983055, 0, 0, 1, 0.0718427, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.100217, 0, 1, 0, -0.985393, 0, 0, 1, 0.0256662, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0933305, 0, 1, 0, -0.984845, 0, 0, 1, -0.0236452, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -1.02712e-08, 0, 1, 0, -0.980549, 0, 0, 1, -0.0850501, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0537138, 0, 1, 0, -0.984845, 0, 0, 1, -0.0650195, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.05371, 0, 1, 0, -0.984845, 0, 0, 1, -0.0650195, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.168068, 0, 1, 0, -0.856324, 0, 0, 1, -0.0611558, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.176842, 0, 1, 0, -0.848593, 0, 0, 1, 0.0377194, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0, 0, 1, 0, -0.8377, 0, 0, 1, 0.151193, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.116737, 0, 1, 0, -0.841361, 0, 0, 1, 0.125394, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.116739, 0, 1, 0, -0.841361, 0, 0, 1, 0.125394, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.176839, 0, 1, 0, -0.848593, 0, 0, 1, 0.0377194, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.168069, 0, 1, 0, -0.856324, 0, 0, 1, -0.0611557, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -1.02712e-08, 0, 1, 0, -0.852027, 0, 0, 1, -0.168673, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0982686, 0, 1, 0, -0.856324, 0, 0, 1, -0.135785, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.0982648, 0, 1, 0, -0.856324, 0, 0, 1, -0.135785, 0, 0, 0, 1)]
    }
    MorphTarget {
        id: bs_face_eye_blink_morphtarget69
        objectName: "bs_face.eye_blink"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    Skin {
        id: skin27
        joints: [hips, skirt_08_01, skirt_09_01, skirt_01_01, skirt_02_01, skirt_10_01, skirt_03_01, skirt_04_01, skirt_06_01, skirt_05_01, skirt_07_01, skirt_08_02, skirt_09_02, skirt_01_02, skirt_02_02, skirt_10_02, skirt_03_02, skirt_04_02, skirt_06_02, skirt_05_02, skirt_07_02]
        inverseBindPoses: [Qt.matrix4x4(1, 0, 0, 0, 0, 1, 0, -0.97146, 0, 0, 1, 2.15708e-16, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.09333, 0, 1, 0, -0.984845, 0, 0, 1, -0.0236452, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.10022, 0, 1, 0, -0.985393, 0, 0, 1, 0.0256662, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0, 0, 1, 0, -0.988037, 0, 0, 1, 0.0869725, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.066668, 0, 1, 0, -0.983055, 0, 0, 1, 0.0718427, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.06667, 0, 1, 0, -0.983055, 0, 0, 1, 0.0718427, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.100217, 0, 1, 0, -0.985393, 0, 0, 1, 0.0256662, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0933305, 0, 1, 0, -0.984845, 0, 0, 1, -0.0236452, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -1.02712e-08, 0, 1, 0, -0.980549, 0, 0, 1, -0.0850501, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0537138, 0, 1, 0, -0.984845, 0, 0, 1, -0.0650195, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.05371, 0, 1, 0, -0.984845, 0, 0, 1, -0.0650195, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.168068, 0, 1, 0, -0.856324, 0, 0, 1, -0.0611558, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.176842, 0, 1, 0, -0.848593, 0, 0, 1, 0.0377194, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0, 0, 1, 0, -0.8377, 0, 0, 1, 0.151193, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.116737, 0, 1, 0, -0.841361, 0, 0, 1, 0.125394, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.116739, 0, 1, 0, -0.841361, 0, 0, 1, 0.125394, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.176839, 0, 1, 0, -0.848593, 0, 0, 1, 0.0377194, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.168069, 0, 1, 0, -0.856324, 0, 0, 1, -0.0611557, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -1.02712e-08, 0, 1, 0, -0.852027, 0, 0, 1, -0.168673, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0982686, 0, 1, 0, -0.856324, 0, 0, 1, -0.135785, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.0982648, 0, 1, 0, -0.856324, 0, 0, 1, -0.135785, 0, 0, 0, 1)]
    }
    PrincipledMaterial {
        id: alicia_eye_material
        objectName: "Alicia_eye"
        baseColorMap: _2_texture
        roughness: 0.8999999761581421
        alphaMode: PrincipledMaterial.Opaque
        lighting: PrincipledMaterial.NoLighting
    }
    Skin {
        id: skin33
        joints: [head, hair_02_01, eye_L, eye_light_L, eye_R, eye_light_R, headEnd, hair_03_02, tongue03]
        inverseBindPoses: [Qt.matrix4x4(1, 0, 0, -3.63736e-08, 0, 1, 0, -1.34677, 0, 0, 1, -0.00104968, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0341102, 0, 1, 0, -1.50155, 0, 0, 1, 0.064079, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0276441, 0, 1, 0, -1.39318, 0, 0, 1, 0.0105538, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0276441, 0, 1, 0, -1.39318, 0, 0, 1, 0.0123537, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.027645, 0, 1, 0, -1.39318, 0, 0, 1, 0.0105538, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.027645, 0, 1, 0, -1.39318, 0, 0, 1, 0.0123537, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -1.913e-08, 0, 1, 0, -1.41881, 0, 0, 1, -0.00119323, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0823608, 0, 1, 0, -1.45342, 0, 0, 1, 0.0452114, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -7.14813e-08, 0, 1, 0, -1.33304, 0, 0, 1, 0.0657129, 0, 0, 0, 1)]
    }
    MorphTarget {
        id: bs_eye_noHilighnt_morphtarget
        objectName: "bs_eye.noHilighnt"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_eye_seyeMin_morphtarget
        objectName: "bs_eye.seyeMin"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_eye_seyeRound_morphtarget
        objectName: "bs_eye.seyeRound"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    PrincipledMaterial {
        id: alicia_face_material
        objectName: "Alicia_face"
        baseColorMap: _3_texture
        roughness: 0.8999999761581421
        alphaMode: PrincipledMaterial.Opaque
        lighting: PrincipledMaterial.NoLighting
    }
    PrincipledMaterial {
        id: alicia_eye_white_material
        objectName: "Alicia_eye_white"
        baseColorMap: _3_texture
        roughness: 0.8999999761581421
        alphaMode: PrincipledMaterial.Opaque
        lighting: PrincipledMaterial.NoLighting
    }
    PrincipledMaterial {
        id: alicia_face_mastuge_material
        objectName: "Alicia_face_mastuge"
        baseColorMap: _3_texture
        roughness: 0.8999999761581421
        alphaMode: PrincipledMaterial.Blend
        lighting: PrincipledMaterial.NoLighting
    }
    MorphTarget {
        id: bs_face_mouth_shock_morphtarget106
        objectName: "bs_face.mouth_shock"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_a_morphtarget94
        objectName: "bs_face.mouth_a"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_i_morphtarget95
        objectName: "bs_face.mouth_i"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_u_morphtarget96
        objectName: "bs_face.mouth_u"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_e_morphtarget97
        objectName: "bs_face.mouth_e"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_o_morphtarget98
        objectName: "bs_face.mouth_o"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_a2_morphtarget99
        objectName: "bs_face.mouth_a2"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_n_morphtarget100
        objectName: "bs_face.mouth_n"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_Triangle_morphtarget101
        objectName: "bs_face.mouth_Triangle"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_lambda_morphtarget102
        objectName: "bs_face.mouth_lambda"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_Square_morphtarget103
        objectName: "bs_face.mouth_Square"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_wa_morphtarget104
        objectName: "bs_face.mouth_wa"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_wa2_morphtarget105
        objectName: "bs_face.mouth_wa2"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye_up_morphtarget93
        objectName: "bs_face.eye_up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_angry_morphtarget107
        objectName: "bs_face.mouth_angry"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_smile_morphtarget108
        objectName: "bs_face.mouth_smile"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_spear_morphtarget109
        objectName: "bs_face.mouth_spear"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_spear2_morphtarget110
        objectName: "bs_face.mouth_spear2"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_ornerUp_morphtarget111
        objectName: "bs_face.mouth_ornerUp"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_cornerDown_morphtarget112
        objectName: "bs_face.mouth_cornerDown"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_cornerSpread_morphtarget113
        objectName: "bs_face.mouth_cornerSpread"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_noTeethUp_morphtarget114
        objectName: "bs_face.mouth_noTeethUp"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_noTeethDown_morphtarget115
        objectName: "bs_face.mouth_noTeethDown"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_Tu_morphtarget116
        objectName: "bs_face.mouth_Tu"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_be_morphtarget117
        objectName: "bs_face.mouth_be"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eyebrow_serious_morphtarget81
        objectName: "bs_face.eyebrow_serious"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye_smile_morphtarget70
        objectName: "bs_face.eye_smile"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye_winkL_morphtarget71
        objectName: "bs_face.eye_winkL"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye_winkR_morphtarget72
        objectName: "bs_face.eye_winkR"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye_winkL2_morphtarget73
        objectName: "bs_face.eye_winkL2"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye_winkR2_morphtarget74
        objectName: "bs_face.eye_winkR2"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye_Calm_morphtarget75
        objectName: "bs_face.eye_Calm"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye___Shape_morphtarget76
        objectName: "bs_face.eye___Shape"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye_surprised_morphtarget77
        objectName: "bs_face.eye_surprised"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye_TT_morphtarget78
        objectName: "bs_face.eye_TT"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye_serious_morphtarget79
        objectName: "bs_face.eye_serious"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye_none_morphtarget80
        objectName: "bs_face.eye_none"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eye_blink_morphtarget118
        objectName: "bs_face.eye_blink"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eyebrow_trouble_morphtarget82
        objectName: "bs_face.eyebrow_trouble"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eyeblow_smile_morphtarget83
        objectName: "bs_face.eyeblow_smile"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eyeblow_angry_morphtarget84
        objectName: "bs_face.eyeblow_angry"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eyeblow_up_morphtarget85
        objectName: "bs_face.eyeblow_up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eyeblow_down_morphtarget86
        objectName: "bs_face.eyeblow_down"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_eyeblow_gather_morphtarget87
        objectName: "bs_face.eyeblow_gather"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_sface_view_morphtarget88
        objectName: "bs_face.sface_view"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_sface_right_morphtarget89
        objectName: "bs_face.sface_right"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_sface_left_morphtarget90
        objectName: "bs_face.sface_left"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_tongue_morphtarget91
        objectName: "bs_face.tongue"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: bs_face_mouth_mortifying_morphtarget92
        objectName: "bs_face.mouth_mortifying"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }

    // Nodes:
    Node {
        id: root
        objectName: "ROOT"
        Node {
            id: mesh
            objectName: "mesh"
            Model {
                id: body_top
                objectName: "body_top"
                source: "meshes/body_top_mesh.mesh"
                skin: skin12
                materials: [alicia_body_material, alicia_body_wear_material, alicia_wear_material]
            }
            Model {
                id: body_under
                objectName: "body_under"
                source: "meshes/body_under_mesh.mesh"
                skin: skin15
                materials: [alicia_body_material, alicia_wear_material]
            }
            Model {
                id: cloth
                objectName: "cloth"
                source: "meshes/cloth_baked_mesh.mesh"
                skin: skin18
                materials: [alicia_wear_material]
            }
            Model {
                id: cloth1
                objectName: "cloth1"
                source: "meshes/cloth1_baked_mesh.mesh"
                skin: skin21
                materials: [alicia_wear_material]
            }
            Model {
                id: cloth2
                objectName: "cloth2"
                source: "meshes/cloth2_baked_mesh.mesh"
                skin: skin24
                materials: [alicia_wear_material]
            }
            Model {
                id: cloth_ribbon
                objectName: "cloth_ribbon"
                source: "meshes/cloth_ribbon_baked_mesh.mesh"
                skin: skin27
                materials: [alicia_wear_material]
            }
            Model {
                id: eye
                objectName: "eye"
                source: "meshes/eye_baked_mesh.mesh"
                skin: skin33
                materials: [alicia_eye_material]
                morphTargets: [bs_eye_noHilighnt_morphtarget, bs_eye_seyeMin_morphtarget, bs_eye_seyeRound_morphtarget]
            }
            Model {
                id: face
                objectName: "face"
                source: "meshes/face_mesh.mesh"
                skin: skin44
                materials: [alicia_face_material, alicia_eye_white_material, alicia_face_mastuge_material]
                morphTargets: [bs_face_mouth_a_morphtarget45, bs_face_mouth_i_morphtarget46, bs_face_mouth_u_morphtarget47, bs_face_mouth_e_morphtarget48, bs_face_mouth_o_morphtarget49, bs_face_mouth_a2_morphtarget50, bs_face_mouth_n_morphtarget51, bs_face_mouth_Triangle_morphtarget52, bs_face_mouth_lambda_morphtarget53, bs_face_mouth_Square_morphtarget54, bs_face_mouth_wa_morphtarget55, bs_face_mouth_wa2_morphtarget56, bs_face_mouth_shock_morphtarget57, bs_face_mouth_angry_morphtarget58, bs_face_mouth_smile_morphtarget59, bs_face_mouth_spear_morphtarget60, bs_face_mouth_spear2_morphtarget61, bs_face_mouth_ornerUp_morphtarget62, bs_face_mouth_cornerDown_morphtarget63, bs_face_mouth_cornerSpread_morphtarget64, bs_face_mouth_noTeethUp_morphtarget65, bs_face_mouth_noTeethDown_morphtarget66, bs_face_mouth_Tu_morphtarget67, bs_face_mouth_be_morphtarget68, bs_face_eye_blink_morphtarget69, bs_face_eye_smile_morphtarget70, bs_face_eye_winkL_morphtarget71, bs_face_eye_winkR_morphtarget72, bs_face_eye_winkL2_morphtarget73, bs_face_eye_winkR2_morphtarget74, bs_face_eye_Calm_morphtarget75, bs_face_eye___Shape_morphtarget76, bs_face_eye_surprised_morphtarget77, bs_face_eye_TT_morphtarget78, bs_face_eye_serious_morphtarget79, bs_face_eye_none_morphtarget80, bs_face_eyebrow_serious_morphtarget81, bs_face_eyebrow_trouble_morphtarget82, bs_face_eyeblow_smile_morphtarget83, bs_face_eyeblow_angry_morphtarget84, bs_face_eyeblow_up_morphtarget85, bs_face_eyeblow_down_morphtarget86, bs_face_eyeblow_gather_morphtarget87, bs_face_sface_view_morphtarget88, bs_face_sface_right_morphtarget89, bs_face_sface_left_morphtarget90, bs_face_tongue_morphtarget91, bs_face_mouth_mortifying_morphtarget92, bs_face_eye_up_morphtarget93, bs_face_mouth_a_morphtarget94, bs_face_mouth_i_morphtarget95, bs_face_mouth_u_morphtarget96, bs_face_mouth_e_morphtarget97, bs_face_mouth_o_morphtarget98, bs_face_mouth_a2_morphtarget99, bs_face_mouth_n_morphtarget100, bs_face_mouth_Triangle_morphtarget101, bs_face_mouth_lambda_morphtarget102, bs_face_mouth_Square_morphtarget103, bs_face_mouth_wa_morphtarget104, bs_face_mouth_wa2_morphtarget105, bs_face_mouth_shock_morphtarget106, bs_face_mouth_angry_morphtarget107, bs_face_mouth_smile_morphtarget108, bs_face_mouth_spear_morphtarget109, bs_face_mouth_spear2_morphtarget110, bs_face_mouth_ornerUp_morphtarget111, bs_face_mouth_cornerDown_morphtarget112, bs_face_mouth_cornerSpread_morphtarget113, bs_face_mouth_noTeethUp_morphtarget114, bs_face_mouth_noTeethDown_morphtarget115, bs_face_mouth_Tu_morphtarget116, bs_face_mouth_be_morphtarget117, bs_face_eye_blink_morphtarget118, bs_face_eye_smile_morphtarget, bs_face_eye_winkL_morphtarget, bs_face_eye_winkR_morphtarget, bs_face_eye_winkL2_morphtarget, bs_face_eye_winkR2_morphtarget, bs_face_eye_Calm_morphtarget, bs_face_eye___Shape_morphtarget, bs_face_eye_surprised_morphtarget, bs_face_eye_TT_morphtarget, bs_face_eye_serious_morphtarget, bs_face_eye_none_morphtarget, bs_face_eyebrow_serious_morphtarget, bs_face_eyebrow_trouble_morphtarget, bs_face_eyeblow_smile_morphtarget, bs_face_eyeblow_angry_morphtarget, bs_face_eyeblow_up_morphtarget, bs_face_eyeblow_down_morphtarget, bs_face_eyeblow_gather_morphtarget, bs_face_sface_view_morphtarget, bs_face_sface_right_morphtarget, bs_face_sface_left_morphtarget, bs_face_tongue_morphtarget, bs_face_mouth_mortifying_morphtarget, bs_face_eye_up_morphtarget, bs_face_mouth_a_morphtarget, bs_face_mouth_i_morphtarget, bs_face_mouth_u_morphtarget, bs_face_mouth_e_morphtarget, bs_face_mouth_o_morphtarget, bs_face_mouth_a2_morphtarget, bs_face_mouth_n_morphtarget, bs_face_mouth_Triangle_morphtarget, bs_face_mouth_lambda_morphtarget, bs_face_mouth_Square_morphtarget, bs_face_mouth_wa_morphtarget, bs_face_mouth_wa2_morphtarget, bs_face_mouth_shock_morphtarget, bs_face_mouth_angry_morphtarget, bs_face_mouth_smile_morphtarget, bs_face_mouth_spear_morphtarget, bs_face_mouth_spear2_morphtarget, bs_face_mouth_ornerUp_morphtarget, bs_face_mouth_cornerDown_morphtarget, bs_face_mouth_cornerSpread_morphtarget, bs_face_mouth_noTeethUp_morphtarget, bs_face_mouth_noTeethDown_morphtarget, bs_face_mouth_Tu_morphtarget, bs_face_mouth_be_morphtarget, bs_face_eye_blink_morphtarget, bs_face_eye_smile_morphtarget168, bs_face_eye_winkL_morphtarget169, bs_face_eye_winkR_morphtarget170, bs_face_eye_winkL2_morphtarget171, bs_face_eye_winkR2_morphtarget172, bs_face_eye_Calm_morphtarget173, bs_face_eye___Shape_morphtarget174, bs_face_eye_surprised_morphtarget175, bs_face_eye_TT_morphtarget176, bs_face_eye_serious_morphtarget177, bs_face_eye_none_morphtarget178, bs_face_eyebrow_serious_morphtarget179, bs_face_eyebrow_trouble_morphtarget180, bs_face_eyeblow_smile_morphtarget181, bs_face_eyeblow_angry_morphtarget182, bs_face_eyeblow_up_morphtarget183, bs_face_eyeblow_down_morphtarget184, bs_face_eyeblow_gather_morphtarget185, bs_face_sface_view_morphtarget186, bs_face_sface_right_morphtarget187, bs_face_sface_left_morphtarget188, bs_face_tongue_morphtarget189, bs_face_mouth_mortifying_morphtarget190, bs_face_eye_up_morphtarget191]
            }
            Model {
                id: flonthair
                objectName: "flonthair"
                source: "meshes/flonthair_mesh.mesh"
                skin: skin
                materials: [alicia_hair_material, alicia_hair_trans_zwrite_material, alicia_hair_wear_material, alicia_hair_trans_material]
            }
            Model {
                id: neck201
                objectName: "neck"
                source: "meshes/neck_baked_mesh.mesh"
                skin: skin203
                materials: [alicia_body_wear_material]
            }
            Model {
                id: other
                objectName: "other"
                source: "meshes/other_baked_mesh.mesh"
                skin: skin209
                materials: [alicia_other_zwrite_material]
                morphTargets: [bs_other1_sother_shy_morphtarget, bs_other1_eye___2Shape_morphtarget, bs_other1_eye_h1_morphtarget, bs_other1_eye_h2_morphtarget, bs_other1_eye_h3_morphtarget, bs_other1_oher_shocked_morphtarget, bs_other1_sother_tear_morphtarget]
            }
            Model {
                id: other02
                objectName: "other02"
                source: "meshes/other02_baked_mesh.mesh"
                skin: skin219
                materials: [alicia_other_zwrite_material]
                morphTargets: [bs_other2_other_shy2_morphtarget]
            }
        }
        Node {
            id: root221
            objectName: "Root"
            Node {
                id: hips
                objectName: "Hips"
                position: Qt.vector3d(0, 0.97146, -2.15708e-16)

                Node {
                    id: leftUpLeg
                    objectName: "LeftUpLeg"
                    position: Qt.vector3d(-0.0603868, -0.0854763, -0.000916982)
                    eulerRotation: Qt.vector3d(node.schema.left.hipX, node.schema.left.hipY, node.schema.left.hipZ)
                    Node {
                        id: leftLeg
                        objectName: "LeftLeg"
                        position: Qt.vector3d(0.00672504, -0.363319, -0.00135944)
                        eulerRotation: Qt.vector3d(node.schema.left.legX, node.schema.left.legY, node.schema.left.legZ)

                        Node {
                            id: leftFoot
                            objectName: "LeftFoot"
                            position: Qt.vector3d(0.0125253, -0.419507, 0.0201691)
                            eulerRotation: Qt.vector3d(node.schema.left.footX, node.schema.left.footY, node.schema.left.footZ)

                            Node {
                                id: leftToeBase
                                objectName: "LeftToeBase"
                                position: Qt.vector3d(0.00343401, -0.0830073, -0.0774818)
                                Node {
                                    id: leftToeEnd
                                    objectName: "LeftToeEnd"
                                    position: Qt.vector3d(5.05522e-06, 0.000224054, -0.0199987)
                                }
                            }
                        }
                    }
                }
                Node {
                    id: rightUpLeg
                    objectName: "RightUpLeg"
                    position: Qt.vector3d(0.0603889, -0.0854763, -0.000916982)
                    eulerRotation: Qt.vector3d(node.schema.right.hipX, node.schema.right.hipY, node.schema.right.hipZ)

                    Node {
                        id: rightLeg
                        objectName: "RightLeg"
                        position: Qt.vector3d(-0.00672557, -0.363319, -0.00135966)
                        eulerRotation: Qt.vector3d(node.schema.right.legX, node.schema.right.legY, node.schema.right.legZ)

                        Node {
                            id: rightFoot
                            objectName: "RightFoot"
                            position: Qt.vector3d(-0.0125266, -0.419507, 0.0201689)
                            eulerRotation: Qt.vector3d(node.schema.right.footX, node.schema.right.footY, node.schema.right.footZ)

                            Node {
                                id: rightToeBase
                                objectName: "RightToeBase"
                                position: Qt.vector3d(-0.00343461, -0.0830073, -0.077482)
                                Node {
                                    id: rightToeEnd
                                    objectName: "RightToeEnd"
                                    position: Qt.vector3d(-5.126e-06, 0.000224233, -0.0199987)
                                }
                            }
                        }
                    }
                }
                Node {
                    id: skirt_01_01
                    objectName: "skirt_01_01"
                    position: Qt.vector3d(0, 0.016577, -0.0869725)
                    Node {
                        id: skirt_01_02
                        objectName: "skirt_01_02"
                        position: Qt.vector3d(0, -0.150337, -0.0642206)
                    }
                }
                Node {
                    id: skirt_02_01
                    objectName: "skirt_02_01"
                    position: Qt.vector3d(-0.066668, 0.011595, -0.0718427)
                    Node {
                        id: skirt_02_02
                        objectName: "skirt_02_02"
                        position: Qt.vector3d(-0.0500685, -0.141694, -0.0535512)
                    }
                }
                Node {
                    id: skirt_03_01
                    objectName: "skirt_03_01"
                    position: Qt.vector3d(-0.100217, 0.0139329, -0.0256662)
                    Node {
                        id: skirt_03_02
                        objectName: "skirt_03_02"
                        position: Qt.vector3d(-0.0766224, -0.136801, -0.0120532)
                    }
                }
                Node {
                    id: skirt_04_01
                    objectName: "skirt_04_01"
                    position: Qt.vector3d(-0.0933305, 0.0133851, 0.0236452)
                    Node {
                        id: skirt_04_02
                        objectName: "skirt_04_02"
                        position: Qt.vector3d(-0.0747382, -0.128522, 0.0375105)
                    }
                }
                Node {
                    id: skirt_05_01
                    objectName: "skirt_05_01"
                    position: Qt.vector3d(-0.0537138, 0.0133851, 0.0650195)
                    Node {
                        id: skirt_05_02
                        objectName: "skirt_05_02"
                        position: Qt.vector3d(-0.0445549, -0.128521, 0.0707651)
                    }
                }
                Node {
                    id: skirt_06_01
                    objectName: "skirt_06_01"
                    position: Qt.vector3d(1.02712e-08, 0.00908828, 0.0850501)
                    Node {
                        id: skirt_06_02
                        objectName: "skirt_06_02"
                        position: Qt.vector3d(0, -0.128522, 0.0836231)
                    }
                }
                Node {
                    id: skirt_07_01
                    objectName: "skirt_07_01"
                    position: Qt.vector3d(0.05371, 0.0133852, 0.0650195)
                    Node {
                        id: skirt_07_02
                        objectName: "skirt_07_02"
                        position: Qt.vector3d(0.0445548, -0.128521, 0.0707652)
                    }
                }
                Node {
                    id: skirt_08_01
                    objectName: "skirt_08_01"
                    position: Qt.vector3d(0.09333, 0.0133852, 0.0236452)
                    Node {
                        id: skirt_08_02
                        objectName: "skirt_08_02"
                        position: Qt.vector3d(0.0747382, -0.128521, 0.0375106)
                    }
                }
                Node {
                    id: skirt_09_01
                    objectName: "skirt_09_01"
                    position: Qt.vector3d(0.10022, 0.0139329, -0.0256662)
                    Node {
                        id: skirt_09_02
                        objectName: "skirt_09_02"
                        position: Qt.vector3d(0.0766223, -0.136801, -0.0120533)
                    }
                }
                Node {
                    id: skirt_10_01
                    objectName: "skirt_10_01"
                    position: Qt.vector3d(0.06667, 0.011595, -0.0718427)
                    Node {
                        id: skirt_10_02
                        objectName: "skirt_10_02"
                        position: Qt.vector3d(0.0500686, -0.141694, -0.0535512)
                    }
                }
                Node {
                    id: spine
                    objectName: "Spine"
                    position: Qt.vector3d(0, 0.0127167, -0.01323)
                    Node {
                        id: spine1
                        objectName: "Spine1"
                        position: Qt.vector3d(0, 0.0562785, -0.000640619)
                        Node {
                            id: spine2
                            objectName: "Spine2"
                            position: Qt.vector3d(1.05657e-08, 0.0443156, 0.000987109)
                            Node {
                                id: spine3
                                objectName: "Spine3"
                                position: Qt.vector3d(1.07943e-08, 0.0452747, -0.000346527)
                                Node {
                                    id: leftShoulder
                                    objectName: "LeftShoulder"
                                    position: Qt.vector3d(-0.0164333, 0.137162, 0.0226079)
                                    Node {
                                        id: leftArm
                                        objectName: "LeftArm"
                                        eulerRotation: Qt.vector3d(node.schema.left.armX, node.schema.left.armY, node.schema.left.armZ)
                                        position: Qt.vector3d(-0.0543089, 0.0033102, -1.49012e-08)
                                        Node {
                                            id: leftForeArm
                                            objectName: "LeftForeArm"
                                            position: Qt.vector3d(-0.208952, -0.00568295, -0.000754263)
                                            eulerRotation: Qt.vector3d(node.schema.left.foreArmX, node.schema.left.foreArmY, node.schema.left.foreArmZ)
                                            Node {
                                                id: leftHand
                                                objectName: "LeftHand"
                                                position: Qt.vector3d(-0.217727, -0.000964284, -0.00111227)
                                                eulerRotation: Qt.vector3d(node.schema.left.handX, node.schema.left.handY, node.schema.left.handZ)
                                                Node {
                                                    id: leftFingersBase
                                                    objectName: "LeftFingersBase"
                                                    position: Qt.vector3d(-0.00326687, 0.000125051, -6.51181e-06)
                                                    Node {
                                                        id: leftHandIndex1
                                                        objectName: "LeftHandIndex1"
                                                        position: Qt.vector3d(-0.049154, 0.00401735, -0.015689)
                                                        Node {
                                                            id: leftHandIndex2
                                                            objectName: "LeftHandIndex2"
                                                            position: Qt.vector3d(-0.0268839, -0.00175929, 0.000721149)
                                                            Node {
                                                                id: leftHandIndex3
                                                                objectName: "LeftHandIndex3"
                                                                position: Qt.vector3d(-0.0172802, -0.00113499, 0.000253296)
                                                                Node {
                                                                    id: leftHandIndex4
                                                                    objectName: "LeftHandIndex4"
                                                                    position: Qt.vector3d(-0.00576621, 0.000230908, -4.3679e-06)
                                                                }
                                                            }
                                                        }
                                                    }
                                                    Node {
                                                        id: leftHandMiddle1
                                                        objectName: "LeftHandMiddle1"
                                                        position: Qt.vector3d(-0.0497784, 0.00464177, -0.0019972)
                                                        Node {
                                                            id: leftHandMiddle2
                                                            objectName: "LeftHandMiddle2"
                                                            position: Qt.vector3d(-0.0308005, -0.0018065, 8.82894e-07)
                                                            Node {
                                                                id: leftHandMiddle3
                                                                objectName: "LeftHandMiddle3"
                                                                position: Qt.vector3d(-0.0187964, -0.00111103, -1.33812e-05)
                                                                Node {
                                                                    id: leftHandMiddle4
                                                                    objectName: "LeftHandMiddle4"
                                                                    position: Qt.vector3d(-0.00755483, -5.00679e-06, 7.85775e-05)
                                                                }
                                                            }
                                                        }
                                                    }
                                                    Node {
                                                        id: leftHandPinky1
                                                        objectName: "LeftHandPinky1"
                                                        position: Qt.vector3d(-0.0453164, -0.00129604, 0.0222011)
                                                        Node {
                                                            id: leftHandPinky2
                                                            objectName: "LeftHandPinky2"
                                                            position: Qt.vector3d(-0.0197809, -0.00105917, -0.00108124)
                                                            Node {
                                                                id: leftHandPinky3
                                                                objectName: "LeftHandPinky3"
                                                                position: Qt.vector3d(-0.0134116, -0.000741124, -0.000545554)
                                                                Node {
                                                                    id: leftHandPinky4
                                                                    objectName: "LeftHandPinky4"
                                                                    position: Qt.vector3d(-0.00652742, -9.65595e-06, 4.77582e-06)
                                                                }
                                                            }
                                                        }
                                                    }
                                                    Node {
                                                        id: leftHandRing1
                                                        objectName: "LeftHandRing1"
                                                        position: Qt.vector3d(-0.0494549, 0.00232148, 0.0110525)
                                                        Node {
                                                            id: leftHandRing2
                                                            objectName: "LeftHandRing2"
                                                            position: Qt.vector3d(-0.023789, -0.00122547, -0.000999663)
                                                            Node {
                                                                id: leftHandRing3
                                                                objectName: "LeftHandRing3"
                                                                position: Qt.vector3d(-0.016061, -0.000817299, -0.000504918)
                                                                Node {
                                                                    id: leftHandRing4
                                                                    objectName: "LeftHandRing4"
                                                                    position: Qt.vector3d(-0.00738657, -0.000348091, 0.000539053)
                                                                }
                                                            }
                                                        }
                                                    }
                                                    Node {
                                                        id: leftHandThumb1
                                                        objectName: "LeftHandThumb1"
                                                        position: Qt.vector3d(-0.00675023, -0.0087148, -0.0154916)
                                                        Node {
                                                            id: leftHandThumb2
                                                            objectName: "LeftHandThumb2"
                                                            position: Qt.vector3d(-0.0282387, -0.00738752, -0.0140392)
                                                            Node {
                                                                id: leftHandThumb3
                                                                objectName: "LeftHandThumb3"
                                                                position: Qt.vector3d(-0.0196611, -0.00803018, -0.00170647)
                                                                Node {
                                                                    id: leftHandThumb4
                                                                    objectName: "LeftHandThumb4"
                                                                    position: Qt.vector3d(-0.00429302, -0.000784874, -0.000444137)
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                Node {
                                    id: neck
                                    objectName: "Neck"
                                    position: Qt.vector3d(3.33424e-08, 0.139848, 0.0142797)
                                    Node {
                                        id: neck1
                                        objectName: "Neck1"
                                        position: Qt.vector3d(-9.09364e-09, 0.037998, 0.000143527)
                                        Node {
                                            id: head
                                            objectName: "Head"
                                            position: Qt.vector3d(-9.23521e-09, 0.0388788, -0.000143539)
                                            eulerRotation: Qt.vector3d(node.schema.head.x, node.schema.head.y, node.schema.head.z)
                                            Node {
                                                id: eye_L
                                                objectName: "eye_L"
                                                position: Qt.vector3d(-0.0276442, 0.0464047, -0.0116035)
                                            }
                                            Node {
                                                id: eye_light_L
                                                objectName: "eye_light_L"
                                                position: Qt.vector3d(-0.0276442, 0.0464047, -0.0134034)
                                            }
                                            Node {
                                                id: eye_light_R
                                                objectName: "eye_light_R"
                                                position: Qt.vector3d(0.027645, 0.0464047, -0.0134033)
                                            }
                                            Node {
                                                id: eye_R
                                                objectName: "eye_R"
                                                position: Qt.vector3d(0.027645, 0.0464047, -0.0116034)
                                            }
                                            Node {
                                                id: hair1_L
                                                objectName: "hair1_L"
                                                position: Qt.vector3d(-0.0657244, 0.120692, 0.0806879)
                                                Node {
                                                    id: hair2_L
                                                    objectName: "hair2_L"
                                                    position: Qt.vector3d(-0.00617983, -0.119361, 0.00965089)
                                                    Node {
                                                        id: hair3_L
                                                        objectName: "hair3_L"
                                                        position: Qt.vector3d(-0.0161171, -0.0987285, 0.0175231)
                                                        Node {
                                                            id: hair4_L
                                                            objectName: "hair4_L"
                                                            position: Qt.vector3d(-0.0353304, -0.138895, 0.0251049)
                                                            Node {
                                                                id: hair5_L
                                                                objectName: "hair5_L"
                                                                position: Qt.vector3d(-0.0704605, -0.117904, 0.0480018)
                                                                Node {
                                                                    id: hair6_L
                                                                    objectName: "hair6_L"
                                                                    position: Qt.vector3d(-0.120002, -0.138376, 0.0671004)
                                                                    Node {
                                                                        id: hair7_L
                                                                        objectName: "hair7_L"
                                                                        position: Qt.vector3d(-0.0870507, -0.0946434, 0.0430659)
                                                                        Node {
                                                                            id: hair8_L
                                                                            objectName: "hair8_L"
                                                                            position: Qt.vector3d(-0.0401685, -0.0570792, 0.0142707)
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            Node {
                                                id: hair1_R
                                                objectName: "hair1_R"
                                                position: Qt.vector3d(0.0657199, 0.120692, 0.080688)
                                                Node {
                                                    id: hair2_R
                                                    objectName: "hair2_R"
                                                    position: Qt.vector3d(0.00618789, -0.119365, 0.00965409)
                                                    Node {
                                                        id: hair3_R
                                                        objectName: "hair3_R"
                                                        position: Qt.vector3d(0.0161164, -0.098727, 0.0175223)
                                                        Node {
                                                            id: hair4_R
                                                            objectName: "hair4_R"
                                                            position: Qt.vector3d(0.0353262, -0.138896, 0.0251031)
                                                            Node {
                                                                id: hair5_R
                                                                objectName: "hair5_R"
                                                                position: Qt.vector3d(0.0704603, -0.117904, 0.0480017)
                                                                Node {
                                                                    id: hair6_R
                                                                    objectName: "hair6_R"
                                                                    position: Qt.vector3d(0.118575, -0.136402, 0.0662493)
                                                                    Node {
                                                                        id: hair7_R
                                                                        objectName: "hair7_R"
                                                                        position: Qt.vector3d(0.0870506, -0.0946432, 0.043066)
                                                                        Node {
                                                                            id: hair8_R
                                                                            objectName: "hair8_R"
                                                                            position: Qt.vector3d(0.0401685, -0.0570791, 0.0142708)
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            Node {
                                                id: hair_01_01
                                                objectName: "hair_01_01"
                                                position: Qt.vector3d(-0.000240268, 0.153529, -0.0701631)
                                                Node {
                                                    id: hair_01_02
                                                    objectName: "hair_01_02"
                                                    position: Qt.vector3d(-0.00469713, -0.0465558, -0.0212677)
                                                }
                                            }
                                            Node {
                                                id: hair_02_01
                                                objectName: "hair_02_01"
                                                position: Qt.vector3d(-0.0341103, 0.154783, -0.0651287)
                                                Node {
                                                    id: hair_02_02
                                                    objectName: "hair_02_02"
                                                    position: Qt.vector3d(-0.0175065, -0.0475073, -0.0132053)
                                                }
                                            }
                                            Node {
                                                id: hair_03_01
                                                objectName: "hair_03_01"
                                                position: Qt.vector3d(-0.0601438, 0.154783, -0.0464954)
                                                Node {
                                                    id: hair_03_02
                                                    objectName: "hair_03_02"
                                                    position: Qt.vector3d(-0.0222171, -0.0481353, 0.00023431)
                                                }
                                            }
                                            Node {
                                                id: headEnd
                                                objectName: "HeadEnd"
                                                position: Qt.vector3d(-1.72436e-08, 0.0720376, 0.000143554)
                                            }
                                            Node {
                                                id: mituami1
                                                objectName: "mituami1"
                                                position: Qt.vector3d(0.108901, 0.117512, 0.0700294)
                                                Node {
                                                    id: mituami2
                                                    objectName: "mituami2"
                                                    position: Qt.vector3d(0.0234252, -0.0763646, 0.00538141)
                                                    Node {
                                                        id: mituami3
                                                        objectName: "mituami3"
                                                        position: Qt.vector3d(0.021047, -0.0686116, 0.00483505)
                                                        Node {
                                                            id: mituami4
                                                            objectName: "mituami4"
                                                            position: Qt.vector3d(0.0224194, -0.0730855, 0.00515036)
                                                        }
                                                    }
                                                }
                                            }
                                            Node {
                                                id: mituami_F
                                                objectName: "mituami_F"
                                                position: Qt.vector3d(0.038323, 0.144478, 0.010233)
                                            }
                                            Node {
                                                id: mouth
                                                objectName: "mouth"
                                                position: Qt.vector3d(2.8684e-08, -0.0108947, -0.0547074)
                                                eulerRotation: Qt.vector3d(node.schema.head.mouthX, node.schema.head.mouthY, node.schema.head.mouthZ)

                                                Node {
                                                    id: tongue01
                                                    objectName: "tongue01"
                                                    position: Qt.vector3d(-7.77313e-09, 0.00432611, 0.0141384)
                                                    eulerRotation: Qt.vector3d(node.schema.head.tongueX, node.schema.head.tongueY, node.schema.head.tongueZ)

                                                    Node {
                                                        id: tongue02
                                                        objectName: "tongue02"
                                                        position: Qt.vector3d(6.94187e-09, -0.00350046, -0.012808)
                                                        Node {
                                                            id: tongue03
                                                            objectName: "tongue03"
                                                            position: Qt.vector3d(7.25496e-09, -0.00365818, -0.0133857)
                                                        }
                                                    }
                                                }
                                            }
                                            Node {
                                                id: ribbon_L
                                                objectName: "ribbon_L"
                                                position: Qt.vector3d(-0.00970005, 0.201643, 0.00507299)
                                            }
                                            Node {
                                                id: ribbon_R
                                                objectName: "ribbon_R"
                                                position: Qt.vector3d(0.00969995, 0.201643, 0.00507302)
                                            }
                                        }
                                    }
                                }
                                Node {
                                    id: rightShoulder
                                    objectName: "RightShoulder"
                                    position: Qt.vector3d(0.01643, 0.137162, 0.0226079)
                                    Node {
                                        id: rightArm
                                        objectName: "RightArm"
                                        position: Qt.vector3d(0.0543253, 0.00302815, -7.45058e-08)
                                        eulerRotation: Qt.vector3d(node.schema.right.armX, node.schema.right.armY, node.schema.right.armZ)
                                        Node {
                                            id: rightForeArm
                                            objectName: "RightForeArm"
                                            position: Qt.vector3d(0.208923, -0.00663972, -0.000915665)
                                            eulerRotation: Qt.vector3d(node.schema.right.foreArmX, node.schema.right.foreArmY, node.schema.right.foreArmZ)
                                            Node {
                                                id: rightHand
                                                objectName: "RightHand"
                                                position: Qt.vector3d(0.217725, -0.00103021, -0.0013451)
                                                eulerRotation: Qt.vector3d(node.schema.right.handX, node.schema.right.handY, node.schema.right.handZ)
                                                Node {
                                                    id: rightFingersBase
                                                    objectName: "RightFingersBase"
                                                    position: Qt.vector3d(0.00477925, -5.78165e-05, -9.42945e-05)
                                                    Node {
                                                        id: rightHandIndex1
                                                        objectName: "RightHandIndex1"
                                                        position: Qt.vector3d(0.0476252, 0.00407028, -0.0156893)
                                                        Node {
                                                            id: rightHandIndex2
                                                            objectName: "RightHandIndex2"
                                                            position: Qt.vector3d(0.0268846, -0.00175893, 0.000699902)
                                                            Node {
                                                                id: rightHandIndex3
                                                                objectName: "RightHandIndex3"
                                                                position: Qt.vector3d(0.0172803, -0.00113666, 0.000239689)
                                                                Node {
                                                                    id: rightHandIndex4
                                                                    objectName: "RightHandIndex4"
                                                                    position: Qt.vector3d(0.0128849, -0.0017879, 0.00109018)
                                                                }
                                                            }
                                                        }
                                                    }
                                                    Node {
                                                        id: rightHandMiddle1
                                                        objectName: "RightHandMiddle1"
                                                        position: Qt.vector3d(0.0482649, 0.00479567, -0.00200313)
                                                        Node {
                                                            id: rightHandMiddle2
                                                            objectName: "RightHandMiddle2"
                                                            position: Qt.vector3d(0.0308001, -0.00181389, -2.23182e-05)
                                                            Node {
                                                                id: rightHandMiddle3
                                                                objectName: "RightHandMiddle3"
                                                                position: Qt.vector3d(0.0187961, -0.0011158, -2.74628e-05)
                                                                Node {
                                                                    id: rightHandMiddle4
                                                                    objectName: "RightHandMiddle4"
                                                                    position: Qt.vector3d(0.0112975, -0.000542641, 0.00136922)
                                                                }
                                                            }
                                                        }
                                                    }
                                                    Node {
                                                        id: rightHandPinky1
                                                        objectName: "RightHandPinky1"
                                                        position: Qt.vector3d(0.0438281, -0.000961661, 0.0222433)
                                                        Node {
                                                            id: rightHandPinky2
                                                            objectName: "RightHandPinky2"
                                                            position: Qt.vector3d(0.0197797, -0.00107014, -0.00109232)
                                                            Node {
                                                                id: rightHandPinky3
                                                                objectName: "RightHandPinky3"
                                                                position: Qt.vector3d(0.0134109, -0.000747323, -0.000552915)
                                                                Node {
                                                                    id: rightHandPinky4
                                                                    objectName: "RightHandPinky4"
                                                                    position: Qt.vector3d(0.00803405, -0.000533819, 0.00179672)
                                                                }
                                                            }
                                                        }
                                                    }
                                                    Node {
                                                        id: rightHandRing1
                                                        objectName: "RightHandRing1"
                                                        position: Qt.vector3d(0.0479554, 0.00257218, 0.0110637)
                                                        Node {
                                                            id: rightHandRing2
                                                            objectName: "RightHandRing2"
                                                            position: Qt.vector3d(0.0237877, -0.00123847, -0.00101492)
                                                            Node {
                                                                id: rightHandRing3
                                                                objectName: "RightHandRing3"
                                                                position: Qt.vector3d(0.0160604, -0.000824809, -0.00051529)
                                                                Node {
                                                                    id: rightHandRing4
                                                                    objectName: "RightHandRing4"
                                                                    position: Qt.vector3d(0.0113804, -0.00041151, 0.00163722)
                                                                }
                                                            }
                                                        }
                                                    }
                                                    Node {
                                                        id: rightHandThumb1
                                                        objectName: "RightHandThumb1"
                                                        position: Qt.vector3d(0.00521857, -0.00864899, -0.0153509)
                                                        Node {
                                                            id: rightHandThumb2
                                                            objectName: "RightHandThumb2"
                                                            position: Qt.vector3d(0.0282151, -0.00748122, -0.0140372)
                                                            Node {
                                                                id: rightHandThumb3
                                                                objectName: "RightHandThumb3"
                                                                position: Qt.vector3d(0.0196648, -0.00802302, -0.00169607)
                                                                Node {
                                                                    id: rightHandThumb4
                                                                    objectName: "RightHandThumb4"
                                                                    position: Qt.vector3d(0.00672758, -0.00262368, 0.000999078)
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                Node {
                                    id: tit_L
                                    objectName: "tit_L"
                                    position: Qt.vector3d(-0.032, 0.0658576, 0.00751654)
                                }
                                Node {
                                    id: tit_R
                                    objectName: "tit_R"
                                    position: Qt.vector3d(0.032, 0.0658575, 0.00751663)
                                }
                            }
                        }
                    }
                }
            }
        }
        Node {
            id: secondary
            objectName: "secondary"
        }
    }

    // Animations:
}
