import QtQuick
import QtQuick3D

Node {
    id: node

    // Resources
    property url textureData: "maps/textureData.png"
    property url textureData658: "maps/textureData658.png"
    property url textureData221: "maps/textureData221.png"
    property url textureData643: "maps/textureData643.png"
    property url textureData224: "maps/textureData224.png"
    property url textureData218: "maps/textureData218.png"
    property url textureData640: "maps/textureData640.png"
    property url textureData660: "maps/textureData660.png"
    property url textureData215: "maps/textureData215.png"
    property url textureData645: "maps/textureData645.png"
    property url textureData213: "maps/textureData213.png"
    property url textureData637: "maps/textureData637.png"
    property url textureData634: "maps/textureData634.png"
    property url textureData662: "maps/textureData662.png"
    property url textureData207: "maps/textureData207.png"
    property url textureData648: "maps/textureData648.png"
    property url textureData631: "maps/textureData631.png"
    property url textureData204: "maps/textureData204.png"
    property url textureData202: "maps/textureData202.png"
    property url textureData629: "maps/textureData629.png"
    property url textureData200: "maps/textureData200.png"
    property url textureData651: "maps/textureData651.png"
    Texture {
        id: _14_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: node.textureData640
    }
    Texture {
        id: _17_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: node.textureData648
    }
    Texture {
        id: _18_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: node.textureData651
    }
    Texture {
        id: _16_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: node.textureData645
    }
    Texture {
        id: _15_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: node.textureData643
    }
    Texture {
        id: _0_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: node.textureData200
    }
    Texture {
        id: _13_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: node.textureData637
    }
    Texture {
        id: _12_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: node.textureData634
    }
    Texture {
        id: _11_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: node.textureData631
    }
    Texture {
        id: _10_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: node.textureData629
    }
    Texture {
        id: _8_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: node.textureData221
    }
    Texture {
        id: _4_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: node.textureData
    }
    Texture {
        id: _21_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: node.textureData662
    }
    Texture {
        id: _5_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: node.textureData213
    }
    Texture {
        id: _3_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: node.textureData207
    }
    Texture {
        id: _6_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: node.textureData215
    }
    Texture {
        id: _7_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: node.textureData218
    }
    Texture {
        id: _20_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: node.textureData660
    }
    Texture {
        id: _9_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: node.textureData224
    }
    Texture {
        id: _19_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: node.textureData658
    }
    Texture {
        id: _2_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: node.textureData204
    }
    Texture {
        id: _1_texture
        generateMipmaps: true
        mipFilter: Texture.Linear
        source: node.textureData202
    }
    MorphTarget {
        id: fcl_HA_Fung1_Up_morphtarget
        objectName: "Fcl_HA_Fung1_Up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung2_Up_morphtarget
        objectName: "Fcl_HA_Fung2_Up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung2_Low_morphtarget
        objectName: "Fcl_HA_Fung2_Low"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung2_morphtarget
        objectName: "Fcl_HA_Fung2"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Angry_morphtarget
        objectName: "Fcl_ALL_Angry"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung3_morphtarget
        objectName: "Fcl_HA_Fung3"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung3_Up_morphtarget
        objectName: "Fcl_HA_Fung3_Up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung3_Low_morphtarget
        objectName: "Fcl_HA_Fung3_Low"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Short_morphtarget
        objectName: "Fcl_HA_Short"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Short_Up_morphtarget
        objectName: "Fcl_HA_Short_Up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Short_Low_morphtarget
        objectName: "Fcl_HA_Short_Low"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Neutral_morphtarget
        objectName: "Fcl_ALL_Neutral"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_BRW_Joy_morphtarget
        objectName: "Fcl_BRW_Joy"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung1_Low_morphtarget
        objectName: "Fcl_HA_Fung1_Low"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung1_morphtarget
        objectName: "Fcl_HA_Fung1"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Hide_morphtarget
        objectName: "Fcl_HA_Hide"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_O_morphtarget
        objectName: "Fcl_MTH_O"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_E_morphtarget
        objectName: "Fcl_MTH_E"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_U_morphtarget
        objectName: "Fcl_MTH_U"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_I_morphtarget
        objectName: "Fcl_MTH_I"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_A_morphtarget
        objectName: "Fcl_MTH_A"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_SkinFung_L_morphtarget
        objectName: "Fcl_MTH_SkinFung_L"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_SkinFung_R_morphtarget
        objectName: "Fcl_MTH_SkinFung_R"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_SkinFung_morphtarget
        objectName: "Fcl_MTH_SkinFung"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Surprised_morphtarget
        objectName: "Fcl_MTH_Surprised"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Close_R_morphtarget
        objectName: "Fcl_EYE_Close_R"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Iris_Hide_morphtarget
        objectName: "Fcl_EYE_Iris_Hide"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Surprised_morphtarget
        objectName: "Fcl_EYE_Surprised"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Highlight_Hide_morphtarget
        objectName: "Fcl_EYE_Highlight_Hide"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Close_morphtarget
        objectName: "Fcl_MTH_Close"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Sorrow_morphtarget
        objectName: "Fcl_EYE_Sorrow"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Joy_L_morphtarget
        objectName: "Fcl_EYE_Joy_L"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Joy_R_morphtarget
        objectName: "Fcl_EYE_Joy_R"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Joy_morphtarget
        objectName: "Fcl_EYE_Joy"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Fun_morphtarget
        objectName: "Fcl_EYE_Fun"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_O_morphtarget441
        objectName: "Fcl_MTH_O"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Up_morphtarget
        objectName: "Fcl_MTH_Up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Close_L_morphtarget
        objectName: "Fcl_EYE_Close_L"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Fun_morphtarget
        objectName: "Fcl_ALL_Fun"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Close_morphtarget
        objectName: "Fcl_EYE_Close"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Angry_morphtarget
        objectName: "Fcl_EYE_Angry"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Natural_morphtarget
        objectName: "Fcl_EYE_Natural"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_BRW_Surprised_morphtarget
        objectName: "Fcl_BRW_Surprised"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_BRW_Sorrow_morphtarget
        objectName: "Fcl_BRW_Sorrow"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Spread_morphtarget
        objectName: "Fcl_EYE_Spread"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_BRW_Fun_morphtarget
        objectName: "Fcl_BRW_Fun"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_BRW_Angry_morphtarget
        objectName: "Fcl_BRW_Angry"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Surprised_morphtarget
        objectName: "Fcl_ALL_Surprised"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Sorrow_morphtarget
        objectName: "Fcl_ALL_Sorrow"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Joy_morphtarget
        objectName: "Fcl_ALL_Joy"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Short_morphtarget452
        objectName: "Fcl_HA_Short"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_BRW_Sorrow_morphtarget464
        objectName: "Fcl_BRW_Sorrow"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_BRW_Joy_morphtarget463
        objectName: "Fcl_BRW_Joy"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_BRW_Fun_morphtarget462
        objectName: "Fcl_BRW_Fun"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_BRW_Angry_morphtarget461
        objectName: "Fcl_BRW_Angry"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Surprised_morphtarget460
        objectName: "Fcl_ALL_Surprised"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Sorrow_morphtarget459
        objectName: "Fcl_ALL_Sorrow"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Joy_morphtarget458
        objectName: "Fcl_ALL_Joy"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Fun_morphtarget457
        objectName: "Fcl_ALL_Fun"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Angry_morphtarget456
        objectName: "Fcl_ALL_Angry"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Neutral_morphtarget455
        objectName: "Fcl_ALL_Neutral"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Short_Low_morphtarget454
        objectName: "Fcl_HA_Short_Low"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Short_Up_morphtarget453
        objectName: "Fcl_HA_Short_Up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_BRW_Surprised_morphtarget465
        objectName: "Fcl_BRW_Surprised"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung3_Low_morphtarget451
        objectName: "Fcl_HA_Fung3_Low"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung3_Up_morphtarget450
        objectName: "Fcl_HA_Fung3_Up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung3_morphtarget449
        objectName: "Fcl_HA_Fung3"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung2_Up_morphtarget448
        objectName: "Fcl_HA_Fung2_Up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung2_Low_morphtarget447
        objectName: "Fcl_HA_Fung2_Low"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung2_morphtarget446
        objectName: "Fcl_HA_Fung2"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung1_Up_morphtarget445
        objectName: "Fcl_HA_Fung1_Up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung1_Low_morphtarget444
        objectName: "Fcl_HA_Fung1_Low"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung1_morphtarget443
        objectName: "Fcl_HA_Fung1"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Hide_morphtarget442
        objectName: "Fcl_HA_Hide"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    Skin {
        id: skin
        joints: [root, j_Bip_C_Hips, j_Bip_C_Spine, j_Bip_C_Chest, j_Bip_C_UpperChest, j_Sec_L_Bust1, j_Sec_L_Bust2, j_Sec_R_Bust1, j_Sec_R_Bust2, j_Bip_C_Neck, j_Bip_C_Head, j_Adj_L_FaceEye, j_Adj_R_FaceEye, j_Sec_Hair1_01, j_Sec_Hair2_01, j_Sec_Hair1_02, j_Sec_Hair2_02, j_Sec_Hair1_03, j_Sec_Hair2_03, j_Sec_Hair3_03, j_Sec_Hair1_04, j_Sec_Hair2_04, j_Sec_Hair3_04, j_Sec_Hair1_05, j_Sec_Hair2_05, j_Sec_Hair3_05, j_Sec_Hair1_06, j_Sec_Hair2_06, j_Sec_Hair3_06, j_Sec_Hair1_07, j_Sec_Hair2_07, j_Sec_Hair3_07, j_Sec_Hair1_08, j_Sec_Hair2_08, j_Sec_Hair3_08, j_Sec_Hair1_09, j_Sec_Hair2_09, j_Sec_Hair3_09, j_Sec_Hair1_10, j_Sec_Hair2_10, j_Sec_Hair3_10, j_Sec_Hair1_11, j_Sec_Hair2_11, j_Sec_Hair3_11, j_Sec_Hair1_12, j_Sec_Hair2_12, j_Sec_Hair3_12, j_Sec_Hair1_13, j_Sec_Hair2_13, j_Sec_Hair3_13, j_Sec_Hair1_14, j_Sec_Hair2_14, j_Sec_Hair3_14, j_Sec_Hair1_15, j_Sec_Hair2_15, j_Sec_Hair3_15, j_Sec_Hair1_16, j_Sec_Hair2_16, j_Sec_Hair3_16, j_Sec_Hair1_17, j_Sec_Hair2_17, j_Sec_Hair3_17, j_Sec_Hair1_18, j_Sec_Hair2_18, j_Sec_Hair3_18, j_Sec_Hair1_19, j_Sec_Hair2_19, j_Sec_Hair1_20, j_Sec_Hair2_20, j_Bip_L_Shoulder, j_Bip_L_UpperArm, j_Bip_L_LowerArm, j_Bip_L_Hand, j_Bip_L_Index1, j_Bip_L_Index2, j_Bip_L_Index3, j_Bip_L_Little1, j_Bip_L_Little2, j_Bip_L_Little3, j_Bip_L_Middle1, j_Bip_L_Middle2, j_Bip_L_Middle3, j_Bip_L_Ring1, j_Bip_L_Ring2, j_Bip_L_Ring3, j_Bip_L_Thumb1, j_Bip_L_Thumb2, j_Bip_L_Thumb3, j_Bip_R_Shoulder, j_Bip_R_UpperArm, j_Bip_R_LowerArm, j_Bip_R_Hand, j_Bip_R_Index1, j_Bip_R_Index2, j_Bip_R_Index3, j_Bip_R_Little1, j_Bip_R_Little2, j_Bip_R_Little3, j_Bip_R_Middle1, j_Bip_R_Middle2, j_Bip_R_Middle3, j_Bip_R_Ring1, j_Bip_R_Ring2, j_Bip_R_Ring3, j_Bip_R_Thumb1, j_Bip_R_Thumb2, j_Bip_R_Thumb3, j_Bip_L_UpperLeg, j_Bip_L_LowerLeg, j_Sec_L_CoatSkirtBack_01, j_Sec_L_CoatSkirtBack_end_01, j_Sec_L_CoatSkirtFront_01, j_Sec_L_CoatSkirtFront_end_01, j_Sec_L_CoatSkirtSide1_01, j_Sec_L_CoatSkirtSide2_01, j_Sec_L_CoatSkirtSide2_end_01, j_Sec_L_CoatSkirtBack_02, j_Sec_L_CoatSkirtBack_end_02, j_Sec_L_CoatSkirtFront_02, j_Sec_L_CoatSkirtFront_end_02, j_Sec_L_CoatSkirtSide1_02, j_Sec_L_CoatSkirtSide2_02, j_Sec_L_CoatSkirtSide2_end_02, j_Sec_L_CoatSkirtBack_03, j_Sec_L_CoatSkirtBack_end_03, j_Sec_L_CoatSkirtFront_03, j_Sec_L_CoatSkirtFront_end_03, j_Sec_L_CoatSkirtSide1_03, j_Sec_L_CoatSkirtSide2_03, j_Sec_L_CoatSkirtSide2_end_03, j_Bip_L_Foot, j_Bip_L_ToeBase, j_Bip_R_UpperLeg, j_Bip_R_LowerLeg, j_Sec_R_CoatSkirtBack_01, j_Sec_R_CoatSkirtBack_end_01, j_Sec_R_CoatSkirtFront_01, j_Sec_R_CoatSkirtFront_end_01, j_Sec_R_CoatSkirtSide1_01, j_Sec_R_CoatSkirtSide2_01, j_Sec_R_CoatSkirtSide2_end_01, j_Sec_R_CoatSkirtBack_02, j_Sec_R_CoatSkirtBack_end_02, j_Sec_R_CoatSkirtFront_02, j_Sec_R_CoatSkirtFront_end_02, j_Sec_R_CoatSkirtSide1_02, j_Sec_R_CoatSkirtSide2_02, j_Sec_R_CoatSkirtSide2_end_02, j_Sec_R_CoatSkirtBack_03, j_Sec_R_CoatSkirtBack_end_03, j_Sec_R_CoatSkirtFront_03, j_Sec_R_CoatSkirtFront_end_03, j_Sec_R_CoatSkirtSide1_03, j_Sec_R_CoatSkirtSide2_03, j_Sec_R_CoatSkirtSide2_end_03, j_Bip_R_Foot, j_Bip_R_ToeBase]
        inverseBindPoses: [
            // 0-68 preserved from source
            Qt.matrix4x4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0, 0, 0.992088, 0.125548, -1.15843, 0, -0.125548, 0.992088, 0.142986, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 7.11265e-32, 0, 0.98855, 0.150896, -1.21633, 0, -0.150896, 0.98855, 0.167343, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -2.40917e-17, 0, 0.992589, -0.121518, -1.34611, 0, 0.121518, 0.992589, -0.186612, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 1.06822e-17, 0, 0.943357, -0.33178, -1.39816, 0, 0.33178, 0.943357, -0.496668, 0, 0, 0, 1), Qt.matrix4x4(0.890608, -0.047434, -0.45229, 0.0537904, -0.00726396, 0.992935, -0.118438, -1.45443, 0.454713, 0.108767, 0.883972, -0.263178, 0, 0, 0, 1), Qt.matrix4x4(0.890608, -0.047434, -0.45229, 0.0538004, -0.00726397, 0.992935, -0.118438, -1.45443, 0.454713, 0.108767, 0.883972, -0.264455, 0, 0, 0, 1), Qt.matrix4x4(0.890608, 0.047434, 0.45229, -0.0537904, 0.00726396, 0.992935, -0.118438, -1.45443, -0.454713, 0.108767, 0.883972, -0.263178, 0, 0, 0, 1), Qt.matrix4x4(0.890608, 0.047434, 0.45229, -0.0538004, 0.00726397, 0.992935, -0.118438, -1.45443, -0.454713, 0.108767, 0.883972, -0.264455, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 1.19815e-16, 0, 0.992864, 0.119252, -1.62085, 0, -0.119252, 0.992864, 0.234831, 0, 0, 0, 1), Qt.matrix4x4(1, 5.25951e-08, -4.37914e-07, -1.03702e-07, -4.78589e-08, 0.999942, 0.0108084, -1.73272, 4.38457e-07, -0.0108084, 0.999942, 0.0471112, 0, 0, 0, 1), Qt.matrix4x4(0.930442, -0.000646281, -0.366439, -0.01619, 0.0198007, 0.998626, 0.0485156, -1.79385, 0.365904, -0.0523967, 0.929176, 0.0938457, 0, 0, 0, 1), Qt.matrix4x4(0.930442, 0.000646404, 0.366438, 0.0161898, -0.0198008, 0.998626, 0.0485155, -1.79385, -0.365903, -0.0523967, 0.929177, 0.0938458, 0, 0, 0, 1), Qt.matrix4x4(-0.401627, 0.844586, -0.354076, -1.60455, -0.915804, -0.370394, 0.155281, 0.580047, 4.61936e-07, 0.386629, 0.922235, -0.692951, 0, 0, 0, 1), Qt.matrix4x4(-0.401627, 0.844586, -0.354076, -1.6044, -0.915803, -0.370394, 0.155281, 0.529659, 4.32134e-07, 0.386629, 0.922235, -0.692952, 0, 0, 0, 1), Qt.matrix4x4(-0.600142, -0.781958, 0.168435, 1.51148, 0.799893, -0.586686, 0.126372, 0.994297, 4.02331e-07, 0.210571, 0.977578, -0.369484, 0, 0, 0, 1), Qt.matrix4x4(-0.600143, -0.781958, 0.168435, 1.51134, 0.799893, -0.586686, 0.126373, 0.956455, 4.02331e-07, 0.210571, 0.977578, -0.369484, 0, 0, 0, 1), Qt.matrix4x4(-0.985997, -0.165302, 0.0220353, 0.21142, 0.166764, -0.977352, 0.130281, 1.77766, 5.48549e-07, 0.132131, 0.991232, -0.272557, 0, 0, 0, 1), Qt.matrix4x4(-0.854811, -0.419369, 0.305662, 0.662282, 0.51894, -0.690794, 0.503493, 1.24962, 8.9407e-08, 0.589011, 0.808125, -1.07652, 0, 0, 0, 1), Qt.matrix4x4(-0.854811, -0.419368, 0.305661, 0.662165, 0.51894, -0.690794, 0.503493, 1.21591, 2.5332e-07, 0.589011, 0.808125, -1.07652, 0, 0, 0, 1), Qt.matrix4x4(-0.993274, 0.115088, -0.0127168, -0.12231, -0.115789, -0.987266, 0.10909, 1.80366, 8.5216e-08, 0.109829, 0.99395, -0.229557, 0, 0, 0, 1), Qt.matrix4x4(-0.811412, 0.488784, -0.32047, -0.794653, -0.584475, -0.678567, 0.444901, 1.24595, 1.49012e-07, 0.548305, 0.836278, -1.00751, 0, 0, 0, 1), Qt.matrix4x4(-0.811412, 0.488784, -0.32047, -0.794526, -0.584475, -0.678567, 0.444901, 1.21206, 1.49012e-07, 0.548305, 0.836278, -1.00751, 0, 0, 0, 1), Qt.matrix4x4(-0.999998, -0.00250177, 0.000233629, 0.00708628, 0.00251265, -0.995682, 0.0928101, 1.85633, 4.30606e-07, 0.0928105, 0.995684, -0.255647, 0, 0, 0, 1), Qt.matrix4x4(-0.999817, 0.0187861, 0.00343314, -0.032183, -0.0190973, -0.983532, -0.179718, 1.81701, 4.0303e-07, -0.17975, 0.983712, 0.244623, 0, 0, 0, 1), Qt.matrix4x4(-0.999817, 0.0187861, 0.00343314, -0.0321769, -0.0190973, -0.983532, -0.179718, 1.77637, 4.03263e-07, -0.17975, 0.983712, 0.244623, 0, 0, 0, 1), Qt.matrix4x4(-0.990447, 0.13789, 0.000864603, -0.300622, -0.137893, -0.990428, -0.00620702, 1.84141, 4.40748e-07, -0.00626695, 0.99998, -0.0678957, 0, 0, 0, 1), Qt.matrix4x4(-0.994168, -0.106954, -0.0138453, 0.149302, 0.107847, -0.985941, -0.127632, 1.82296, 1.6205e-07, -0.128381, 0.991725, 0.156645, 0, 0, 0, 1), Qt.matrix4x4(-0.994168, -0.106954, -0.0138453, 0.149275, 0.107847, -0.985941, -0.127632, 1.79145, 1.62516e-07, -0.128381, 0.991725, 0.156645, 0, 0, 0, 1), Qt.matrix4x4(-0.999996, -0.00305625, 6.97165e-05, 0.0850229, 0.00305705, -0.999739, 0.0226584, 1.8449, 4.48639e-07, 0.0226585, 0.999743, -0.0889094, 0, 0, 0, 1), Qt.matrix4x4(-0.921469, 0.386318, -0.0406877, -0.624666, -0.388454, -0.9164, 0.0965178, 1.68642, 3.74392e-07, 0.104743, 0.994499, -0.237365, 0, 0, 0, 1), Qt.matrix4x4(-0.921469, 0.386317, -0.0406876, -0.624568, -0.388454, -0.9164, 0.0965178, 1.6516, 3.76254e-07, 0.104743, 0.994499, -0.237365, 0, 0, 0, 1), Qt.matrix4x4(-0.990972, -0.133957, 0.00545571, 0.29241, 0.134068, -0.990151, 0.0403232, 1.8392, 3.87197e-07, 0.0406906, 0.999172, -0.149201, 0, 0, 0, 1), Qt.matrix4x4(-0.991699, 0.128251, 0.00925774, -0.188578, -0.128584, -0.989125, -0.0713963, 1.82481, 4.45172e-07, -0.071994, 0.997405, 0.0575144, 0, 0, 0, 1), Qt.matrix4x4(-0.991699, 0.128251, 0.00925774, -0.188545, -0.128584, -0.989125, -0.0713963, 1.79152, 4.45172e-07, -0.071994, 0.997405, 0.0575144, 0, 0, 0, 1), Qt.matrix4x4(-0.999997, -0.00242874, -2.68141e-05, -0.0760716, 0.00242889, -0.999935, -0.0111994, 1.83976, 3.88042e-07, -0.0111994, 0.999937, -0.0265954, 0, 0, 0, 1), Qt.matrix4x4(-0.896194, -0.440791, 0.0504198, 0.721681, 0.443665, -0.890388, 0.101846, 1.63914, 4.26546e-07, 0.113643, 0.993522, -0.251784, 0, 0, 0, 1), Qt.matrix4x4(-0.896193, -0.440791, 0.0504198, 0.721579, 0.443665, -0.890387, 0.101846, 1.60636, 4.22821e-07, 0.113643, 0.993522, -0.251784, 0, 0, 0, 1), Qt.matrix4x4(-0.748844, -0.599564, -0.282411, 1.19253, 0.662747, -0.677453, -0.3191, 1.25373, 4.47035e-07, -0.426123, 0.904665, 0.726603, 0, 0, 0, 1), Qt.matrix4x4(-0.756544, -0.239371, -0.608558, 0.549724, 0.653943, -0.276927, -0.704038, 0.499891, 3.27826e-07, -0.930598, 0.366042, 1.69381, 0, 0, 0, 1), Qt.matrix4x4(-0.756544, -0.239371, -0.608558, 0.549563, 0.653943, -0.276927, -0.704038, 0.458547, 2.38419e-07, -0.930598, 0.366042, 1.69381, 0, 0, 0, 1), Qt.matrix4x4(-0.40515, 0.733052, 0.546341, -1.43852, -0.914251, -0.324853, -0.24211, 0.609798, 1.2219e-06, -0.597584, 0.801806, 1.04589, 0, 0, 0, 1), Qt.matrix4x4(0.616, 0.143257, -0.774611, -0.164211, -0.787746, 0.112024, -0.605728, -0.203603, 2.08616e-07, 0.983325, 0.181857, -1.84998, 0, 0, 0, 1), Qt.matrix4x4(0.616, 0.143257, -0.774611, -0.164354, -0.787746, 0.112024, -0.605728, -0.240941, -1.78814e-07, 0.983325, 0.181857, -1.84998, 0, 0, 0, 1), Qt.matrix4x4(-0.898292, -0.436803, 0.0476737, 0.711516, 0.439397, -0.892989, 0.0974619, 1.5937, 3.96743e-07, 0.108497, 0.994097, -0.122928, 0, 0, 0, 1), Qt.matrix4x4(-0.937259, 0.31662, 0.145933, -0.572381, -0.348633, -0.851197, -0.392324, 1.41582, 5.1409e-07, -0.418586, 0.908177, 0.772925, 0, 0, 0, 1), Qt.matrix4x4(-0.937259, 0.31662, 0.145933, -0.572282, -0.348633, -0.851198, -0.392324, 1.3771, 4.84288e-07, -0.418586, 0.908177, 0.772925, 0, 0, 0, 1), Qt.matrix4x4(-1, 0.00150124, -0.000601497, 0.00402469, -0.00161725, -0.928177, 0.372138, 1.64728, 3.71307e-07, 0.372139, 0.928177, -0.557532, 0, 0, 0, 1), Qt.matrix4x4(-0.976987, 0.206422, 0.0537201, -0.341307, -0.213298, -0.945494, -0.246057, 1.59443, 4.26546e-07, -0.251852, 0.967766, 0.510678, 0, 0, 0, 1), Qt.matrix4x4(-0.976987, 0.206422, 0.0537201, -0.341254, -0.213298, -0.945494, -0.246057, 1.56255, 4.26546e-07, -0.251852, 0.967766, 0.510678, 0, 0, 0, 1), Qt.matrix4x4(-0.932631, 0.355517, -0.0617019, -0.569219, -0.360831, -0.918895, 0.15948, 1.63296, 3.94881e-07, 0.171, 0.985271, -0.232109, 0, 0, 0, 1), Qt.matrix4x4(-0.959165, -0.247255, -0.137366, 0.456985, 0.282851, -0.838456, -0.465819, 1.39102, 7.00355e-07, -0.485651, 0.874153, 0.882674, 0, 0, 0, 1), Qt.matrix4x4(-0.959164, -0.247256, -0.137366, 0.456908, 0.282851, -0.838456, -0.465819, 1.35463, 8.71718e-07, -0.485652, 0.874153, 0.882674, 0, 0, 0, 1), Qt.matrix4x4(-0.979643, -0.20021, -0.0146787, 0.473582, 0.200747, -0.977021, -0.0716341, 1.78643, 4.10248e-07, -0.0731226, 0.997323, 0.139852, 0, 0, 0, 1), Qt.matrix4x4(-0.809424, -0.580181, 0.0906799, 1.1431, 0.587225, -0.799715, 0.124991, 1.38256, 4.76837e-07, 0.15442, 0.988005, -0.272276, 0, 0, 0, 1), Qt.matrix4x4(-0.809424, -0.580181, 0.0906799, 1.14295, 0.587225, -0.799715, 0.124991, 1.34292, 4.5076e-07, 0.154421, 0.988005, -0.272276, 0, 0, 0, 1), Qt.matrix4x4(-0.89311, 0.429009, 0.135301, -0.882946, -0.449839, -0.851754, -0.268626, 1.51623, 5.58794e-07, -0.300776, 0.953695, 0.555618, 0, 0, 0, 1), Qt.matrix4x4(-0.745505, 0.449543, 0.49207, -0.898775, -0.6665, -0.502831, -0.550398, 0.826918, 6.10948e-07, -0.73829, 0.674484, 1.34619, 0, 0, 0, 1), Qt.matrix4x4(-0.745505, 0.449543, 0.49207, -0.898666, -0.6665, -0.502831, -0.550398, 0.799134, 6.10948e-07, -0.73829, 0.674484, 1.34619, 0, 0, 0, 1), Qt.matrix4x4(-0.957716, -0.279747, 0.0672574, 0.428719, 0.287719, -0.931181, 0.223875, 1.65339, 4.76837e-07, 0.23376, 0.972294, -0.370377, 0, 0, 0, 1), Qt.matrix4x4(-0.932306, 0.281236, -0.227407, -0.547086, -0.361673, -0.724958, 0.5862, 1.24866, 8.9407e-08, 0.628764, 0.777597, -1.05805, 0, 0, 0, 1), Qt.matrix4x4(-0.932306, 0.281237, -0.227407, -0.547027, -0.361674, -0.724958, 0.586199, 1.22619, 3.35276e-07, 0.628764, 0.777597, -1.05805, 0, 0, 0, 1), Qt.matrix4x4(-0.974261, 0.207329, -0.0884997, -0.302234, -0.225427, -0.896042, 0.382483, 1.59098, 3.7998e-07, 0.392589, 0.919714, -0.653434, 0, 0, 0, 1), Qt.matrix4x4(-0.964282, -0.149166, 0.218886, 0.318595, 0.26488, -0.543029, 0.796842, 0.939066, 1.49012e-08, 0.826359, 0.563144, -1.40907, 0, 0, 0, 1), Qt.matrix4x4(-0.964282, -0.149166, 0.218886, 0.318544, 0.26488, -0.543029, 0.796842, 0.91385, -2.23517e-08, 0.826359, 0.563144, -1.40907, 0, 0, 0, 1), Qt.matrix4x4(-0.809935, -0.208669, 0.548145, 0.422721, 0.58652, -0.288154, 0.756943, 0.567989, -5.0664e-07, 0.934572, 0.355774, -1.83579, 0, 0, 0, 1), Qt.matrix4x4(-0.809935, -0.208669, 0.548145, 0.422479, 0.58652, -0.288154, 0.756943, 0.502968, -5.06639e-07, 0.934572, 0.355774, -1.83579, 0, 0, 0, 1), Qt.matrix4x4(-0.419282, 0.716482, -0.557544, -1.41669, -0.907856, -0.330898, 0.257496, 0.65247, 6.55651e-07, 0.614133, 0.789202, -1.19947, 0, 0, 0, 1), Qt.matrix4x4(-0.419283, 0.716482, -0.557544, -1.41654, -0.907855, -0.330899, 0.257496, 0.601311, 3.27826e-07, 0.614133, 0.789202, -1.19947, 0, 0, 0, 1),

            // [69] j_Bip_L_Shoulder (Corrected inverseBindPose)
            Qt.matrix4x4(0.9649, -0.2541, -0.0658, -0.0249, 0.2541, 0.9672, 0, -0.1273, 0.0658, -0.0167, 0.9977, -0.0079, 0, 0, 0, 1),

            // 70-87 preserved from source
            Qt.matrix4x4(0.990027, -0.140878, 3.88206e-09, 0.201676, 0.140878, 0.990027, 3.77144e-08, -1.59389, -9.15645e-09, -3.67914e-08, 1, 0.0301292, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.134485, 0, 1, 0, -1.59012, 0, 0, 1, 0.0301292, 0, 0, 0, 1), Qt.matrix4x4(0.999999, 2.70291e-08, 0.00169146, -0.367231, -2.71817e-08, 1, 9.02343e-08, -1.59012, -0.00169146, -9.02802e-08, 0.999999, 0.0307704, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.618621, 0, 1, 0, -1.59012, 0, 0, 1, 0.0296694, 0, 0, 0, 1), Qt.matrix4x4(0.999811, -1.77738e-09, -0.0194199, -0.69138, 2.64541e-09, 1, 4.4672e-08, -1.59869, 0.0194199, -4.4715e-08, 0.999811, -0.00657868, 0, 0, 0, 1), Qt.matrix4x4(0.998841, -0.0288736, -0.0385161, -0.681619, 0.0288734, 0.999583, -0.000560868, -1.61905, 0.0385163, -0.000551876, 0.999258, -0.019576, 0, 0, 0, 1), Qt.matrix4x4(0.99884, -0.0347321, -0.0333433, -0.694973, 0.0347257, 0.999397, -0.000771367, -1.62312, 0.0333499, -0.000387397, 0.999444, -0.0159173, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.686508, 0, 1, 0, -1.59869, 0, 0, 1, 0.0635363, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.721444, 0, 1, 0, -1.59869, 0, 0, 1, 0.0635363, 0, 0, 0, 1), Qt.matrix4x4(0.999695, 0.0155363, 0.0192181, -0.764968, -0.0155363, 0.999879, -0.000149271, -1.58698, -0.0192181, -0.000149353, 0.999815, 0.0780145, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.692368, 0, 1, 0, -1.59869, 0, 0, 1, 0.0272933, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.733542, 0, 1, 0, -1.59869, 0, 0, 1, 0.0272933, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.758942, 0, 1, 0, -1.59869, 0, 0, 1, 0.0272933, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.691528, 0, 1, 0, -1.59869, 0, 0, 1, 0.0454424, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.729722, 0, 1, 0, -1.59869, 0, 0, 1, 0.0454424, 0, 0, 0, 1), Qt.matrix4x4(0.999661, -0.012432, -0.0228667, -0.732668, 0.012432, 0.999922, -0.00014206, -1.60792, 0.0228667, -0.000142268, 0.999738, 0.0284629, 0, 0, 0, 1), Qt.matrix4x4(0.759128, -0.0442635, 0.649435, -0.395481, -0.6499, -0.107936, 0.752316, 0.583344, 0.0367976, -0.993172, -0.110704, 1.54358, 0, 0, 0, 1), Qt.matrix4x4(0.787202, -0.0338466, 0.615765, -0.482427, -0.615327, -0.109564, 0.78062, 0.561206, 0.0410442, -0.993403, -0.107076, 1.54111, 0, 0, 0, 1), Qt.matrix4x4(0.735822, -0.0584441, 0.674648, -0.443402, -0.676539, -0.106614, 0.728648, 0.600227, 0.0293419, -0.992581, -0.117989, 1.54839, 0, 0, 0, 1),

            // [88] j_Bip_R_Shoulder (Corrected inverseBindPose)
            Qt.matrix4x4(0.9649, 0.2541, 0.0658, 0.0249, -0.2541, 0.9672, 0, -0.1273, -0.0658, -0.0167, 0.9977, -0.0079, 0, 0, 0, 1),

            // 89-end preserved from source
            Qt.matrix4x4(0.990027, 0.140878, -3.88206e-09, -0.201676, -0.140878, 0.990027, 3.77144e-08, -1.59389, 9.15645e-09, -3.67914e-08, 1, 0.0301292, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.134485, 0, 1, 0, -1.59012, 0, 0, 1, 0.0301292, 0, 0, 0, 1), Qt.matrix4x4(0.999999, -2.70291e-08, -0.00169146, 0.367231, 2.71817e-08, 1, 9.02343e-08, -1.59012, 0.00169146, -9.02802e-08, 0.999999, 0.0307704, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.618621, 0, 1, 0, -1.59012, 0, 0, 1, 0.0296694, 0, 0, 0, 1), Qt.matrix4x4(0.999811, 1.77738e-09, 0.0194199, 0.69138, -2.64541e-09, 1, 4.4672e-08, -1.59869, -0.0194199, -4.4715e-08, 0.999811, -0.00657868, 0, 0, 0, 1), Qt.matrix4x4(0.998841, 0.0288736, 0.0385161, 0.681619, -0.0288734, 0.999583, -0.000560868, -1.61905, -0.0385163, -0.000551876, 0.999258, -0.019576, 0, 0, 0, 1), Qt.matrix4x4(0.99884, 0.0347321, 0.0333433, 0.694973, -0.0347257, 0.999397, -0.000771367, -1.62312, -0.0333499, -0.000387397, 0.999444, -0.0159173, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.686508, 0, 1, 0, -1.59869, 0, 0, 1, 0.0635363, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.721444, 0, 1, 0, -1.59869, 0, 0, 1, 0.0635363, 0, 0, 0, 1), Qt.matrix4x4(0.999695, -0.0155363, -0.0192181, 0.764968, 0.0155363, 0.999879, -0.000149271, -1.58698, 0.0192181, -0.000149353, 0.999815, 0.0780145, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.692368, 0, 1, 0, -1.59869, 0, 0, 1, 0.0272933, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.733542, 0, 1, 0, -1.59869, 0, 0, 1, 0.0272933, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.758942, 0, 1, 0, -1.59869, 0, 0, 1, 0.0272933, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.691528, 0, 1, 0, -1.59869, 0, 0, 1, 0.0454424, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.729722, 0, 1, 0, -1.59869, 0, 0, 1, 0.0454424, 0, 0, 0, 1), Qt.matrix4x4(0.999661, 0.012432, 0.0228667, 0.732668, -0.012432, 0.999922, -0.00014206, -1.60792, -0.0228667, -0.000142268, 0.999738, 0.0284629, 0, 0, 0, 1), Qt.matrix4x4(0.759128, 0.0442635, -0.649435, 0.395481, 0.6499, -0.107936, 0.752316, 0.583344, -0.0367976, -0.993172, -0.110704, 1.54358, 0, 0, 0, 1), Qt.matrix4x4(0.787202, 0.0338466, -0.615765, 0.482427, 0.615327, -0.109564, 0.78062, 0.561206, -0.0410442, -0.993403, -0.107076, 1.54111, 0, 0, 0, 1), Qt.matrix4x4(0.735822, 0.0584441, -0.674648, 0.443402, 0.676539, -0.106614, 0.728648, 0.600227, -0.0293419, -0.992581, -0.117989, 1.54839, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.0853396, 0, 0.999781, 0.0209207, -1.12081, 0, -0.0209207, 0.999781, 0.0241119, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.0853396, 0, 0.997787, 0.0664965, -0.656974, 0, -0.0664965, 0.997787, 0.056914, 0, 0, 0, 1), Qt.matrix4x4(-0.946913, -0.103034, -0.304534, 0.0843454, -0.148039, 0.980592, 0.128543, -0.431656, 0.28538, 0.166802, -0.943788, -0.348786, 0, 0, 0, 1), Qt.matrix4x4(-0.946913, -0.103034, -0.304534, 0.0688403, -0.148039, 0.980592, 0.128543, -0.245581, 0.28538, 0.166802, -0.943788, -0.348545, 0, 0, 0, 1), Qt.matrix4x4(0.968415, 0.0891519, -0.23286, -0.106569, -0.0935545, 0.995583, -0.00790829, -0.450245, 0.231126, 0.0294436, 0.972478, -0.193674, 0, 0, 0, 1), Qt.matrix4x4(0.968415, 0.0891519, -0.23286, -0.0995497, -0.0935545, 0.995583, -0.00790829, -0.265214, 0.231126, 0.0294436, 0.972478, -0.199596, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, 0.0722113, -0.997371, -0.0644774, -0.125518, 0.989556, 0.0708752, -0.646676, 0.992072, 0.124754, 0.0151209, -0.328997, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, 0.0722113, -0.997371, -0.0591142, -0.125518, 0.989556, 0.0708752, -0.444354, 0.992072, 0.124754, 0.0151209, -0.32935, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, 0.0722113, -0.997371, -0.0544081, -0.125518, 0.989556, 0.0708752, -0.258641, 0.992072, 0.124754, 0.0151209, -0.326015, 0, 0, 0, 1), Qt.matrix4x4(-0.946913, -0.103034, -0.304534, 0.0843454, -0.148039, 0.980592, 0.128543, -0.431656, 0.28538, 0.166802, -0.943788, -0.348786, 0, 0, 0, 1), Qt.matrix4x4(-0.946913, -0.103034, -0.304534, 0.0688403, -0.148039, 0.980592, 0.128543, -0.245581, 0.28538, 0.166802, -0.943788, -0.348545, 0, 0, 0, 1), Qt.matrix4x4(0.968415, 0.0891519, -0.23286, -0.106569, -0.0935545, 0.995583, -0.00790829, -0.450245, 0.231126, 0.0294436, 0.972478, -0.193674, 0, 0, 0, 1), Qt.matrix4x4(0.968415, 0.0891519, -0.23286, -0.0995497, -0.0935545, 0.995583, -0.00790829, -0.265214, 0.231126, 0.0294436, 0.972478, -0.199596, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, 0.0722113, -0.997371, -0.0644774, -0.125518, 0.989556, 0.0708752, -0.646676, 0.992072, 0.124754, 0.0151209, -0.328997, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, 0.0722113, -0.997371, -0.0591142, -0.125518, 0.989556, 0.0708752, -0.444354, 0.992072, 0.124754, 0.0151209, -0.32935, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, 0.0722113, -0.997371, -0.0544081, -0.125518, 0.989556, 0.0708752, -0.258641, 0.992072, 0.124754, 0.0151209, -0.326015, 0, 0, 0, 1), Qt.matrix4x4(-0.946913, -0.103034, -0.304534, 0.0843454, -0.148039, 0.980592, 0.128543, -0.431656, 0.28538, 0.166802, -0.943788, -0.348786, 0, 0, 0, 1), Qt.matrix4x4(-0.946913, -0.103034, -0.304534, 0.0688403, -0.148039, 0.980592, 0.128543, -0.245581, 0.28538, 0.166802, -0.943788, -0.348545, 0, 0, 0, 1), Qt.matrix4x4(0.968415, 0.0891519, -0.23286, -0.106569, -0.0935545, 0.995583, -0.00790829, -0.450245, 0.231126, 0.0294436, 0.972478, -0.193674, 0, 0, 0, 1), Qt.matrix4x4(0.968415, 0.0891519, -0.23286, -0.0995497, -0.0935545, 0.995583, -0.00790829, -0.265214, 0.231126, 0.0294436, 0.972478, -0.199596, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, 0.0722113, -0.997371, -0.0644774, -0.125518, 0.989556, 0.0708752, -0.646676, 0.992072, 0.124754, 0.0151209, -0.328997, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, 0.0722113, -0.997371, -0.0591142, -0.125518, 0.989556, 0.0708752, -0.444354, 0.992072, 0.124754, 0.0151209, -0.32935, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, 0.0722113, -0.997371, -0.0544081, -0.125518, 0.989556, 0.0708752, -0.258641, 0.992072, 0.124754, 0.0151209, -0.326015, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.0853396, 0, 0.999985, 0.00548092, -0.136476, 0, -0.00548092, 0.999985, 0.0426288, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.0853396, 0, 0.999952, 0.00981419, -0.0560958, 0, -0.00981419, 0.999952, -0.0885555, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0853396, 0, 0.999781, 0.0209207, -1.12081, 0, -0.0209207, 0.999781, 0.0241119, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0853396, 0, 0.997787, 0.0664965, -0.656974, 0, -0.0664965, 0.997787, 0.056914, 0, 0, 0, 1), Qt.matrix4x4(-0.946913, 0.103034, 0.304535, -0.0843454, 0.148039, 0.980592, 0.128543, -0.431656, -0.28538, 0.166802, -0.943788, -0.348786, 0, 0, 0, 1), Qt.matrix4x4(-0.946913, 0.103034, 0.304535, -0.0688403, 0.148039, 0.980592, 0.128543, -0.245581, -0.28538, 0.166802, -0.943788, -0.348545, 0, 0, 0, 1), Qt.matrix4x4(0.968415, -0.0891519, 0.23286, 0.106569, 0.0935545, 0.995583, -0.00790829, -0.450245, -0.231126, 0.0294436, 0.972478, -0.193674, 0, 0, 0, 1), Qt.matrix4x4(0.968415, -0.0891519, 0.23286, 0.0995497, 0.0935545, 0.995583, -0.00790829, -0.265215, -0.231126, 0.0294436, 0.972478, -0.199596, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, -0.0722113, 0.997371, 0.0644774, 0.125518, 0.989556, 0.0708752, -0.646676, -0.992072, 0.124754, 0.0151209, -0.328997, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, -0.0722113, 0.997371, 0.0591143, 0.125518, 0.989556, 0.0708752, -0.444354, -0.992072, 0.124754, 0.0151209, -0.32935, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, -0.0722113, 0.997371, 0.0544081, 0.125518, 0.989556, 0.0708752, -0.258642, -0.992072, 0.124754, 0.0151209, -0.326015, 0, 0, 0, 1), Qt.matrix4x4(-0.946913, 0.103034, 0.304535, -0.0843454, 0.148039, 0.980592, 0.128543, -0.431656, -0.28538, 0.166802, -0.943788, -0.348786, 0, 0, 0, 1), Qt.matrix4x4(-0.946913, 0.103034, 0.304535, -0.0688403, 0.148039, 0.980592, 0.128543, -0.245581, -0.28538, 0.166802, -0.943788, -0.348545, 0, 0, 0, 1), Qt.matrix4x4(0.968415, -0.0891519, 0.23286, 0.106569, 0.0935545, 0.995583, -0.00790829, -0.450245, -0.231126, 0.0294436, 0.972478, -0.193674, 0, 0, 0, 1), Qt.matrix4x4(0.968415, -0.0891519, 0.23286, 0.0995497, 0.0935545, 0.995583, -0.00790829, -0.265215, -0.231126, 0.0294436, 0.972478, -0.199596, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, -0.0722113, 0.997371, 0.0644774, 0.125518, 0.989556, 0.0708752, -0.646676, -0.992072, 0.124754, 0.0151209, -0.328997, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, -0.0722113, 0.997371, 0.0591143, 0.125518, 0.989556, 0.0708752, -0.444354, -0.992072, 0.124754, 0.0151209, -0.32935, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, -0.0722113, 0.997371, 0.0544081, 0.125518, 0.989556, 0.0708752, -0.258642, -0.992072, 0.124754, 0.0151209, -0.326015, 0, 0, 0, 1), Qt.matrix4x4(-0.946913, 0.103034, 0.304535, -0.0843454, 0.148039, 0.980592, 0.128543, -0.431656, -0.28538, 0.166802, -0.943788, -0.348786, 0, 0, 0, 1), Qt.matrix4x4(-0.946913, 0.103034, 0.304535, -0.0688403, 0.148039, 0.980592, 0.128543, -0.245581, -0.28538, 0.166802, -0.943788, -0.348545, 0, 0, 0, 1), Qt.matrix4x4(0.968415, -0.0891519, 0.23286, 0.106569, 0.0935545, 0.995583, -0.00790829, -0.450245, -0.231126, 0.0294436, 0.972478, -0.193674, 0, 0, 0, 1), Qt.matrix4x4(0.968415, -0.0891519, 0.23286, 0.0995497, 0.0935545, 0.995583, -0.00790829, -0.265215, -0.231126, 0.0294436, 0.972478, -0.199596, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, -0.0722113, 0.997371, 0.0644774, 0.125518, 0.989556, 0.0708752, -0.646676, -0.992072, 0.124754, 0.0151209, -0.328997, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, -0.0722113, 0.997371, 0.0591143, 0.125518, 0.989556, 0.0708752, -0.444354, -0.992072, 0.124754, 0.0151209, -0.32935, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, -0.0722113, 0.997371, 0.0544081, 0.125518, 0.989556, 0.0708752, -0.258642, -0.992072, 0.124754, 0.0151209, -0.326015, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0853396, 0, 0.999985, 0.00548092, -0.136476, 0, -0.00548092, 0.999985, 0.0426288, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0853396, 0, 0.999952, 0.00981419, -0.0560958, 0, -0.00981419, 0.999952, -0.0885555, 0, 0, 0, 1)]
    }

    MorphTarget {
        id: fcl_EYE_Spread_morphtarget477
        objectName: "Fcl_EYE_Spread"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Joy_morphtarget
        objectName: "Fcl_MTH_Joy"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Fun_morphtarget
        objectName: "Fcl_MTH_Fun"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Neutral_morphtarget
        objectName: "Fcl_MTH_Neutral"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Large_morphtarget
        objectName: "Fcl_MTH_Large"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Small_morphtarget
        objectName: "Fcl_MTH_Small"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Angry_morphtarget
        objectName: "Fcl_MTH_Angry"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Down_morphtarget
        objectName: "Fcl_MTH_Down"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Up_morphtarget481
        objectName: "Fcl_MTH_Up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Close_morphtarget480
        objectName: "Fcl_MTH_Close"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Highlight_Hide_morphtarget479
        objectName: "Fcl_EYE_Highlight_Hide"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Iris_Hide_morphtarget478
        objectName: "Fcl_EYE_Iris_Hide"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Sorrow_morphtarget
        objectName: "Fcl_MTH_Sorrow"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Surprised_morphtarget476
        objectName: "Fcl_EYE_Surprised"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Sorrow_morphtarget475
        objectName: "Fcl_EYE_Sorrow"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Joy_L_morphtarget474
        objectName: "Fcl_EYE_Joy_L"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Joy_R_morphtarget473
        objectName: "Fcl_EYE_Joy_R"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Joy_morphtarget472
        objectName: "Fcl_EYE_Joy"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Fun_morphtarget471
        objectName: "Fcl_EYE_Fun"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Close_L_morphtarget470
        objectName: "Fcl_EYE_Close_L"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Close_R_morphtarget469
        objectName: "Fcl_EYE_Close_R"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Close_morphtarget468
        objectName: "Fcl_EYE_Close"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Angry_morphtarget467
        objectName: "Fcl_EYE_Angry"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Natural_morphtarget466
        objectName: "Fcl_EYE_Natural"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Neutral_morphtarget600
        objectName: "Fcl_MTH_Neutral"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_O_morphtarget612
        objectName: "Fcl_MTH_O"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_E_morphtarget611
        objectName: "Fcl_MTH_E"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_U_morphtarget610
        objectName: "Fcl_MTH_U"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_I_morphtarget609
        objectName: "Fcl_MTH_I"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_A_morphtarget608
        objectName: "Fcl_MTH_A"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_SkinFung_L_morphtarget607
        objectName: "Fcl_MTH_SkinFung_L"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_SkinFung_R_morphtarget606
        objectName: "Fcl_MTH_SkinFung_R"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_SkinFung_morphtarget605
        objectName: "Fcl_MTH_SkinFung"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Surprised_morphtarget604
        objectName: "Fcl_MTH_Surprised"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Sorrow_morphtarget603
        objectName: "Fcl_MTH_Sorrow"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Joy_morphtarget602
        objectName: "Fcl_MTH_Joy"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Fun_morphtarget601
        objectName: "Fcl_MTH_Fun"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Hide_morphtarget613
        objectName: "Fcl_HA_Hide"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Large_morphtarget599
        objectName: "Fcl_MTH_Large"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Small_morphtarget598
        objectName: "Fcl_MTH_Small"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Angry_morphtarget597
        objectName: "Fcl_MTH_Angry"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Down_morphtarget596
        objectName: "Fcl_MTH_Down"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Up_morphtarget595
        objectName: "Fcl_MTH_Up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Close_morphtarget594
        objectName: "Fcl_MTH_Close"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Highlight_Hide_morphtarget593
        objectName: "Fcl_EYE_Highlight_Hide"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Iris_Hide_morphtarget592
        objectName: "Fcl_EYE_Iris_Hide"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Spread_morphtarget591
        objectName: "Fcl_EYE_Spread"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Surprised_morphtarget590
        objectName: "Fcl_EYE_Surprised"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Sorrow_morphtarget589
        objectName: "Fcl_EYE_Sorrow"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Short_Low_morphtarget625
        objectName: "Fcl_HA_Short_Low"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    PrincipledMaterial {
        id: n00_000_00_FaceMouth_00_FACE__Instance__material
        objectName: "N00_000_00_FaceMouth_00_FACE (Instance)"
        baseColorMap: _0_texture
        roughness: 0.8999999761581421
        normalMap: _1_texture
        emissiveMap: _2_texture
        alphaMode: PrincipledMaterial.Mask
        depthDrawMode: PrincipledMaterial.OpaquePrePassDepthDraw
        lighting: PrincipledMaterial.NoLighting
    }
    PrincipledMaterial {
        id: n00_000_Hair_00_HAIR__Instance__material
        objectName: "N00_000_Hair_00_HAIR (Instance)"
        baseColorMap: _19_texture
        roughness: 0.8999999761581421
        normalMap: _20_texture
        emissiveMap: _21_texture
        emissiveFactor: Qt.vector3d(0.858824, 0.541176, 0.231373)
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Mask
        depthDrawMode: PrincipledMaterial.OpaquePrePassDepthDraw
        lighting: PrincipledMaterial.NoLighting
    }
    Skin {
        id: skin653
        joints: [root, j_Bip_C_Hips, j_Bip_C_Spine, j_Bip_C_Chest, j_Bip_C_UpperChest, j_Sec_L_Bust1, j_Sec_L_Bust2, j_Sec_R_Bust1, j_Sec_R_Bust2, j_Bip_C_Neck, j_Bip_C_Head, j_Adj_L_FaceEye, j_Adj_R_FaceEye, j_Sec_Hair1_01, j_Sec_Hair2_01, j_Sec_Hair1_02, j_Sec_Hair2_02, j_Sec_Hair1_03, j_Sec_Hair2_03, j_Sec_Hair3_03, j_Sec_Hair1_04, j_Sec_Hair2_04, j_Sec_Hair3_04, j_Sec_Hair1_05, j_Sec_Hair2_05, j_Sec_Hair3_05, j_Sec_Hair1_06, j_Sec_Hair2_06, j_Sec_Hair3_06, j_Sec_Hair1_07, j_Sec_Hair2_07, j_Sec_Hair3_07, j_Sec_Hair1_08, j_Sec_Hair2_08, j_Sec_Hair3_08, j_Sec_Hair1_09, j_Sec_Hair2_09, j_Sec_Hair3_09, j_Sec_Hair1_10, j_Sec_Hair2_10, j_Sec_Hair3_10, j_Sec_Hair1_11, j_Sec_Hair2_11, j_Sec_Hair3_11, j_Sec_Hair1_12, j_Sec_Hair2_12, j_Sec_Hair3_12, j_Sec_Hair1_13, j_Sec_Hair2_13, j_Sec_Hair3_13, j_Sec_Hair1_14, j_Sec_Hair2_14, j_Sec_Hair3_14, j_Sec_Hair1_15, j_Sec_Hair2_15, j_Sec_Hair3_15, j_Sec_Hair1_16, j_Sec_Hair2_16, j_Sec_Hair3_16, j_Sec_Hair1_17, j_Sec_Hair2_17, j_Sec_Hair3_17, j_Sec_Hair1_18, j_Sec_Hair2_18, j_Sec_Hair3_18, j_Sec_Hair1_19, j_Sec_Hair2_19, j_Sec_Hair1_20, j_Sec_Hair2_20, j_Bip_L_Shoulder, j_Bip_L_UpperArm, j_Bip_L_LowerArm, j_Bip_L_Hand, j_Bip_L_Index1, j_Bip_L_Index2, j_Bip_L_Index3, j_Bip_L_Little1, j_Bip_L_Little2, j_Bip_L_Little3, j_Bip_L_Middle1, j_Bip_L_Middle2, j_Bip_L_Middle3, j_Bip_L_Ring1, j_Bip_L_Ring2, j_Bip_L_Ring3, j_Bip_L_Thumb1, j_Bip_L_Thumb2, j_Bip_L_Thumb3, j_Bip_R_Shoulder, j_Bip_R_UpperArm, j_Bip_R_LowerArm, j_Bip_R_Hand, j_Bip_R_Index1, j_Bip_R_Index2, j_Bip_R_Index3, j_Bip_R_Little1, j_Bip_R_Little2, j_Bip_R_Little3, j_Bip_R_Middle1, j_Bip_R_Middle2, j_Bip_R_Middle3, j_Bip_R_Ring1, j_Bip_R_Ring2, j_Bip_R_Ring3, j_Bip_R_Thumb1, j_Bip_R_Thumb2, j_Bip_R_Thumb3, j_Bip_L_UpperLeg, j_Bip_L_LowerLeg, j_Sec_L_CoatSkirtBack_01, j_Sec_L_CoatSkirtBack_end_01, j_Sec_L_CoatSkirtFront_01, j_Sec_L_CoatSkirtFront_end_01, j_Sec_L_CoatSkirtSide1_01, j_Sec_L_CoatSkirtSide2_01, j_Sec_L_CoatSkirtSide2_end_01, j_Sec_L_CoatSkirtBack_02, j_Sec_L_CoatSkirtBack_end_02, j_Sec_L_CoatSkirtFront_02, j_Sec_L_CoatSkirtFront_end_02, j_Sec_L_CoatSkirtSide1_02, j_Sec_L_CoatSkirtSide2_02, j_Sec_L_CoatSkirtSide2_end_02, j_Sec_L_CoatSkirtBack_03, j_Sec_L_CoatSkirtBack_end_03, j_Sec_L_CoatSkirtFront_03, j_Sec_L_CoatSkirtFront_end_03, j_Sec_L_CoatSkirtSide1_03, j_Sec_L_CoatSkirtSide2_03, j_Sec_L_CoatSkirtSide2_end_03, j_Bip_L_Foot, j_Bip_L_ToeBase, j_Bip_R_UpperLeg, j_Bip_R_LowerLeg, j_Sec_R_CoatSkirtBack_01, j_Sec_R_CoatSkirtBack_end_01, j_Sec_R_CoatSkirtFront_01, j_Sec_R_CoatSkirtFront_end_01, j_Sec_R_CoatSkirtSide1_01, j_Sec_R_CoatSkirtSide2_01, j_Sec_R_CoatSkirtSide2_end_01, j_Sec_R_CoatSkirtBack_02, j_Sec_R_CoatSkirtBack_end_02, j_Sec_R_CoatSkirtFront_02, j_Sec_R_CoatSkirtFront_end_02, j_Sec_R_CoatSkirtSide1_02, j_Sec_R_CoatSkirtSide2_02, j_Sec_R_CoatSkirtSide2_end_02, j_Sec_R_CoatSkirtBack_03, j_Sec_R_CoatSkirtBack_end_03, j_Sec_R_CoatSkirtFront_03, j_Sec_R_CoatSkirtFront_end_03, j_Sec_R_CoatSkirtSide1_03, j_Sec_R_CoatSkirtSide2_03, j_Sec_R_CoatSkirtSide2_end_03, j_Bip_R_Foot, j_Bip_R_ToeBase]
        inverseBindPoses: [Qt.matrix4x4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0, 0, 0.992088, 0.125548, -1.15843, 0, -0.125548, 0.992088, 0.142986, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 7.11265e-32, 0, 0.98855, 0.150896, -1.21633, 0, -0.150896, 0.98855, 0.167343, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -2.40917e-17, 0, 0.992589, -0.121518, -1.34611, 0, 0.121518, 0.992589, -0.186612, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 1.06822e-17, 0, 0.943357, -0.33178, -1.39816, 0, 0.33178, 0.943357, -0.496668, 0, 0, 0, 1), Qt.matrix4x4(0.890608, -0.047434, -0.45229, 0.0537904, -0.00726396, 0.992935, -0.118438, -1.45443, 0.454713, 0.108767, 0.883972, -0.263178, 0, 0, 0, 1), Qt.matrix4x4(0.890608, -0.047434, -0.45229, 0.0538004, -0.00726397, 0.992935, -0.118438, -1.45443, 0.454713, 0.108767, 0.883972, -0.264455, 0, 0, 0, 1), Qt.matrix4x4(0.890608, 0.047434, 0.45229, -0.0537904, 0.00726396, 0.992935, -0.118438, -1.45443, -0.454713, 0.108767, 0.883972, -0.263178, 0, 0, 0, 1), Qt.matrix4x4(0.890608, 0.047434, 0.45229, -0.0538004, 0.00726397, 0.992935, -0.118438, -1.45443, -0.454713, 0.108767, 0.883972, -0.264455, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 1.19815e-16, 0, 0.992864, 0.119252, -1.62085, 0, -0.119252, 0.992864, 0.234831, 0, 0, 0, 1), Qt.matrix4x4(1, 5.25951e-08, -4.37914e-07, -1.03702e-07, -4.78589e-08, 0.999942, 0.0108084, -1.73272, 4.38457e-07, -0.0108084, 0.999942, 0.0471112, 0, 0, 0, 1), Qt.matrix4x4(0.930442, -0.000646281, -0.366439, -0.01619, 0.0198007, 0.998626, 0.0485156, -1.79385, 0.365904, -0.0523967, 0.929176, 0.0938457, 0, 0, 0, 1), Qt.matrix4x4(0.930442, 0.000646404, 0.366438, 0.0161898, -0.0198008, 0.998626, 0.0485155, -1.79385, -0.365903, -0.0523967, 0.929177, 0.0938458, 0, 0, 0, 1), Qt.matrix4x4(-0.401627, 0.844586, -0.354076, -1.60455, -0.915804, -0.370394, 0.155281, 0.580047, 4.61936e-07, 0.386629, 0.922235, -0.692951, 0, 0, 0, 1), Qt.matrix4x4(-0.401627, 0.844586, -0.354076, -1.6044, -0.915803, -0.370394, 0.155281, 0.529659, 4.32134e-07, 0.386629, 0.922235, -0.692952, 0, 0, 0, 1), Qt.matrix4x4(-0.600142, -0.781958, 0.168435, 1.51148, 0.799893, -0.586686, 0.126372, 0.994297, 4.02331e-07, 0.210571, 0.977578, -0.369484, 0, 0, 0, 1), Qt.matrix4x4(-0.600143, -0.781958, 0.168435, 1.51134, 0.799893, -0.586686, 0.126373, 0.956455, 4.02331e-07, 0.210571, 0.977578, -0.369484, 0, 0, 0, 1), Qt.matrix4x4(-0.985997, -0.165302, 0.0220353, 0.21142, 0.166764, -0.977352, 0.130281, 1.77766, 5.48549e-07, 0.132131, 0.991232, -0.272557, 0, 0, 0, 1), Qt.matrix4x4(-0.854811, -0.419369, 0.305662, 0.662282, 0.51894, -0.690794, 0.503493, 1.24962, 8.9407e-08, 0.589011, 0.808125, -1.07652, 0, 0, 0, 1), Qt.matrix4x4(-0.854811, -0.419368, 0.305661, 0.662165, 0.51894, -0.690794, 0.503493, 1.21591, 2.5332e-07, 0.589011, 0.808125, -1.07652, 0, 0, 0, 1), Qt.matrix4x4(-0.993274, 0.115088, -0.0127168, -0.12231, -0.115789, -0.987266, 0.10909, 1.80366, 8.5216e-08, 0.109829, 0.99395, -0.229557, 0, 0, 0, 1), Qt.matrix4x4(-0.811412, 0.488784, -0.32047, -0.794653, -0.584475, -0.678567, 0.444901, 1.24595, 1.49012e-07, 0.548305, 0.836278, -1.00751, 0, 0, 0, 1), Qt.matrix4x4(-0.811412, 0.488784, -0.32047, -0.794526, -0.584475, -0.678567, 0.444901, 1.21206, 1.49012e-07, 0.548305, 0.836278, -1.00751, 0, 0, 0, 1), Qt.matrix4x4(-0.999998, -0.00250177, 0.000233629, 0.00708628, 0.00251265, -0.995682, 0.0928101, 1.85633, 4.30606e-07, 0.0928105, 0.995684, -0.255647, 0, 0, 0, 1), Qt.matrix4x4(-0.999817, 0.0187861, 0.00343314, -0.032183, -0.0190973, -0.983532, -0.179718, 1.81701, 4.0303e-07, -0.17975, 0.983712, 0.244623, 0, 0, 0, 1), Qt.matrix4x4(-0.999817, 0.0187861, 0.00343314, -0.0321769, -0.0190973, -0.983532, -0.179718, 1.77637, 4.03263e-07, -0.17975, 0.983712, 0.244623, 0, 0, 0, 1), Qt.matrix4x4(-0.990447, 0.13789, 0.000864603, -0.300622, -0.137893, -0.990428, -0.00620702, 1.84141, 4.40748e-07, -0.00626695, 0.99998, -0.0678957, 0, 0, 0, 1), Qt.matrix4x4(-0.994168, -0.106954, -0.0138453, 0.149302, 0.107847, -0.985941, -0.127632, 1.82296, 1.6205e-07, -0.128381, 0.991725, 0.156645, 0, 0, 0, 1), Qt.matrix4x4(-0.994168, -0.106954, -0.0138453, 0.149275, 0.107847, -0.985941, -0.127632, 1.79145, 1.62516e-07, -0.128381, 0.991725, 0.156645, 0, 0, 0, 1), Qt.matrix4x4(-0.999996, -0.00305625, 6.97165e-05, 0.0850229, 0.00305705, -0.999739, 0.0226584, 1.8449, 4.48639e-07, 0.0226585, 0.999743, -0.0889094, 0, 0, 0, 1), Qt.matrix4x4(-0.921469, 0.386318, -0.0406877, -0.624666, -0.388454, -0.9164, 0.0965178, 1.68642, 3.74392e-07, 0.104743, 0.994499, -0.237365, 0, 0, 0, 1), Qt.matrix4x4(-0.921469, 0.386317, -0.0406876, -0.624568, -0.388454, -0.9164, 0.0965178, 1.6516, 3.76254e-07, 0.104743, 0.994499, -0.237365, 0, 0, 0, 1), Qt.matrix4x4(-0.990972, -0.133957, 0.00545571, 0.29241, 0.134068, -0.990151, 0.0403232, 1.8392, 3.87197e-07, 0.0406906, 0.999172, -0.149201, 0, 0, 0, 1), Qt.matrix4x4(-0.991699, 0.128251, 0.00925774, -0.188578, -0.128584, -0.989125, -0.0713963, 1.82481, 4.45172e-07, -0.071994, 0.997405, 0.0575144, 0, 0, 0, 1), Qt.matrix4x4(-0.991699, 0.128251, 0.00925774, -0.188545, -0.128584, -0.989125, -0.0713963, 1.79152, 4.45172e-07, -0.071994, 0.997405, 0.0575144, 0, 0, 0, 1), Qt.matrix4x4(-0.999997, -0.00242874, -2.68141e-05, -0.0760716, 0.00242889, -0.999935, -0.0111994, 1.83976, 3.88042e-07, -0.0111994, 0.999937, -0.0265954, 0, 0, 0, 1), Qt.matrix4x4(-0.896194, -0.440791, 0.0504198, 0.721681, 0.443665, -0.890388, 0.101846, 1.63914, 4.26546e-07, 0.113643, 0.993522, -0.251784, 0, 0, 0, 1), Qt.matrix4x4(-0.896193, -0.440791, 0.0504198, 0.721579, 0.443665, -0.890387, 0.101846, 1.60636, 4.22821e-07, 0.113643, 0.993522, -0.251784, 0, 0, 0, 1), Qt.matrix4x4(-0.748844, -0.599564, -0.282411, 1.19253, 0.662747, -0.677453, -0.3191, 1.25373, 4.47035e-07, -0.426123, 0.904665, 0.726603, 0, 0, 0, 1), Qt.matrix4x4(-0.756544, -0.239371, -0.608558, 0.549724, 0.653943, -0.276927, -0.704038, 0.499891, 3.27826e-07, -0.930598, 0.366042, 1.69381, 0, 0, 0, 1), Qt.matrix4x4(-0.756544, -0.239371, -0.608558, 0.549563, 0.653943, -0.276927, -0.704038, 0.458547, 2.38419e-07, -0.930598, 0.366042, 1.69381, 0, 0, 0, 1), Qt.matrix4x4(-0.40515, 0.733052, 0.546341, -1.43852, -0.914251, -0.324853, -0.24211, 0.609798, 1.2219e-06, -0.597584, 0.801806, 1.04589, 0, 0, 0, 1), Qt.matrix4x4(0.616, 0.143257, -0.774611, -0.164211, -0.787746, 0.112024, -0.605728, -0.203603, 2.08616e-07, 0.983325, 0.181857, -1.84998, 0, 0, 0, 1), Qt.matrix4x4(0.616, 0.143257, -0.774611, -0.164354, -0.787746, 0.112024, -0.605728, -0.240941, -1.78814e-07, 0.983325, 0.181857, -1.84998, 0, 0, 0, 1), Qt.matrix4x4(-0.898292, -0.436803, 0.0476737, 0.711516, 0.439397, -0.892989, 0.0974619, 1.5937, 3.96743e-07, 0.108497, 0.994097, -0.122928, 0, 0, 0, 1), Qt.matrix4x4(-0.937259, 0.31662, 0.145933, -0.572381, -0.348633, -0.851197, -0.392324, 1.41582, 5.1409e-07, -0.418586, 0.908177, 0.772925, 0, 0, 0, 1), Qt.matrix4x4(-0.937259, 0.31662, 0.145933, -0.572282, -0.348633, -0.851198, -0.392324, 1.3771, 4.84288e-07, -0.418586, 0.908177, 0.772925, 0, 0, 0, 1), Qt.matrix4x4(-1, 0.00150124, -0.000601497, 0.00402469, -0.00161725, -0.928177, 0.372138, 1.64728, 3.71307e-07, 0.372139, 0.928177, -0.557532, 0, 0, 0, 1), Qt.matrix4x4(-0.976987, 0.206422, 0.0537201, -0.341307, -0.213298, -0.945494, -0.246057, 1.59443, 4.26546e-07, -0.251852, 0.967766, 0.510678, 0, 0, 0, 1), Qt.matrix4x4(-0.976987, 0.206422, 0.0537201, -0.341254, -0.213298, -0.945494, -0.246057, 1.56255, 4.26546e-07, -0.251852, 0.967766, 0.510678, 0, 0, 0, 1), Qt.matrix4x4(-0.932631, 0.355517, -0.0617019, -0.569219, -0.360831, -0.918895, 0.15948, 1.63296, 3.94881e-07, 0.171, 0.985271, -0.232109, 0, 0, 0, 1), Qt.matrix4x4(-0.959165, -0.247255, -0.137366, 0.456985, 0.282851, -0.838456, -0.465819, 1.39102, 7.00355e-07, -0.485651, 0.874153, 0.882674, 0, 0, 0, 1), Qt.matrix4x4(-0.959164, -0.247256, -0.137366, 0.456908, 0.282851, -0.838456, -0.465819, 1.35463, 8.71718e-07, -0.485652, 0.874153, 0.882674, 0, 0, 0, 1), Qt.matrix4x4(-0.979643, -0.20021, -0.0146787, 0.473582, 0.200747, -0.977021, -0.0716341, 1.78643, 4.10248e-07, -0.0731226, 0.997323, 0.139852, 0, 0, 0, 1), Qt.matrix4x4(-0.809424, -0.580181, 0.0906799, 1.1431, 0.587225, -0.799715, 0.124991, 1.38256, 4.76837e-07, 0.15442, 0.988005, -0.272276, 0, 0, 0, 1), Qt.matrix4x4(-0.809424, -0.580181, 0.0906799, 1.14295, 0.587225, -0.799715, 0.124991, 1.34292, 4.5076e-07, 0.154421, 0.988005, -0.272276, 0, 0, 0, 1), Qt.matrix4x4(-0.89311, 0.429009, 0.135301, -0.882946, -0.449839, -0.851754, -0.268626, 1.51623, 5.58794e-07, -0.300776, 0.953695, 0.555618, 0, 0, 0, 1), Qt.matrix4x4(-0.745505, 0.449543, 0.49207, -0.898775, -0.6665, -0.502831, -0.550398, 0.826918, 6.10948e-07, -0.73829, 0.674484, 1.34619, 0, 0, 0, 1), Qt.matrix4x4(-0.745505, 0.449543, 0.49207, -0.898666, -0.6665, -0.502831, -0.550398, 0.799134, 6.10948e-07, -0.73829, 0.674484, 1.34619, 0, 0, 0, 1), Qt.matrix4x4(-0.957716, -0.279747, 0.0672574, 0.428719, 0.287719, -0.931181, 0.223875, 1.65339, 4.76837e-07, 0.23376, 0.972294, -0.370377, 0, 0, 0, 1), Qt.matrix4x4(-0.932306, 0.281236, -0.227407, -0.547086, -0.361673, -0.724958, 0.5862, 1.24866, 8.9407e-08, 0.628764, 0.777597, -1.05805, 0, 0, 0, 1), Qt.matrix4x4(-0.932306, 0.281237, -0.227407, -0.547027, -0.361674, -0.724958, 0.586199, 1.22619, 3.35276e-07, 0.628764, 0.777597, -1.05805, 0, 0, 0, 1), Qt.matrix4x4(-0.974261, 0.207329, -0.0884997, -0.302234, -0.225427, -0.896042, 0.382483, 1.59098, 3.7998e-07, 0.392589, 0.919714, -0.653434, 0, 0, 0, 1), Qt.matrix4x4(-0.964282, -0.149166, 0.218886, 0.318595, 0.26488, -0.543029, 0.796842, 0.939066, 1.49012e-08, 0.826359, 0.563144, -1.40907, 0, 0, 0, 1), Qt.matrix4x4(-0.964282, -0.149166, 0.218886, 0.318544, 0.26488, -0.543029, 0.796842, 0.91385, -2.23517e-08, 0.826359, 0.563144, -1.40907, 0, 0, 0, 1), Qt.matrix4x4(-0.809935, -0.208669, 0.548145, 0.422721, 0.58652, -0.288154, 0.756943, 0.567989, -5.0664e-07, 0.934572, 0.355774, -1.83579, 0, 0, 0, 1), Qt.matrix4x4(-0.809935, -0.208669, 0.548145, 0.422479, 0.58652, -0.288154, 0.756943, 0.502968, -5.06639e-07, 0.934572, 0.355774, -1.83579, 0, 0, 0, 1), Qt.matrix4x4(-0.419282, 0.716482, -0.557544, -1.41669, -0.907856, -0.330898, 0.257496, 0.65247, 6.55651e-07, 0.614133, 0.789202, -1.19947, 0, 0, 0, 1), Qt.matrix4x4(-0.419283, 0.716482, -0.557544, -1.41654, -0.907855, -0.330899, 0.257496, 0.601311, 3.27826e-07, 0.614133, 0.789202, -1.19947, 0, 0, 0, 1), Qt.matrix4x4(0.990027, -0.140878, 3.88206e-09, 0.201676, 0.140878, 0.990027, 3.77144e-08, -1.59389, -9.15645e-09, -3.67914e-08, 1, 0.0301292, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.134485, 0, 1, 0, -1.59012, 0, 0, 1, 0.0301292, 0, 0, 0, 1), Qt.matrix4x4(0.999999, 2.70291e-08, 0.00169146, -0.367231, -2.71817e-08, 1, 9.02343e-08, -1.59012, -0.00169146, -9.02802e-08, 0.999999, 0.0307704, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.618621, 0, 1, 0, -1.59012, 0, 0, 1, 0.0296694, 0, 0, 0, 1), Qt.matrix4x4(0.999811, -1.77738e-09, -0.0194199, -0.69138, 2.64541e-09, 1, 4.4672e-08, -1.59869, 0.0194199, -4.4715e-08, 0.999811, -0.00657868, 0, 0, 0, 1), Qt.matrix4x4(0.998841, -0.0288736, -0.0385161, -0.681619, 0.0288734, 0.999583, -0.000560868, -1.61905, 0.0385163, -0.000551876, 0.999258, -0.019576, 0, 0, 0, 1), Qt.matrix4x4(0.99884, -0.0347321, -0.0333433, -0.694973, 0.0347257, 0.999397, -0.000771367, -1.62312, 0.0333499, -0.000387397, 0.999444, -0.0159173, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.686508, 0, 1, 0, -1.59869, 0, 0, 1, 0.0635363, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.721444, 0, 1, 0, -1.59869, 0, 0, 1, 0.0635363, 0, 0, 0, 1), Qt.matrix4x4(0.999695, 0.0155363, 0.0192181, -0.764968, -0.0155363, 0.999879, -0.000149271, -1.58698, -0.0192181, -0.000149353, 0.999815, 0.0780145, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.692368, 0, 1, 0, -1.59869, 0, 0, 1, 0.0272933, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.733542, 0, 1, 0, -1.59869, 0, 0, 1, 0.0272933, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.758942, 0, 1, 0, -1.59869, 0, 0, 1, 0.0272933, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.691528, 0, 1, 0, -1.59869, 0, 0, 1, 0.0454424, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.729722, 0, 1, 0, -1.59869, 0, 0, 1, 0.0454424, 0, 0, 0, 1), Qt.matrix4x4(0.999661, -0.012432, -0.0228667, -0.732668, 0.012432, 0.999922, -0.00014206, -1.60792, 0.0228667, -0.000142268, 0.999738, 0.0284629, 0, 0, 0, 1), Qt.matrix4x4(0.759128, -0.0442635, 0.649435, -0.395481, -0.6499, -0.107936, 0.752316, 0.583344, 0.0367976, -0.993172, -0.110704, 1.54358, 0, 0, 0, 1), Qt.matrix4x4(0.787202, -0.0338466, 0.615765, -0.482427, -0.615327, -0.109564, 0.78062, 0.561206, 0.0410442, -0.993403, -0.107076, 1.54111, 0, 0, 0, 1), Qt.matrix4x4(0.735822, -0.0584441, 0.674648, -0.443402, -0.676539, -0.106614, 0.728648, 0.600227, 0.0293419, -0.992581, -0.117989, 1.54839, 0, 0, 0, 1), Qt.matrix4x4(0.990027, 0.140878, -3.88206e-09, -0.201676, -0.140878, 0.990027, 3.77144e-08, -1.59389, 9.15645e-09, -3.67914e-08, 1, 0.0301292, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.134485, 0, 1, 0, -1.59012, 0, 0, 1, 0.0301292, 0, 0, 0, 1), Qt.matrix4x4(0.999999, -2.70291e-08, -0.00169146, 0.367231, 2.71817e-08, 1, 9.02343e-08, -1.59012, 0.00169146, -9.02802e-08, 0.999999, 0.0307704, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.618621, 0, 1, 0, -1.59012, 0, 0, 1, 0.0296694, 0, 0, 0, 1), Qt.matrix4x4(0.999811, 1.77738e-09, 0.0194199, 0.69138, -2.64541e-09, 1, 4.4672e-08, -1.59869, -0.0194199, -4.4715e-08, 0.999811, -0.00657868, 0, 0, 0, 1), Qt.matrix4x4(0.998841, 0.0288736, 0.0385161, 0.681619, -0.0288734, 0.999583, -0.000560868, -1.61905, -0.0385163, -0.000551876, 0.999258, -0.019576, 0, 0, 0, 1), Qt.matrix4x4(0.99884, 0.0347321, 0.0333433, 0.694973, -0.0347257, 0.999397, -0.000771367, -1.62312, -0.0333499, -0.000387397, 0.999444, -0.0159173, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.686508, 0, 1, 0, -1.59869, 0, 0, 1, 0.0635363, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.721444, 0, 1, 0, -1.59869, 0, 0, 1, 0.0635363, 0, 0, 0, 1), Qt.matrix4x4(0.999695, -0.0155363, -0.0192181, 0.764968, 0.0155363, 0.999879, -0.000149271, -1.58698, 0.0192181, -0.000149353, 0.999815, 0.0780145, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.692368, 0, 1, 0, -1.59869, 0, 0, 1, 0.0272933, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.733542, 0, 1, 0, -1.59869, 0, 0, 1, 0.0272933, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.758942, 0, 1, 0, -1.59869, 0, 0, 1, 0.0272933, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.691528, 0, 1, 0, -1.59869, 0, 0, 1, 0.0454424, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.729722, 0, 1, 0, -1.59869, 0, 0, 1, 0.0454424, 0, 0, 0, 1), Qt.matrix4x4(0.999661, 0.012432, 0.0228667, 0.732668, -0.012432, 0.999922, -0.00014206, -1.60792, -0.0228667, -0.000142268, 0.999738, 0.0284629, 0, 0, 0, 1), Qt.matrix4x4(0.759128, 0.0442635, -0.649435, 0.395481, 0.6499, -0.107936, 0.752316, 0.583344, -0.0367976, -0.993172, -0.110704, 1.54358, 0, 0, 0, 1), Qt.matrix4x4(0.787202, 0.0338466, -0.615765, 0.482427, 0.615327, -0.109564, 0.78062, 0.561206, -0.0410442, -0.993403, -0.107076, 1.54111, 0, 0, 0, 1), Qt.matrix4x4(0.735822, 0.0584441, -0.674648, 0.443402, 0.676539, -0.106614, 0.728648, 0.600227, -0.0293419, -0.992581, -0.117989, 1.54839, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.0853396, 0, 0.999781, 0.0209207, -1.12081, 0, -0.0209207, 0.999781, 0.0241119, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.0853396, 0, 0.997787, 0.0664965, -0.656974, 0, -0.0664965, 0.997787, 0.056914, 0, 0, 0, 1), Qt.matrix4x4(-0.946913, -0.103034, -0.304534, 0.0843454, -0.148039, 0.980592, 0.128543, -0.431656, 0.28538, 0.166802, -0.943788, -0.348786, 0, 0, 0, 1), Qt.matrix4x4(-0.946913, -0.103034, -0.304534, 0.0688403, -0.148039, 0.980592, 0.128543, -0.245581, 0.28538, 0.166802, -0.943788, -0.348545, 0, 0, 0, 1), Qt.matrix4x4(0.968415, 0.0891519, -0.23286, -0.106569, -0.0935545, 0.995583, -0.00790829, -0.450245, 0.231126, 0.0294436, 0.972478, -0.193674, 0, 0, 0, 1), Qt.matrix4x4(0.968415, 0.0891519, -0.23286, -0.0995497, -0.0935545, 0.995583, -0.00790829, -0.265214, 0.231126, 0.0294436, 0.972478, -0.199596, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, 0.0722113, -0.997371, -0.0644774, -0.125518, 0.989556, 0.0708752, -0.646676, 0.992072, 0.124754, 0.0151209, -0.328997, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, 0.0722113, -0.997371, -0.0591142, -0.125518, 0.989556, 0.0708752, -0.444354, 0.992072, 0.124754, 0.0151209, -0.32935, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, 0.0722113, -0.997371, -0.0544081, -0.125518, 0.989556, 0.0708752, -0.258641, 0.992072, 0.124754, 0.0151209, -0.326015, 0, 0, 0, 1), Qt.matrix4x4(-0.946913, -0.103034, -0.304534, 0.0843454, -0.148039, 0.980592, 0.128543, -0.431656, 0.28538, 0.166802, -0.943788, -0.348786, 0, 0, 0, 1), Qt.matrix4x4(-0.946913, -0.103034, -0.304534, 0.0688403, -0.148039, 0.980592, 0.128543, -0.245581, 0.28538, 0.166802, -0.943788, -0.348545, 0, 0, 0, 1), Qt.matrix4x4(0.968415, 0.0891519, -0.23286, -0.106569, -0.0935545, 0.995583, -0.00790829, -0.450245, 0.231126, 0.0294436, 0.972478, -0.193674, 0, 0, 0, 1), Qt.matrix4x4(0.968415, 0.0891519, -0.23286, -0.0995497, -0.0935545, 0.995583, -0.00790829, -0.265214, 0.231126, 0.0294436, 0.972478, -0.199596, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, 0.0722113, -0.997371, -0.0644774, -0.125518, 0.989556, 0.0708752, -0.646676, 0.992072, 0.124754, 0.0151209, -0.328997, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, 0.0722113, -0.997371, -0.0591142, -0.125518, 0.989556, 0.0708752, -0.444354, 0.992072, 0.124754, 0.0151209, -0.32935, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, 0.0722113, -0.997371, -0.0544081, -0.125518, 0.989556, 0.0708752, -0.258641, 0.992072, 0.124754, 0.0151209, -0.326015, 0, 0, 0, 1), Qt.matrix4x4(-0.946913, -0.103034, -0.304534, 0.0843454, -0.148039, 0.980592, 0.128543, -0.431656, 0.28538, 0.166802, -0.943788, -0.348786, 0, 0, 0, 1), Qt.matrix4x4(-0.946913, -0.103034, -0.304534, 0.0688403, -0.148039, 0.980592, 0.128543, -0.245581, 0.28538, 0.166802, -0.943788, -0.348545, 0, 0, 0, 1), Qt.matrix4x4(0.968415, 0.0891519, -0.23286, -0.106569, -0.0935545, 0.995583, -0.00790829, -0.450245, 0.231126, 0.0294436, 0.972478, -0.193674, 0, 0, 0, 1), Qt.matrix4x4(0.968415, 0.0891519, -0.23286, -0.0995497, -0.0935545, 0.995583, -0.00790829, -0.265214, 0.231126, 0.0294436, 0.972478, -0.199596, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, 0.0722113, -0.997371, -0.0644774, -0.125518, 0.989556, 0.0708752, -0.646676, 0.992072, 0.124754, 0.0151209, -0.328997, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, 0.0722113, -0.997371, -0.0591142, -0.125518, 0.989556, 0.0708752, -0.444354, 0.992072, 0.124754, 0.0151209, -0.32935, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, 0.0722113, -0.997371, -0.0544081, -0.125518, 0.989556, 0.0708752, -0.258641, 0.992072, 0.124754, 0.0151209, -0.326015, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.0853396, 0, 0.999985, 0.00548092, -0.136476, 0, -0.00548092, 0.999985, 0.0426288, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.0853396, 0, 0.999952, 0.00981419, -0.0560958, 0, -0.00981419, 0.999952, -0.0885555, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0853396, 0, 0.999781, 0.0209207, -1.12081, 0, -0.0209207, 0.999781, 0.0241119, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0853396, 0, 0.997787, 0.0664965, -0.656974, 0, -0.0664965, 0.997787, 0.056914, 0, 0, 0, 1), Qt.matrix4x4(-0.946913, 0.103034, 0.304535, -0.0843454, 0.148039, 0.980592, 0.128543, -0.431656, -0.28538, 0.166802, -0.943788, -0.348786, 0, 0, 0, 1), Qt.matrix4x4(-0.946913, 0.103034, 0.304535, -0.0688403, 0.148039, 0.980592, 0.128543, -0.245581, -0.28538, 0.166802, -0.943788, -0.348545, 0, 0, 0, 1), Qt.matrix4x4(0.968415, -0.0891519, 0.23286, 0.106569, 0.0935545, 0.995583, -0.00790829, -0.450245, -0.231126, 0.0294436, 0.972478, -0.193674, 0, 0, 0, 1), Qt.matrix4x4(0.968415, -0.0891519, 0.23286, 0.0995497, 0.0935545, 0.995583, -0.00790829, -0.265215, -0.231126, 0.0294436, 0.972478, -0.199596, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, -0.0722113, 0.997371, 0.0644774, 0.125518, 0.989556, 0.0708752, -0.646676, -0.992072, 0.124754, 0.0151209, -0.328997, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, -0.0722113, 0.997371, 0.0591143, 0.125518, 0.989556, 0.0708752, -0.444354, -0.992072, 0.124754, 0.0151209, -0.32935, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, -0.0722113, 0.997371, 0.0544081, 0.125518, 0.989556, 0.0708752, -0.258642, -0.992072, 0.124754, 0.0151209, -0.326015, 0, 0, 0, 1), Qt.matrix4x4(-0.946913, 0.103034, 0.304535, -0.0843454, 0.148039, 0.980592, 0.128543, -0.431656, -0.28538, 0.166802, -0.943788, -0.348786, 0, 0, 0, 1), Qt.matrix4x4(-0.946913, 0.103034, 0.304535, -0.0688403, 0.148039, 0.980592, 0.128543, -0.245581, -0.28538, 0.166802, -0.943788, -0.348545, 0, 0, 0, 1), Qt.matrix4x4(0.968415, -0.0891519, 0.23286, 0.106569, 0.0935545, 0.995583, -0.00790829, -0.450245, -0.231126, 0.0294436, 0.972478, -0.193674, 0, 0, 0, 1), Qt.matrix4x4(0.968415, -0.0891519, 0.23286, 0.0995497, 0.0935545, 0.995583, -0.00790829, -0.265215, -0.231126, 0.0294436, 0.972478, -0.199596, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, -0.0722113, 0.997371, 0.0644774, 0.125518, 0.989556, 0.0708752, -0.646676, -0.992072, 0.124754, 0.0151209, -0.328997, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, -0.0722113, 0.997371, 0.0591143, 0.125518, 0.989556, 0.0708752, -0.444354, -0.992072, 0.124754, 0.0151209, -0.32935, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, -0.0722113, 0.997371, 0.0544081, 0.125518, 0.989556, 0.0708752, -0.258642, -0.992072, 0.124754, 0.0151209, -0.326015, 0, 0, 0, 1), Qt.matrix4x4(-0.946913, 0.103034, 0.304535, -0.0843454, 0.148039, 0.980592, 0.128543, -0.431656, -0.28538, 0.166802, -0.943788, -0.348786, 0, 0, 0, 1), Qt.matrix4x4(-0.946913, 0.103034, 0.304535, -0.0688403, 0.148039, 0.980592, 0.128543, -0.245581, -0.28538, 0.166802, -0.943788, -0.348545, 0, 0, 0, 1), Qt.matrix4x4(0.968415, -0.0891519, 0.23286, 0.106569, 0.0935545, 0.995583, -0.00790829, -0.450245, -0.231126, 0.0294436, 0.972478, -0.193674, 0, 0, 0, 1), Qt.matrix4x4(0.968415, -0.0891519, 0.23286, 0.0995497, 0.0935545, 0.995583, -0.00790829, -0.265215, -0.231126, 0.0294436, 0.972478, -0.199596, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, -0.0722113, 0.997371, 0.0644774, 0.125518, 0.989556, 0.0708752, -0.646676, -0.992072, 0.124754, 0.0151209, -0.328997, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, -0.0722113, 0.997371, 0.0591143, 0.125518, 0.989556, 0.0708752, -0.444354, -0.992072, 0.124754, 0.0151209, -0.32935, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, -0.0722113, 0.997371, 0.0544081, 0.125518, 0.989556, 0.0708752, -0.258642, -0.992072, 0.124754, 0.0151209, -0.326015, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0853396, 0, 0.999985, 0.00548092, -0.136476, 0, -0.00548092, 0.999985, 0.0426288, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0853396, 0, 0.999952, 0.00981419, -0.0560958, 0, -0.00981419, 0.999952, -0.0885555, 0, 0, 0, 1)]
    }
    PrincipledMaterial {
        id: n00_008_01_Shoes_01_CLOTH__Instance__material
        objectName: "N00_008_01_Shoes_01_CLOTH (Instance)"
        baseColorMap: _18_texture
        roughness: 0.8999999761581421
        normalMap: _1_texture
        emissiveMap: _2_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Mask
        depthDrawMode: PrincipledMaterial.OpaquePrePassDepthDraw
        lighting: PrincipledMaterial.NoLighting
    }
    PrincipledMaterial {
        id: n00_001_02_Bottoms_01_CLOTH__Instance__material
        objectName: "N00_001_02_Bottoms_01_CLOTH (Instance)"
        baseColorMap: _17_texture
        roughness: 0.8999999761581421
        normalMap: _1_texture
        emissiveMap: _2_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Mask
        depthDrawMode: PrincipledMaterial.OpaquePrePassDepthDraw
        lighting: PrincipledMaterial.NoLighting
    }
    PrincipledMaterial {
        id: n00_000_00_HairBack_00_HAIR__Instance__material
        objectName: "N00_000_00_HairBack_00_HAIR (Instance)"
        baseColorMap: _15_texture
        roughness: 0.8999999761581421
        normalMap: _16_texture
        emissiveMap: _2_texture
        emissiveFactor: Qt.vector3d(0.858824, 0.694118, 0.694118)
        alphaMode: PrincipledMaterial.Mask
        depthDrawMode: PrincipledMaterial.OpaquePrePassDepthDraw
        lighting: PrincipledMaterial.NoLighting
    }
    PrincipledMaterial {
        id: n00_007_01_Tops_01_CLOTH_03__Instance__material
        objectName: "N00_007_01_Tops_01_CLOTH_03 (Instance)"
        baseColorMap: _14_texture
        roughness: 0.8999999761581421
        normalMap: _1_texture
        emissiveMap: _2_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Mask
        depthDrawMode: PrincipledMaterial.OpaquePrePassDepthDraw
        lighting: PrincipledMaterial.NoLighting
    }
    PrincipledMaterial {
        id: n00_007_01_Tops_01_CLOTH_02__Instance__material
        objectName: "N00_007_01_Tops_01_CLOTH_02 (Instance)"
        baseColorMap: _13_texture
        roughness: 0.8999999761581421
        normalMap: _1_texture
        emissiveMap: _2_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Mask
        depthDrawMode: PrincipledMaterial.OpaquePrePassDepthDraw
        lighting: PrincipledMaterial.NoLighting
    }
    PrincipledMaterial {
        id: n00_007_01_Tops_01_CLOTH_01__Instance__material
        objectName: "N00_007_01_Tops_01_CLOTH_01 (Instance)"
        baseColorMap: _12_texture
        roughness: 0.8999999761581421
        normalMap: _1_texture
        emissiveMap: _2_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Mask
        depthDrawMode: PrincipledMaterial.OpaquePrePassDepthDraw
        lighting: PrincipledMaterial.NoLighting
    }
    PrincipledMaterial {
        id: n00_000_00_Body_00_SKIN__Instance__material
        objectName: "N00_000_00_Body_00_SKIN (Instance)"
        baseColorMap: _10_texture
        roughness: 0.8999999761581421
        normalMap: _11_texture
        emissiveMap: _2_texture
        alphaMode: PrincipledMaterial.Mask
        depthDrawMode: PrincipledMaterial.OpaquePrePassDepthDraw
        lighting: PrincipledMaterial.NoLighting
    }
    MorphTarget {
        id: fcl_EYE_Joy_L_morphtarget588
        objectName: "Fcl_EYE_Joy_L"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Short_Up_morphtarget624
        objectName: "Fcl_HA_Short_Up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Short_morphtarget623
        objectName: "Fcl_HA_Short"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung3_Low_morphtarget622
        objectName: "Fcl_HA_Fung3_Low"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung3_Up_morphtarget621
        objectName: "Fcl_HA_Fung3_Up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung3_morphtarget620
        objectName: "Fcl_HA_Fung3"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung2_Up_morphtarget619
        objectName: "Fcl_HA_Fung2_Up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung2_Low_morphtarget618
        objectName: "Fcl_HA_Fung2_Low"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung2_morphtarget617
        objectName: "Fcl_HA_Fung2"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung1_Up_morphtarget616
        objectName: "Fcl_HA_Fung1_Up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung1_Low_morphtarget615
        objectName: "Fcl_HA_Fung1_Low"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung1_morphtarget614
        objectName: "Fcl_HA_Fung1"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_A_morphtarget551
        objectName: "Fcl_MTH_A"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung3_morphtarget563
        objectName: "Fcl_HA_Fung3"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung2_Up_morphtarget562
        objectName: "Fcl_HA_Fung2_Up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung2_Low_morphtarget561
        objectName: "Fcl_HA_Fung2_Low"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung2_morphtarget560
        objectName: "Fcl_HA_Fung2"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung1_Up_morphtarget559
        objectName: "Fcl_HA_Fung1_Up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung1_Low_morphtarget558
        objectName: "Fcl_HA_Fung1_Low"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung1_morphtarget557
        objectName: "Fcl_HA_Fung1"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Hide_morphtarget556
        objectName: "Fcl_HA_Hide"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_O_morphtarget555
        objectName: "Fcl_MTH_O"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_E_morphtarget554
        objectName: "Fcl_MTH_E"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_U_morphtarget553
        objectName: "Fcl_MTH_U"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_I_morphtarget552
        objectName: "Fcl_MTH_I"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung3_Up_morphtarget564
        objectName: "Fcl_HA_Fung3_Up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_SkinFung_L_morphtarget550
        objectName: "Fcl_MTH_SkinFung_L"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_SkinFung_R_morphtarget549
        objectName: "Fcl_MTH_SkinFung_R"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_SkinFung_morphtarget548
        objectName: "Fcl_MTH_SkinFung"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Surprised_morphtarget547
        objectName: "Fcl_MTH_Surprised"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Sorrow_morphtarget546
        objectName: "Fcl_MTH_Sorrow"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Joy_morphtarget545
        objectName: "Fcl_MTH_Joy"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Fun_morphtarget544
        objectName: "Fcl_MTH_Fun"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Neutral_morphtarget543
        objectName: "Fcl_MTH_Neutral"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Large_morphtarget542
        objectName: "Fcl_MTH_Large"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Small_morphtarget541
        objectName: "Fcl_MTH_Small"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Angry_morphtarget540
        objectName: "Fcl_MTH_Angry"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_BRW_Fun_morphtarget576
        objectName: "Fcl_BRW_Fun"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Joy_R_morphtarget587
        objectName: "Fcl_EYE_Joy_R"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Joy_morphtarget586
        objectName: "Fcl_EYE_Joy"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Fun_morphtarget585
        objectName: "Fcl_EYE_Fun"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Close_L_morphtarget584
        objectName: "Fcl_EYE_Close_L"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Close_R_morphtarget583
        objectName: "Fcl_EYE_Close_R"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Close_morphtarget582
        objectName: "Fcl_EYE_Close"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Angry_morphtarget581
        objectName: "Fcl_EYE_Angry"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Natural_morphtarget580
        objectName: "Fcl_EYE_Natural"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_BRW_Surprised_morphtarget579
        objectName: "Fcl_BRW_Surprised"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_BRW_Sorrow_morphtarget578
        objectName: "Fcl_BRW_Sorrow"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_BRW_Joy_morphtarget577
        objectName: "Fcl_BRW_Joy"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Down_morphtarget539
        objectName: "Fcl_MTH_Down"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_BRW_Angry_morphtarget575
        objectName: "Fcl_BRW_Angry"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Surprised_morphtarget574
        objectName: "Fcl_ALL_Surprised"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Sorrow_morphtarget573
        objectName: "Fcl_ALL_Sorrow"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Joy_morphtarget572
        objectName: "Fcl_ALL_Joy"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Fun_morphtarget571
        objectName: "Fcl_ALL_Fun"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Angry_morphtarget570
        objectName: "Fcl_ALL_Angry"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Neutral_morphtarget569
        objectName: "Fcl_ALL_Neutral"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Short_Low_morphtarget568
        objectName: "Fcl_HA_Short_Low"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Short_Up_morphtarget567
        objectName: "Fcl_HA_Short_Up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Short_morphtarget566
        objectName: "Fcl_HA_Short"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung3_Low_morphtarget565
        objectName: "Fcl_HA_Fung3_Low"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Joy_morphtarget287
        objectName: "Fcl_ALL_Joy"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Fun_morphtarget300
        objectName: "Fcl_EYE_Fun"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Close_L_morphtarget299
        objectName: "Fcl_EYE_Close_L"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Close_R_morphtarget298
        objectName: "Fcl_EYE_Close_R"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Close_morphtarget297
        objectName: "Fcl_EYE_Close"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Angry_morphtarget296
        objectName: "Fcl_EYE_Angry"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Natural_morphtarget295
        objectName: "Fcl_EYE_Natural"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_BRW_Surprised_morphtarget294
        objectName: "Fcl_BRW_Surprised"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_BRW_Sorrow_morphtarget293
        objectName: "Fcl_BRW_Sorrow"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_BRW_Joy_morphtarget292
        objectName: "Fcl_BRW_Joy"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_BRW_Fun_morphtarget291
        objectName: "Fcl_BRW_Fun"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_BRW_Angry_morphtarget290
        objectName: "Fcl_BRW_Angry"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Surprised_morphtarget289
        objectName: "Fcl_ALL_Surprised"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Sorrow_morphtarget288
        objectName: "Fcl_ALL_Sorrow"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Joy_morphtarget301
        objectName: "Fcl_EYE_Joy"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Fun_morphtarget286
        objectName: "Fcl_ALL_Fun"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Angry_morphtarget285
        objectName: "Fcl_ALL_Angry"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Neutral_morphtarget284
        objectName: "Fcl_ALL_Neutral"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Short_Low_morphtarget283
        objectName: "Fcl_HA_Short_Low"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Short_Up_morphtarget282
        objectName: "Fcl_HA_Short_Up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Short_morphtarget281
        objectName: "Fcl_HA_Short"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung3_Low_morphtarget280
        objectName: "Fcl_HA_Fung3_Low"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung3_Up_morphtarget279
        objectName: "Fcl_HA_Fung3_Up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung3_morphtarget278
        objectName: "Fcl_HA_Fung3"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung2_Up_morphtarget277
        objectName: "Fcl_HA_Fung2_Up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung2_Low_morphtarget276
        objectName: "Fcl_HA_Fung2_Low"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung2_morphtarget275
        objectName: "Fcl_HA_Fung2"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung1_Up_morphtarget274
        objectName: "Fcl_HA_Fung1_Up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Neutral_morphtarget315
        objectName: "Fcl_MTH_Neutral"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Hide_morphtarget328
        objectName: "Fcl_HA_Hide"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_O_morphtarget327
        objectName: "Fcl_MTH_O"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_E_morphtarget326
        objectName: "Fcl_MTH_E"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_U_morphtarget325
        objectName: "Fcl_MTH_U"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_I_morphtarget324
        objectName: "Fcl_MTH_I"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_A_morphtarget323
        objectName: "Fcl_MTH_A"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_SkinFung_L_morphtarget322
        objectName: "Fcl_MTH_SkinFung_L"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_SkinFung_R_morphtarget321
        objectName: "Fcl_MTH_SkinFung_R"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_SkinFung_morphtarget320
        objectName: "Fcl_MTH_SkinFung"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Surprised_morphtarget319
        objectName: "Fcl_MTH_Surprised"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Sorrow_morphtarget318
        objectName: "Fcl_MTH_Sorrow"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Joy_morphtarget317
        objectName: "Fcl_MTH_Joy"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Fun_morphtarget316
        objectName: "Fcl_MTH_Fun"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung1_Low_morphtarget273
        objectName: "Fcl_HA_Fung1_Low"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Large_morphtarget314
        objectName: "Fcl_MTH_Large"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Small_morphtarget313
        objectName: "Fcl_MTH_Small"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Angry_morphtarget312
        objectName: "Fcl_MTH_Angry"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Down_morphtarget311
        objectName: "Fcl_MTH_Down"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Up_morphtarget310
        objectName: "Fcl_MTH_Up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Close_morphtarget309
        objectName: "Fcl_MTH_Close"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Highlight_Hide_morphtarget308
        objectName: "Fcl_EYE_Highlight_Hide"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Iris_Hide_morphtarget307
        objectName: "Fcl_EYE_Iris_Hide"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Spread_morphtarget306
        objectName: "Fcl_EYE_Spread"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Surprised_morphtarget305
        objectName: "Fcl_EYE_Surprised"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Sorrow_morphtarget304
        objectName: "Fcl_EYE_Sorrow"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Joy_L_morphtarget303
        objectName: "Fcl_EYE_Joy_L"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Joy_R_morphtarget302
        objectName: "Fcl_EYE_Joy_R"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Surprised_morphtarget232
        objectName: "Fcl_ALL_Surprised"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Joy_R_morphtarget245
        objectName: "Fcl_EYE_Joy_R"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Joy_morphtarget244
        objectName: "Fcl_EYE_Joy"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Fun_morphtarget243
        objectName: "Fcl_EYE_Fun"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Close_L_morphtarget242
        objectName: "Fcl_EYE_Close_L"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Close_R_morphtarget241
        objectName: "Fcl_EYE_Close_R"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Close_morphtarget240
        objectName: "Fcl_EYE_Close"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Angry_morphtarget239
        objectName: "Fcl_EYE_Angry"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Natural_morphtarget238
        objectName: "Fcl_EYE_Natural"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_BRW_Surprised_morphtarget237
        objectName: "Fcl_BRW_Surprised"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_BRW_Sorrow_morphtarget236
        objectName: "Fcl_BRW_Sorrow"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_BRW_Joy_morphtarget235
        objectName: "Fcl_BRW_Joy"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_BRW_Fun_morphtarget234
        objectName: "Fcl_BRW_Fun"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_BRW_Angry_morphtarget233
        objectName: "Fcl_BRW_Angry"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Joy_L_morphtarget246
        objectName: "Fcl_EYE_Joy_L"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Sorrow_morphtarget231
        objectName: "Fcl_ALL_Sorrow"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Joy_morphtarget230
        objectName: "Fcl_ALL_Joy"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Fun_morphtarget229
        objectName: "Fcl_ALL_Fun"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Angry_morphtarget228
        objectName: "Fcl_ALL_Angry"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Neutral_morphtarget227
        objectName: "Fcl_ALL_Neutral"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    Skin {
        id: skin226
        joints: [root, j_Bip_C_Hips, j_Bip_C_Spine, j_Bip_C_Chest, j_Bip_C_UpperChest, j_Sec_L_Bust1, j_Sec_L_Bust2, j_Sec_R_Bust1, j_Sec_R_Bust2, j_Bip_C_Neck, j_Bip_C_Head, j_Adj_L_FaceEye, j_Adj_R_FaceEye, j_Sec_Hair1_01, j_Sec_Hair2_01, j_Sec_Hair1_02, j_Sec_Hair2_02, j_Sec_Hair1_03, j_Sec_Hair2_03, j_Sec_Hair3_03, j_Sec_Hair1_04, j_Sec_Hair2_04, j_Sec_Hair3_04, j_Sec_Hair1_05, j_Sec_Hair2_05, j_Sec_Hair3_05, j_Sec_Hair1_06, j_Sec_Hair2_06, j_Sec_Hair3_06, j_Sec_Hair1_07, j_Sec_Hair2_07, j_Sec_Hair3_07, j_Sec_Hair1_08, j_Sec_Hair2_08, j_Sec_Hair3_08, j_Sec_Hair1_09, j_Sec_Hair2_09, j_Sec_Hair3_09, j_Sec_Hair1_10, j_Sec_Hair2_10, j_Sec_Hair3_10, j_Sec_Hair1_11, j_Sec_Hair2_11, j_Sec_Hair3_11, j_Sec_Hair1_12, j_Sec_Hair2_12, j_Sec_Hair3_12, j_Sec_Hair1_13, j_Sec_Hair2_13, j_Sec_Hair3_13, j_Sec_Hair1_14, j_Sec_Hair2_14, j_Sec_Hair3_14, j_Sec_Hair1_15, j_Sec_Hair2_15, j_Sec_Hair3_15, j_Sec_Hair1_16, j_Sec_Hair2_16, j_Sec_Hair3_16, j_Sec_Hair1_17, j_Sec_Hair2_17, j_Sec_Hair3_17, j_Sec_Hair1_18, j_Sec_Hair2_18, j_Sec_Hair3_18, j_Sec_Hair1_19, j_Sec_Hair2_19, j_Sec_Hair1_20, j_Sec_Hair2_20, j_Bip_L_Shoulder, j_Bip_L_UpperArm, j_Bip_L_LowerArm, j_Bip_L_Hand, j_Bip_L_Index1, j_Bip_L_Index2, j_Bip_L_Index3, j_Bip_L_Little1, j_Bip_L_Little2, j_Bip_L_Little3, j_Bip_L_Middle1, j_Bip_L_Middle2, j_Bip_L_Middle3, j_Bip_L_Ring1, j_Bip_L_Ring2, j_Bip_L_Ring3, j_Bip_L_Thumb1, j_Bip_L_Thumb2, j_Bip_L_Thumb3, j_Bip_R_Shoulder, j_Bip_R_UpperArm, j_Bip_R_LowerArm, j_Bip_R_Hand, j_Bip_R_Index1, j_Bip_R_Index2, j_Bip_R_Index3, j_Bip_R_Little1, j_Bip_R_Little2, j_Bip_R_Little3, j_Bip_R_Middle1, j_Bip_R_Middle2, j_Bip_R_Middle3, j_Bip_R_Ring1, j_Bip_R_Ring2, j_Bip_R_Ring3, j_Bip_R_Thumb1, j_Bip_R_Thumb2, j_Bip_R_Thumb3, j_Bip_L_UpperLeg, j_Bip_L_LowerLeg, j_Sec_L_CoatSkirtBack_01, j_Sec_L_CoatSkirtBack_end_01, j_Sec_L_CoatSkirtFront_01, j_Sec_L_CoatSkirtFront_end_01, j_Sec_L_CoatSkirtSide1_01, j_Sec_L_CoatSkirtSide2_01, j_Sec_L_CoatSkirtSide2_end_01, j_Sec_L_CoatSkirtBack_02, j_Sec_L_CoatSkirtBack_end_02, j_Sec_L_CoatSkirtFront_02, j_Sec_L_CoatSkirtFront_end_02, j_Sec_L_CoatSkirtSide1_02, j_Sec_L_CoatSkirtSide2_02, j_Sec_L_CoatSkirtSide2_end_02, j_Sec_L_CoatSkirtBack_03, j_Sec_L_CoatSkirtBack_end_03, j_Sec_L_CoatSkirtFront_03, j_Sec_L_CoatSkirtFront_end_03, j_Sec_L_CoatSkirtSide1_03, j_Sec_L_CoatSkirtSide2_03, j_Sec_L_CoatSkirtSide2_end_03, j_Bip_L_Foot, j_Bip_L_ToeBase, j_Bip_R_UpperLeg, j_Bip_R_LowerLeg, j_Sec_R_CoatSkirtBack_01, j_Sec_R_CoatSkirtBack_end_01, j_Sec_R_CoatSkirtFront_01, j_Sec_R_CoatSkirtFront_end_01, j_Sec_R_CoatSkirtSide1_01, j_Sec_R_CoatSkirtSide2_01, j_Sec_R_CoatSkirtSide2_end_01, j_Sec_R_CoatSkirtBack_02, j_Sec_R_CoatSkirtBack_end_02, j_Sec_R_CoatSkirtFront_02, j_Sec_R_CoatSkirtFront_end_02, j_Sec_R_CoatSkirtSide1_02, j_Sec_R_CoatSkirtSide2_02, j_Sec_R_CoatSkirtSide2_end_02, j_Sec_R_CoatSkirtBack_03, j_Sec_R_CoatSkirtBack_end_03, j_Sec_R_CoatSkirtFront_03, j_Sec_R_CoatSkirtFront_end_03, j_Sec_R_CoatSkirtSide1_03, j_Sec_R_CoatSkirtSide2_03, j_Sec_R_CoatSkirtSide2_end_03, j_Bip_R_Foot, j_Bip_R_ToeBase]
        inverseBindPoses: [Qt.matrix4x4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0, 0, 0.992088, 0.125548, -1.15843, 0, -0.125548, 0.992088, 0.142986, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 7.11265e-32, 0, 0.98855, 0.150896, -1.21633, 0, -0.150896, 0.98855, 0.167343, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -2.40917e-17, 0, 0.992589, -0.121518, -1.34611, 0, 0.121518, 0.992589, -0.186612, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 1.06822e-17, 0, 0.943357, -0.33178, -1.39816, 0, 0.33178, 0.943357, -0.496668, 0, 0, 0, 1), Qt.matrix4x4(0.890608, -0.047434, -0.45229, 0.0537904, -0.00726396, 0.992935, -0.118438, -1.45443, 0.454713, 0.108767, 0.883972, -0.263178, 0, 0, 0, 1), Qt.matrix4x4(0.890608, -0.047434, -0.45229, 0.0538004, -0.00726397, 0.992935, -0.118438, -1.45443, 0.454713, 0.108767, 0.883972, -0.264455, 0, 0, 0, 1), Qt.matrix4x4(0.890608, 0.047434, 0.45229, -0.0537904, 0.00726396, 0.992935, -0.118438, -1.45443, -0.454713, 0.108767, 0.883972, -0.263178, 0, 0, 0, 1), Qt.matrix4x4(0.890608, 0.047434, 0.45229, -0.0538004, 0.00726397, 0.992935, -0.118438, -1.45443, -0.454713, 0.108767, 0.883972, -0.264455, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 1.19815e-16, 0, 0.992864, 0.119252, -1.62085, 0, -0.119252, 0.992864, 0.234831, 0, 0, 0, 1), Qt.matrix4x4(1, 5.25951e-08, -4.37914e-07, -1.03702e-07, -4.78589e-08, 0.999942, 0.0108084, -1.73272, 4.38457e-07, -0.0108084, 0.999942, 0.0471112, 0, 0, 0, 1), Qt.matrix4x4(0.930442, -0.000646281, -0.366439, -0.01619, 0.0198007, 0.998626, 0.0485156, -1.79385, 0.365904, -0.0523967, 0.929176, 0.0938457, 0, 0, 0, 1), Qt.matrix4x4(0.930442, 0.000646404, 0.366438, 0.0161898, -0.0198008, 0.998626, 0.0485155, -1.79385, -0.365903, -0.0523967, 0.929177, 0.0938458, 0, 0, 0, 1), Qt.matrix4x4(-0.401627, 0.844586, -0.354076, -1.60455, -0.915804, -0.370394, 0.155281, 0.580047, 4.61936e-07, 0.386629, 0.922235, -0.692951, 0, 0, 0, 1), Qt.matrix4x4(-0.401627, 0.844586, -0.354076, -1.6044, -0.915803, -0.370394, 0.155281, 0.529659, 4.32134e-07, 0.386629, 0.922235, -0.692952, 0, 0, 0, 1), Qt.matrix4x4(-0.600142, -0.781958, 0.168435, 1.51148, 0.799893, -0.586686, 0.126372, 0.994297, 4.02331e-07, 0.210571, 0.977578, -0.369484, 0, 0, 0, 1), Qt.matrix4x4(-0.600143, -0.781958, 0.168435, 1.51134, 0.799893, -0.586686, 0.126373, 0.956455, 4.02331e-07, 0.210571, 0.977578, -0.369484, 0, 0, 0, 1), Qt.matrix4x4(-0.985997, -0.165302, 0.0220353, 0.21142, 0.166764, -0.977352, 0.130281, 1.77766, 5.48549e-07, 0.132131, 0.991232, -0.272557, 0, 0, 0, 1), Qt.matrix4x4(-0.854811, -0.419369, 0.305662, 0.662282, 0.51894, -0.690794, 0.503493, 1.24962, 8.9407e-08, 0.589011, 0.808125, -1.07652, 0, 0, 0, 1), Qt.matrix4x4(-0.854811, -0.419368, 0.305661, 0.662165, 0.51894, -0.690794, 0.503493, 1.21591, 2.5332e-07, 0.589011, 0.808125, -1.07652, 0, 0, 0, 1), Qt.matrix4x4(-0.993274, 0.115088, -0.0127168, -0.12231, -0.115789, -0.987266, 0.10909, 1.80366, 8.5216e-08, 0.109829, 0.99395, -0.229557, 0, 0, 0, 1), Qt.matrix4x4(-0.811412, 0.488784, -0.32047, -0.794653, -0.584475, -0.678567, 0.444901, 1.24595, 1.49012e-07, 0.548305, 0.836278, -1.00751, 0, 0, 0, 1), Qt.matrix4x4(-0.811412, 0.488784, -0.32047, -0.794526, -0.584475, -0.678567, 0.444901, 1.21206, 1.49012e-07, 0.548305, 0.836278, -1.00751, 0, 0, 0, 1), Qt.matrix4x4(-0.999998, -0.00250177, 0.000233629, 0.00708628, 0.00251265, -0.995682, 0.0928101, 1.85633, 4.30606e-07, 0.0928105, 0.995684, -0.255647, 0, 0, 0, 1), Qt.matrix4x4(-0.999817, 0.0187861, 0.00343314, -0.032183, -0.0190973, -0.983532, -0.179718, 1.81701, 4.0303e-07, -0.17975, 0.983712, 0.244623, 0, 0, 0, 1), Qt.matrix4x4(-0.999817, 0.0187861, 0.00343314, -0.0321769, -0.0190973, -0.983532, -0.179718, 1.77637, 4.03263e-07, -0.17975, 0.983712, 0.244623, 0, 0, 0, 1), Qt.matrix4x4(-0.990447, 0.13789, 0.000864603, -0.300622, -0.137893, -0.990428, -0.00620702, 1.84141, 4.40748e-07, -0.00626695, 0.99998, -0.0678957, 0, 0, 0, 1), Qt.matrix4x4(-0.994168, -0.106954, -0.0138453, 0.149302, 0.107847, -0.985941, -0.127632, 1.82296, 1.6205e-07, -0.128381, 0.991725, 0.156645, 0, 0, 0, 1), Qt.matrix4x4(-0.994168, -0.106954, -0.0138453, 0.149275, 0.107847, -0.985941, -0.127632, 1.79145, 1.62516e-07, -0.128381, 0.991725, 0.156645, 0, 0, 0, 1), Qt.matrix4x4(-0.999996, -0.00305625, 6.97165e-05, 0.0850229, 0.00305705, -0.999739, 0.0226584, 1.8449, 4.48639e-07, 0.0226585, 0.999743, -0.0889094, 0, 0, 0, 1), Qt.matrix4x4(-0.921469, 0.386318, -0.0406877, -0.624666, -0.388454, -0.9164, 0.0965178, 1.68642, 3.74392e-07, 0.104743, 0.994499, -0.237365, 0, 0, 0, 1), Qt.matrix4x4(-0.921469, 0.386317, -0.0406876, -0.624568, -0.388454, -0.9164, 0.0965178, 1.6516, 3.76254e-07, 0.104743, 0.994499, -0.237365, 0, 0, 0, 1), Qt.matrix4x4(-0.990972, -0.133957, 0.00545571, 0.29241, 0.134068, -0.990151, 0.0403232, 1.8392, 3.87197e-07, 0.0406906, 0.999172, -0.149201, 0, 0, 0, 1), Qt.matrix4x4(-0.991699, 0.128251, 0.00925774, -0.188578, -0.128584, -0.989125, -0.0713963, 1.82481, 4.45172e-07, -0.071994, 0.997405, 0.0575144, 0, 0, 0, 1), Qt.matrix4x4(-0.991699, 0.128251, 0.00925774, -0.188545, -0.128584, -0.989125, -0.0713963, 1.79152, 4.45172e-07, -0.071994, 0.997405, 0.0575144, 0, 0, 0, 1), Qt.matrix4x4(-0.999997, -0.00242874, -2.68141e-05, -0.0760716, 0.00242889, -0.999935, -0.0111994, 1.83976, 3.88042e-07, -0.0111994, 0.999937, -0.0265954, 0, 0, 0, 1), Qt.matrix4x4(-0.896194, -0.440791, 0.0504198, 0.721681, 0.443665, -0.890388, 0.101846, 1.63914, 4.26546e-07, 0.113643, 0.993522, -0.251784, 0, 0, 0, 1), Qt.matrix4x4(-0.896193, -0.440791, 0.0504198, 0.721579, 0.443665, -0.890387, 0.101846, 1.60636, 4.22821e-07, 0.113643, 0.993522, -0.251784, 0, 0, 0, 1), Qt.matrix4x4(-0.748844, -0.599564, -0.282411, 1.19253, 0.662747, -0.677453, -0.3191, 1.25373, 4.47035e-07, -0.426123, 0.904665, 0.726603, 0, 0, 0, 1), Qt.matrix4x4(-0.756544, -0.239371, -0.608558, 0.549724, 0.653943, -0.276927, -0.704038, 0.499891, 3.27826e-07, -0.930598, 0.366042, 1.69381, 0, 0, 0, 1), Qt.matrix4x4(-0.756544, -0.239371, -0.608558, 0.549563, 0.653943, -0.276927, -0.704038, 0.458547, 2.38419e-07, -0.930598, 0.366042, 1.69381, 0, 0, 0, 1), Qt.matrix4x4(-0.40515, 0.733052, 0.546341, -1.43852, -0.914251, -0.324853, -0.24211, 0.609798, 1.2219e-06, -0.597584, 0.801806, 1.04589, 0, 0, 0, 1), Qt.matrix4x4(0.616, 0.143257, -0.774611, -0.164211, -0.787746, 0.112024, -0.605728, -0.203603, 2.08616e-07, 0.983325, 0.181857, -1.84998, 0, 0, 0, 1), Qt.matrix4x4(0.616, 0.143257, -0.774611, -0.164354, -0.787746, 0.112024, -0.605728, -0.240941, -1.78814e-07, 0.983325, 0.181857, -1.84998, 0, 0, 0, 1), Qt.matrix4x4(-0.898292, -0.436803, 0.0476737, 0.711516, 0.439397, -0.892989, 0.0974619, 1.5937, 3.96743e-07, 0.108497, 0.994097, -0.122928, 0, 0, 0, 1), Qt.matrix4x4(-0.937259, 0.31662, 0.145933, -0.572381, -0.348633, -0.851197, -0.392324, 1.41582, 5.1409e-07, -0.418586, 0.908177, 0.772925, 0, 0, 0, 1), Qt.matrix4x4(-0.937259, 0.31662, 0.145933, -0.572282, -0.348633, -0.851198, -0.392324, 1.3771, 4.84288e-07, -0.418586, 0.908177, 0.772925, 0, 0, 0, 1), Qt.matrix4x4(-1, 0.00150124, -0.000601497, 0.00402469, -0.00161725, -0.928177, 0.372138, 1.64728, 3.71307e-07, 0.372139, 0.928177, -0.557532, 0, 0, 0, 1), Qt.matrix4x4(-0.976987, 0.206422, 0.0537201, -0.341307, -0.213298, -0.945494, -0.246057, 1.59443, 4.26546e-07, -0.251852, 0.967766, 0.510678, 0, 0, 0, 1), Qt.matrix4x4(-0.976987, 0.206422, 0.0537201, -0.341254, -0.213298, -0.945494, -0.246057, 1.56255, 4.26546e-07, -0.251852, 0.967766, 0.510678, 0, 0, 0, 1), Qt.matrix4x4(-0.932631, 0.355517, -0.0617019, -0.569219, -0.360831, -0.918895, 0.15948, 1.63296, 3.94881e-07, 0.171, 0.985271, -0.232109, 0, 0, 0, 1), Qt.matrix4x4(-0.959165, -0.247255, -0.137366, 0.456985, 0.282851, -0.838456, -0.465819, 1.39102, 7.00355e-07, -0.485651, 0.874153, 0.882674, 0, 0, 0, 1), Qt.matrix4x4(-0.959164, -0.247256, -0.137366, 0.456908, 0.282851, -0.838456, -0.465819, 1.35463, 8.71718e-07, -0.485652, 0.874153, 0.882674, 0, 0, 0, 1), Qt.matrix4x4(-0.979643, -0.20021, -0.0146787, 0.473582, 0.200747, -0.977021, -0.0716341, 1.78643, 4.10248e-07, -0.0731226, 0.997323, 0.139852, 0, 0, 0, 1), Qt.matrix4x4(-0.809424, -0.580181, 0.0906799, 1.1431, 0.587225, -0.799715, 0.124991, 1.38256, 4.76837e-07, 0.15442, 0.988005, -0.272276, 0, 0, 0, 1), Qt.matrix4x4(-0.809424, -0.580181, 0.0906799, 1.14295, 0.587225, -0.799715, 0.124991, 1.34292, 4.5076e-07, 0.154421, 0.988005, -0.272276, 0, 0, 0, 1), Qt.matrix4x4(-0.89311, 0.429009, 0.135301, -0.882946, -0.449839, -0.851754, -0.268626, 1.51623, 5.58794e-07, -0.300776, 0.953695, 0.555618, 0, 0, 0, 1), Qt.matrix4x4(-0.745505, 0.449543, 0.49207, -0.898775, -0.6665, -0.502831, -0.550398, 0.826918, 6.10948e-07, -0.73829, 0.674484, 1.34619, 0, 0, 0, 1), Qt.matrix4x4(-0.745505, 0.449543, 0.49207, -0.898666, -0.6665, -0.502831, -0.550398, 0.799134, 6.10948e-07, -0.73829, 0.674484, 1.34619, 0, 0, 0, 1), Qt.matrix4x4(-0.957716, -0.279747, 0.0672574, 0.428719, 0.287719, -0.931181, 0.223875, 1.65339, 4.76837e-07, 0.23376, 0.972294, -0.370377, 0, 0, 0, 1), Qt.matrix4x4(-0.932306, 0.281236, -0.227407, -0.547086, -0.361673, -0.724958, 0.5862, 1.24866, 8.9407e-08, 0.628764, 0.777597, -1.05805, 0, 0, 0, 1), Qt.matrix4x4(-0.932306, 0.281237, -0.227407, -0.547027, -0.361674, -0.724958, 0.586199, 1.22619, 3.35276e-07, 0.628764, 0.777597, -1.05805, 0, 0, 0, 1), Qt.matrix4x4(-0.974261, 0.207329, -0.0884997, -0.302234, -0.225427, -0.896042, 0.382483, 1.59098, 3.7998e-07, 0.392589, 0.919714, -0.653434, 0, 0, 0, 1), Qt.matrix4x4(-0.964282, -0.149166, 0.218886, 0.318595, 0.26488, -0.543029, 0.796842, 0.939066, 1.49012e-08, 0.826359, 0.563144, -1.40907, 0, 0, 0, 1), Qt.matrix4x4(-0.964282, -0.149166, 0.218886, 0.318544, 0.26488, -0.543029, 0.796842, 0.91385, -2.23517e-08, 0.826359, 0.563144, -1.40907, 0, 0, 0, 1), Qt.matrix4x4(-0.809935, -0.208669, 0.548145, 0.422721, 0.58652, -0.288154, 0.756943, 0.567989, -5.0664e-07, 0.934572, 0.355774, -1.83579, 0, 0, 0, 1), Qt.matrix4x4(-0.809935, -0.208669, 0.548145, 0.422479, 0.58652, -0.288154, 0.756943, 0.502968, -5.06639e-07, 0.934572, 0.355774, -1.83579, 0, 0, 0, 1), Qt.matrix4x4(-0.419282, 0.716482, -0.557544, -1.41669, -0.907856, -0.330898, 0.257496, 0.65247, 6.55651e-07, 0.614133, 0.789202, -1.19947, 0, 0, 0, 1), Qt.matrix4x4(-0.419283, 0.716482, -0.557544, -1.41654, -0.907855, -0.330899, 0.257496, 0.601311, 3.27826e-07, 0.614133, 0.789202, -1.19947, 0, 0, 0, 1), Qt.matrix4x4(0.990027, -0.140878, 3.88206e-09, 0.201676, 0.140878, 0.990027, 3.77144e-08, -1.59389, -9.15645e-09, -3.67914e-08, 1, 0.0301292, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.134485, 0, 1, 0, -1.59012, 0, 0, 1, 0.0301292, 0, 0, 0, 1), Qt.matrix4x4(0.999999, 2.70291e-08, 0.00169146, -0.367231, -2.71817e-08, 1, 9.02343e-08, -1.59012, -0.00169146, -9.02802e-08, 0.999999, 0.0307704, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.618621, 0, 1, 0, -1.59012, 0, 0, 1, 0.0296694, 0, 0, 0, 1), Qt.matrix4x4(0.999811, -1.77738e-09, -0.0194199, -0.69138, 2.64541e-09, 1, 4.4672e-08, -1.59869, 0.0194199, -4.4715e-08, 0.999811, -0.00657868, 0, 0, 0, 1), Qt.matrix4x4(0.998841, -0.0288736, -0.0385161, -0.681619, 0.0288734, 0.999583, -0.000560868, -1.61905, 0.0385163, -0.000551876, 0.999258, -0.019576, 0, 0, 0, 1), Qt.matrix4x4(0.99884, -0.0347321, -0.0333433, -0.694973, 0.0347257, 0.999397, -0.000771367, -1.62312, 0.0333499, -0.000387397, 0.999444, -0.0159173, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.686508, 0, 1, 0, -1.59869, 0, 0, 1, 0.0635363, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.721444, 0, 1, 0, -1.59869, 0, 0, 1, 0.0635363, 0, 0, 0, 1), Qt.matrix4x4(0.999695, 0.0155363, 0.0192181, -0.764968, -0.0155363, 0.999879, -0.000149271, -1.58698, -0.0192181, -0.000149353, 0.999815, 0.0780145, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.692368, 0, 1, 0, -1.59869, 0, 0, 1, 0.0272933, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.733542, 0, 1, 0, -1.59869, 0, 0, 1, 0.0272933, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.758942, 0, 1, 0, -1.59869, 0, 0, 1, 0.0272933, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.691528, 0, 1, 0, -1.59869, 0, 0, 1, 0.0454424, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.729722, 0, 1, 0, -1.59869, 0, 0, 1, 0.0454424, 0, 0, 0, 1), Qt.matrix4x4(0.999661, -0.012432, -0.0228667, -0.732668, 0.012432, 0.999922, -0.00014206, -1.60792, 0.0228667, -0.000142268, 0.999738, 0.0284629, 0, 0, 0, 1), Qt.matrix4x4(0.759128, -0.0442635, 0.649435, -0.395481, -0.6499, -0.107936, 0.752316, 0.583344, 0.0367976, -0.993172, -0.110704, 1.54358, 0, 0, 0, 1), Qt.matrix4x4(0.787202, -0.0338466, 0.615765, -0.482427, -0.615327, -0.109564, 0.78062, 0.561206, 0.0410442, -0.993403, -0.107076, 1.54111, 0, 0, 0, 1), Qt.matrix4x4(0.735822, -0.0584441, 0.674648, -0.443402, -0.676539, -0.106614, 0.728648, 0.600227, 0.0293419, -0.992581, -0.117989, 1.54839, 0, 0, 0, 1), Qt.matrix4x4(0.990027, 0.140878, -3.88206e-09, -0.201676, -0.140878, 0.990027, 3.77144e-08, -1.59389, 9.15645e-09, -3.67914e-08, 1, 0.0301292, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.134485, 0, 1, 0, -1.59012, 0, 0, 1, 0.0301292, 0, 0, 0, 1), Qt.matrix4x4(0.999999, -2.70291e-08, -0.00169146, 0.367231, 2.71817e-08, 1, 9.02343e-08, -1.59012, 0.00169146, -9.02802e-08, 0.999999, 0.0307704, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.618621, 0, 1, 0, -1.59012, 0, 0, 1, 0.0296694, 0, 0, 0, 1), Qt.matrix4x4(0.999811, 1.77738e-09, 0.0194199, 0.69138, -2.64541e-09, 1, 4.4672e-08, -1.59869, -0.0194199, -4.4715e-08, 0.999811, -0.00657868, 0, 0, 0, 1), Qt.matrix4x4(0.998841, 0.0288736, 0.0385161, 0.681619, -0.0288734, 0.999583, -0.000560868, -1.61905, -0.0385163, -0.000551876, 0.999258, -0.019576, 0, 0, 0, 1), Qt.matrix4x4(0.99884, 0.0347321, 0.0333433, 0.694973, -0.0347257, 0.999397, -0.000771367, -1.62312, -0.0333499, -0.000387397, 0.999444, -0.0159173, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.686508, 0, 1, 0, -1.59869, 0, 0, 1, 0.0635363, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.721444, 0, 1, 0, -1.59869, 0, 0, 1, 0.0635363, 0, 0, 0, 1), Qt.matrix4x4(0.999695, -0.0155363, -0.0192181, 0.764968, 0.0155363, 0.999879, -0.000149271, -1.58698, 0.0192181, -0.000149353, 0.999815, 0.0780145, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.692368, 0, 1, 0, -1.59869, 0, 0, 1, 0.0272933, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.733542, 0, 1, 0, -1.59869, 0, 0, 1, 0.0272933, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.758942, 0, 1, 0, -1.59869, 0, 0, 1, 0.0272933, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.691528, 0, 1, 0, -1.59869, 0, 0, 1, 0.0454424, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.729722, 0, 1, 0, -1.59869, 0, 0, 1, 0.0454424, 0, 0, 0, 1), Qt.matrix4x4(0.999661, 0.012432, 0.0228667, 0.732668, -0.012432, 0.999922, -0.00014206, -1.60792, -0.0228667, -0.000142268, 0.999738, 0.0284629, 0, 0, 0, 1), Qt.matrix4x4(0.759128, 0.0442635, -0.649435, 0.395481, 0.6499, -0.107936, 0.752316, 0.583344, -0.0367976, -0.993172, -0.110704, 1.54358, 0, 0, 0, 1), Qt.matrix4x4(0.787202, 0.0338466, -0.615765, 0.482427, 0.615327, -0.109564, 0.78062, 0.561206, -0.0410442, -0.993403, -0.107076, 1.54111, 0, 0, 0, 1), Qt.matrix4x4(0.735822, 0.0584441, -0.674648, 0.443402, 0.676539, -0.106614, 0.728648, 0.600227, -0.0293419, -0.992581, -0.117989, 1.54839, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.0853396, 0, 0.999781, 0.0209207, -1.12081, 0, -0.0209207, 0.999781, 0.0241119, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.0853396, 0, 0.997787, 0.0664965, -0.656974, 0, -0.0664965, 0.997787, 0.056914, 0, 0, 0, 1), Qt.matrix4x4(-0.946913, -0.103034, -0.304534, 0.0843454, -0.148039, 0.980592, 0.128543, -0.431656, 0.28538, 0.166802, -0.943788, -0.348786, 0, 0, 0, 1), Qt.matrix4x4(-0.946913, -0.103034, -0.304534, 0.0688403, -0.148039, 0.980592, 0.128543, -0.245581, 0.28538, 0.166802, -0.943788, -0.348545, 0, 0, 0, 1), Qt.matrix4x4(0.968415, 0.0891519, -0.23286, -0.106569, -0.0935545, 0.995583, -0.00790829, -0.450245, 0.231126, 0.0294436, 0.972478, -0.193674, 0, 0, 0, 1), Qt.matrix4x4(0.968415, 0.0891519, -0.23286, -0.0995497, -0.0935545, 0.995583, -0.00790829, -0.265214, 0.231126, 0.0294436, 0.972478, -0.199596, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, 0.0722113, -0.997371, -0.0644774, -0.125518, 0.989556, 0.0708752, -0.646676, 0.992072, 0.124754, 0.0151209, -0.328997, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, 0.0722113, -0.997371, -0.0591142, -0.125518, 0.989556, 0.0708752, -0.444354, 0.992072, 0.124754, 0.0151209, -0.32935, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, 0.0722113, -0.997371, -0.0544081, -0.125518, 0.989556, 0.0708752, -0.258641, 0.992072, 0.124754, 0.0151209, -0.326015, 0, 0, 0, 1), Qt.matrix4x4(-0.946913, -0.103034, -0.304534, 0.0843454, -0.148039, 0.980592, 0.128543, -0.431656, 0.28538, 0.166802, -0.943788, -0.348786, 0, 0, 0, 1), Qt.matrix4x4(-0.946913, -0.103034, -0.304534, 0.0688403, -0.148039, 0.980592, 0.128543, -0.245581, 0.28538, 0.166802, -0.943788, -0.348545, 0, 0, 0, 1), Qt.matrix4x4(0.968415, 0.0891519, -0.23286, -0.106569, -0.0935545, 0.995583, -0.00790829, -0.450245, 0.231126, 0.0294436, 0.972478, -0.193674, 0, 0, 0, 1), Qt.matrix4x4(0.968415, 0.0891519, -0.23286, -0.0995497, -0.0935545, 0.995583, -0.00790829, -0.265214, 0.231126, 0.0294436, 0.972478, -0.199596, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, 0.0722113, -0.997371, -0.0644774, -0.125518, 0.989556, 0.0708752, -0.646676, 0.992072, 0.124754, 0.0151209, -0.328997, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, 0.0722113, -0.997371, -0.0591142, -0.125518, 0.989556, 0.0708752, -0.444354, 0.992072, 0.124754, 0.0151209, -0.32935, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, 0.0722113, -0.997371, -0.0544081, -0.125518, 0.989556, 0.0708752, -0.258641, 0.992072, 0.124754, 0.0151209, -0.326015, 0, 0, 0, 1), Qt.matrix4x4(-0.946913, -0.103034, -0.304534, 0.0843454, -0.148039, 0.980592, 0.128543, -0.431656, 0.28538, 0.166802, -0.943788, -0.348786, 0, 0, 0, 1), Qt.matrix4x4(-0.946913, -0.103034, -0.304534, 0.0688403, -0.148039, 0.980592, 0.128543, -0.245581, 0.28538, 0.166802, -0.943788, -0.348545, 0, 0, 0, 1), Qt.matrix4x4(0.968415, 0.0891519, -0.23286, -0.106569, -0.0935545, 0.995583, -0.00790829, -0.450245, 0.231126, 0.0294436, 0.972478, -0.193674, 0, 0, 0, 1), Qt.matrix4x4(0.968415, 0.0891519, -0.23286, -0.0995497, -0.0935545, 0.995583, -0.00790829, -0.265214, 0.231126, 0.0294436, 0.972478, -0.199596, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, 0.0722113, -0.997371, -0.0644774, -0.125518, 0.989556, 0.0708752, -0.646676, 0.992072, 0.124754, 0.0151209, -0.328997, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, 0.0722113, -0.997371, -0.0591142, -0.125518, 0.989556, 0.0708752, -0.444354, 0.992072, 0.124754, 0.0151209, -0.32935, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, 0.0722113, -0.997371, -0.0544081, -0.125518, 0.989556, 0.0708752, -0.258641, 0.992072, 0.124754, 0.0151209, -0.326015, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.0853396, 0, 0.999985, 0.00548092, -0.136476, 0, -0.00548092, 0.999985, 0.0426288, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, -0.0853396, 0, 0.999952, 0.00981419, -0.0560958, 0, -0.00981419, 0.999952, -0.0885555, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0853396, 0, 0.999781, 0.0209207, -1.12081, 0, -0.0209207, 0.999781, 0.0241119, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0853396, 0, 0.997787, 0.0664965, -0.656974, 0, -0.0664965, 0.997787, 0.056914, 0, 0, 0, 1), Qt.matrix4x4(-0.946913, 0.103034, 0.304535, -0.0843454, 0.148039, 0.980592, 0.128543, -0.431656, -0.28538, 0.166802, -0.943788, -0.348786, 0, 0, 0, 1), Qt.matrix4x4(-0.946913, 0.103034, 0.304535, -0.0688403, 0.148039, 0.980592, 0.128543, -0.245581, -0.28538, 0.166802, -0.943788, -0.348545, 0, 0, 0, 1), Qt.matrix4x4(0.968415, -0.0891519, 0.23286, 0.106569, 0.0935545, 0.995583, -0.00790829, -0.450245, -0.231126, 0.0294436, 0.972478, -0.193674, 0, 0, 0, 1), Qt.matrix4x4(0.968415, -0.0891519, 0.23286, 0.0995497, 0.0935545, 0.995583, -0.00790829, -0.265215, -0.231126, 0.0294436, 0.972478, -0.199596, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, -0.0722113, 0.997371, 0.0644774, 0.125518, 0.989556, 0.0708752, -0.646676, -0.992072, 0.124754, 0.0151209, -0.328997, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, -0.0722113, 0.997371, 0.0591143, 0.125518, 0.989556, 0.0708752, -0.444354, -0.992072, 0.124754, 0.0151209, -0.32935, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, -0.0722113, 0.997371, 0.0544081, 0.125518, 0.989556, 0.0708752, -0.258642, -0.992072, 0.124754, 0.0151209, -0.326015, 0, 0, 0, 1), Qt.matrix4x4(-0.946913, 0.103034, 0.304535, -0.0843454, 0.148039, 0.980592, 0.128543, -0.431656, -0.28538, 0.166802, -0.943788, -0.348786, 0, 0, 0, 1), Qt.matrix4x4(-0.946913, 0.103034, 0.304535, -0.0688403, 0.148039, 0.980592, 0.128543, -0.245581, -0.28538, 0.166802, -0.943788, -0.348545, 0, 0, 0, 1), Qt.matrix4x4(0.968415, -0.0891519, 0.23286, 0.106569, 0.0935545, 0.995583, -0.00790829, -0.450245, -0.231126, 0.0294436, 0.972478, -0.193674, 0, 0, 0, 1), Qt.matrix4x4(0.968415, -0.0891519, 0.23286, 0.0995497, 0.0935545, 0.995583, -0.00790829, -0.265215, -0.231126, 0.0294436, 0.972478, -0.199596, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, -0.0722113, 0.997371, 0.0644774, 0.125518, 0.989556, 0.0708752, -0.646676, -0.992072, 0.124754, 0.0151209, -0.328997, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, -0.0722113, 0.997371, 0.0591143, 0.125518, 0.989556, 0.0708752, -0.444354, -0.992072, 0.124754, 0.0151209, -0.32935, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, -0.0722113, 0.997371, 0.0544081, 0.125518, 0.989556, 0.0708752, -0.258642, -0.992072, 0.124754, 0.0151209, -0.326015, 0, 0, 0, 1), Qt.matrix4x4(-0.946913, 0.103034, 0.304535, -0.0843454, 0.148039, 0.980592, 0.128543, -0.431656, -0.28538, 0.166802, -0.943788, -0.348786, 0, 0, 0, 1), Qt.matrix4x4(-0.946913, 0.103034, 0.304535, -0.0688403, 0.148039, 0.980592, 0.128543, -0.245581, -0.28538, 0.166802, -0.943788, -0.348545, 0, 0, 0, 1), Qt.matrix4x4(0.968415, -0.0891519, 0.23286, 0.106569, 0.0935545, 0.995583, -0.00790829, -0.450245, -0.231126, 0.0294436, 0.972478, -0.193674, 0, 0, 0, 1), Qt.matrix4x4(0.968415, -0.0891519, 0.23286, 0.0995497, 0.0935545, 0.995583, -0.00790829, -0.265215, -0.231126, 0.0294436, 0.972478, -0.199596, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, -0.0722113, 0.997371, 0.0644774, 0.125518, 0.989556, 0.0708752, -0.646676, -0.992072, 0.124754, 0.0151209, -0.328997, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, -0.0722113, 0.997371, 0.0591143, 0.125518, 0.989556, 0.0708752, -0.444354, -0.992072, 0.124754, 0.0151209, -0.32935, 0, 0, 0, 1), Qt.matrix4x4(0.00612098, -0.0722113, 0.997371, 0.0544081, 0.125518, 0.989556, 0.0708752, -0.258642, -0.992072, 0.124754, 0.0151209, -0.326015, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0853396, 0, 0.999985, 0.00548092, -0.136476, 0, -0.00548092, 0.999985, 0.0426288, 0, 0, 0, 1), Qt.matrix4x4(1, 0, 0, 0.0853396, 0, 0.999952, 0.00981419, -0.0560958, 0, -0.00981419, 0.999952, -0.0885555, 0, 0, 0, 1)]
    }
    PrincipledMaterial {
        id: n00_000_00_FaceEyeline_00_FACE__Instance__material
        objectName: "N00_000_00_FaceEyeline_00_FACE (Instance)"
        baseColorMap: _9_texture
        roughness: 0.8999999761581421
        normalMap: _1_texture
        emissiveMap: _2_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
        lighting: PrincipledMaterial.NoLighting
    }
    PrincipledMaterial {
        id: n00_000_00_FaceBrow_00_FACE__Instance__material
        objectName: "N00_000_00_FaceBrow_00_FACE (Instance)"
        baseColorMap: _8_texture
        roughness: 0.8999999761581421
        normalMap: _1_texture
        emissiveMap: _2_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
        lighting: PrincipledMaterial.NoLighting
    }
    PrincipledMaterial {
        id: n00_000_00_EyeWhite_00_EYE__Instance__material
        objectName: "N00_000_00_EyeWhite_00_EYE (Instance)"
        baseColorMap: _7_texture
        roughness: 0.8999999761581421
        normalMap: _1_texture
        emissiveMap: _2_texture
        alphaMode: PrincipledMaterial.Mask
        depthDrawMode: PrincipledMaterial.OpaquePrePassDepthDraw
        lighting: PrincipledMaterial.NoLighting
    }
    PrincipledMaterial {
        id: n00_000_00_Face_00_SKIN__Instance__material
        objectName: "N00_000_00_Face_00_SKIN (Instance)"
        baseColorMap: _5_texture
        roughness: 0.8999999761581421
        normalMap: _6_texture
        emissiveMap: _2_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Mask
        depthDrawMode: PrincipledMaterial.OpaquePrePassDepthDraw
        lighting: PrincipledMaterial.NoLighting
    }
    PrincipledMaterial {
        id: n00_000_00_EyeHighlight_00_EYE__Instance__material
        objectName: "N00_000_00_EyeHighlight_00_EYE (Instance)"
        baseColorMap: _4_texture
        roughness: 0.8999999761581421
        normalMap: _1_texture
        emissiveMap: _2_texture
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Blend
        lighting: PrincipledMaterial.NoLighting
    }
    PrincipledMaterial {
        id: n00_000_00_EyeIris_00_EYE__Instance__material
        objectName: "N00_000_00_EyeIris_00_EYE (Instance)"
        baseColorMap: _3_texture
        roughness: 0.8999999761581421
        normalMap: _1_texture
        emissiveMap: _2_texture
        alphaMode: PrincipledMaterial.Blend
        lighting: PrincipledMaterial.NoLighting
    }
    MorphTarget {
        id: fcl_MTH_Fun_morphtarget259
        objectName: "Fcl_MTH_Fun"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung1_morphtarget272
        objectName: "Fcl_HA_Fung1"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Hide_morphtarget271
        objectName: "Fcl_HA_Hide"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_O_morphtarget270
        objectName: "Fcl_MTH_O"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_E_morphtarget269
        objectName: "Fcl_MTH_E"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_U_morphtarget268
        objectName: "Fcl_MTH_U"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_I_morphtarget267
        objectName: "Fcl_MTH_I"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_A_morphtarget266
        objectName: "Fcl_MTH_A"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_SkinFung_L_morphtarget265
        objectName: "Fcl_MTH_SkinFung_L"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_SkinFung_R_morphtarget264
        objectName: "Fcl_MTH_SkinFung_R"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_SkinFung_morphtarget263
        objectName: "Fcl_MTH_SkinFung"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Surprised_morphtarget262
        objectName: "Fcl_MTH_Surprised"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Sorrow_morphtarget261
        objectName: "Fcl_MTH_Sorrow"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Joy_morphtarget260
        objectName: "Fcl_MTH_Joy"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung1_morphtarget329
        objectName: "Fcl_HA_Fung1"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Neutral_morphtarget258
        objectName: "Fcl_MTH_Neutral"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Large_morphtarget257
        objectName: "Fcl_MTH_Large"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Small_morphtarget256
        objectName: "Fcl_MTH_Small"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Angry_morphtarget255
        objectName: "Fcl_MTH_Angry"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Down_morphtarget254
        objectName: "Fcl_MTH_Down"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Up_morphtarget253
        objectName: "Fcl_MTH_Up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Close_morphtarget252
        objectName: "Fcl_MTH_Close"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Highlight_Hide_morphtarget251
        objectName: "Fcl_EYE_Highlight_Hide"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Iris_Hide_morphtarget250
        objectName: "Fcl_EYE_Iris_Hide"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Spread_morphtarget249
        objectName: "Fcl_EYE_Spread"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Surprised_morphtarget248
        objectName: "Fcl_EYE_Surprised"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Sorrow_morphtarget247
        objectName: "Fcl_EYE_Sorrow"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Neutral_morphtarget398
        objectName: "Fcl_ALL_Neutral"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Close_morphtarget411
        objectName: "Fcl_EYE_Close"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Angry_morphtarget410
        objectName: "Fcl_EYE_Angry"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Natural_morphtarget409
        objectName: "Fcl_EYE_Natural"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_BRW_Surprised_morphtarget408
        objectName: "Fcl_BRW_Surprised"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_BRW_Sorrow_morphtarget407
        objectName: "Fcl_BRW_Sorrow"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_BRW_Joy_morphtarget406
        objectName: "Fcl_BRW_Joy"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_BRW_Fun_morphtarget405
        objectName: "Fcl_BRW_Fun"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_BRW_Angry_morphtarget404
        objectName: "Fcl_BRW_Angry"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Surprised_morphtarget403
        objectName: "Fcl_ALL_Surprised"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Sorrow_morphtarget402
        objectName: "Fcl_ALL_Sorrow"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Joy_morphtarget401
        objectName: "Fcl_ALL_Joy"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Fun_morphtarget400
        objectName: "Fcl_ALL_Fun"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Angry_morphtarget399
        objectName: "Fcl_ALL_Angry"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Close_R_morphtarget412
        objectName: "Fcl_EYE_Close_R"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Short_Low_morphtarget397
        objectName: "Fcl_HA_Short_Low"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Short_Up_morphtarget396
        objectName: "Fcl_HA_Short_Up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Short_morphtarget395
        objectName: "Fcl_HA_Short"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung3_Low_morphtarget394
        objectName: "Fcl_HA_Fung3_Low"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung3_Up_morphtarget393
        objectName: "Fcl_HA_Fung3_Up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung3_morphtarget392
        objectName: "Fcl_HA_Fung3"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung2_Up_morphtarget391
        objectName: "Fcl_HA_Fung2_Up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung2_Low_morphtarget390
        objectName: "Fcl_HA_Fung2_Low"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung2_morphtarget389
        objectName: "Fcl_HA_Fung2"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung1_Up_morphtarget388
        objectName: "Fcl_HA_Fung1_Up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung1_Low_morphtarget387
        objectName: "Fcl_HA_Fung1_Low"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung1_morphtarget386
        objectName: "Fcl_HA_Fung1"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Hide_morphtarget385
        objectName: "Fcl_HA_Hide"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Angry_morphtarget426
        objectName: "Fcl_MTH_Angry"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_U_morphtarget439
        objectName: "Fcl_MTH_U"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_I_morphtarget438
        objectName: "Fcl_MTH_I"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_A_morphtarget437
        objectName: "Fcl_MTH_A"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_SkinFung_L_morphtarget436
        objectName: "Fcl_MTH_SkinFung_L"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_SkinFung_R_morphtarget435
        objectName: "Fcl_MTH_SkinFung_R"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_SkinFung_morphtarget434
        objectName: "Fcl_MTH_SkinFung"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Surprised_morphtarget433
        objectName: "Fcl_MTH_Surprised"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Sorrow_morphtarget432
        objectName: "Fcl_MTH_Sorrow"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Joy_morphtarget431
        objectName: "Fcl_MTH_Joy"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Fun_morphtarget430
        objectName: "Fcl_MTH_Fun"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Neutral_morphtarget429
        objectName: "Fcl_MTH_Neutral"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Large_morphtarget428
        objectName: "Fcl_MTH_Large"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Small_morphtarget427
        objectName: "Fcl_MTH_Small"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_O_morphtarget384
        objectName: "Fcl_MTH_O"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Down_morphtarget425
        objectName: "Fcl_MTH_Down"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Up_morphtarget424
        objectName: "Fcl_MTH_Up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Close_morphtarget423
        objectName: "Fcl_MTH_Close"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Highlight_Hide_morphtarget422
        objectName: "Fcl_EYE_Highlight_Hide"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Iris_Hide_morphtarget421
        objectName: "Fcl_EYE_Iris_Hide"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Spread_morphtarget420
        objectName: "Fcl_EYE_Spread"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Surprised_morphtarget419
        objectName: "Fcl_EYE_Surprised"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Sorrow_morphtarget418
        objectName: "Fcl_EYE_Sorrow"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Joy_L_morphtarget417
        objectName: "Fcl_EYE_Joy_L"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Joy_R_morphtarget416
        objectName: "Fcl_EYE_Joy_R"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Joy_morphtarget415
        objectName: "Fcl_EYE_Joy"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Fun_morphtarget414
        objectName: "Fcl_EYE_Fun"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Close_L_morphtarget413
        objectName: "Fcl_EYE_Close_L"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Fun_morphtarget343
        objectName: "Fcl_ALL_Fun"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Close_L_morphtarget356
        objectName: "Fcl_EYE_Close_L"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Close_R_morphtarget355
        objectName: "Fcl_EYE_Close_R"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Close_morphtarget354
        objectName: "Fcl_EYE_Close"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Angry_morphtarget353
        objectName: "Fcl_EYE_Angry"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Natural_morphtarget352
        objectName: "Fcl_EYE_Natural"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_BRW_Surprised_morphtarget351
        objectName: "Fcl_BRW_Surprised"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_BRW_Sorrow_morphtarget350
        objectName: "Fcl_BRW_Sorrow"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_BRW_Joy_morphtarget349
        objectName: "Fcl_BRW_Joy"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_BRW_Fun_morphtarget348
        objectName: "Fcl_BRW_Fun"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_BRW_Angry_morphtarget347
        objectName: "Fcl_BRW_Angry"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Surprised_morphtarget346
        objectName: "Fcl_ALL_Surprised"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Sorrow_morphtarget345
        objectName: "Fcl_ALL_Sorrow"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Joy_morphtarget344
        objectName: "Fcl_ALL_Joy"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Fun_morphtarget357
        objectName: "Fcl_EYE_Fun"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Angry_morphtarget342
        objectName: "Fcl_ALL_Angry"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_ALL_Neutral_morphtarget341
        objectName: "Fcl_ALL_Neutral"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Short_Low_morphtarget340
        objectName: "Fcl_HA_Short_Low"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Short_Up_morphtarget339
        objectName: "Fcl_HA_Short_Up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Short_morphtarget338
        objectName: "Fcl_HA_Short"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung3_Low_morphtarget337
        objectName: "Fcl_HA_Fung3_Low"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung3_Up_morphtarget336
        objectName: "Fcl_HA_Fung3_Up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung3_morphtarget335
        objectName: "Fcl_HA_Fung3"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung2_Up_morphtarget334
        objectName: "Fcl_HA_Fung2_Up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung2_Low_morphtarget333
        objectName: "Fcl_HA_Fung2_Low"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung2_morphtarget332
        objectName: "Fcl_HA_Fung2"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung1_Up_morphtarget331
        objectName: "Fcl_HA_Fung1_Up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_HA_Fung1_Low_morphtarget330
        objectName: "Fcl_HA_Fung1_Low"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Small_morphtarget370
        objectName: "Fcl_MTH_Small"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_E_morphtarget383
        objectName: "Fcl_MTH_E"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_U_morphtarget382
        objectName: "Fcl_MTH_U"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_I_morphtarget381
        objectName: "Fcl_MTH_I"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_A_morphtarget380
        objectName: "Fcl_MTH_A"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_SkinFung_L_morphtarget379
        objectName: "Fcl_MTH_SkinFung_L"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_SkinFung_R_morphtarget378
        objectName: "Fcl_MTH_SkinFung_R"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_SkinFung_morphtarget377
        objectName: "Fcl_MTH_SkinFung"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Surprised_morphtarget376
        objectName: "Fcl_MTH_Surprised"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Sorrow_morphtarget375
        objectName: "Fcl_MTH_Sorrow"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Joy_morphtarget374
        objectName: "Fcl_MTH_Joy"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Fun_morphtarget373
        objectName: "Fcl_MTH_Fun"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Neutral_morphtarget372
        objectName: "Fcl_MTH_Neutral"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Large_morphtarget371
        objectName: "Fcl_MTH_Large"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_E_morphtarget440
        objectName: "Fcl_MTH_E"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Angry_morphtarget369
        objectName: "Fcl_MTH_Angry"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Down_morphtarget368
        objectName: "Fcl_MTH_Down"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Up_morphtarget367
        objectName: "Fcl_MTH_Up"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_MTH_Close_morphtarget366
        objectName: "Fcl_MTH_Close"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Highlight_Hide_morphtarget365
        objectName: "Fcl_EYE_Highlight_Hide"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Iris_Hide_morphtarget364
        objectName: "Fcl_EYE_Iris_Hide"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Spread_morphtarget363
        objectName: "Fcl_EYE_Spread"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Surprised_morphtarget362
        objectName: "Fcl_EYE_Surprised"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Sorrow_morphtarget361
        objectName: "Fcl_EYE_Sorrow"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Joy_L_morphtarget360
        objectName: "Fcl_EYE_Joy_L"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Joy_R_morphtarget359
        objectName: "Fcl_EYE_Joy_R"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }
    MorphTarget {
        id: fcl_EYE_Joy_morphtarget358
        objectName: "Fcl_EYE_Joy"
        attributes: MorphTarget.Position | MorphTarget.Normal
    }

    // Nodes:
    Node {
        id: root1
        objectName: "ROOT"
        Node {
            id: root
            objectName: "Root"
            Node {
                id: j_Bip_C_Hips
                objectName: "J_Bip_C_Hips"
                position: Qt.vector3d(0, 1.16722, 0.00358467)
                rotation: Qt.quaternion(0.99802, 0.0628984, 0, 0)
                Node {
                    id: j_Bip_C_Spine
                    objectName: "J_Bip_C_Spine"
                    position: Qt.vector3d(-7.11265e-32, 0.0617802, 0.00682557)
                    rotation: Qt.quaternion(0.999918, 0.0127968, 0, 0)
                    scale: Qt.vector3d(1, 1, 1)
                    Node {
                        id: j_Bip_C_Chest
                        objectName: "J_Bip_C_Chest"
                        position: Qt.vector3d(2.40917e-17, 0.130196, -0.016293)
                        rotation: Qt.quaternion(0.990678, -0.136221, 0, 0)
                        scale: Qt.vector3d(1, 1, 1)
                        Node {
                            id: j_Bip_C_UpperChest
                            objectName: "J_Bip_C_UpperChest"
                            position: Qt.vector3d(-3.47739e-17, 0.126073, -0.00169167)
                            rotation: Qt.quaternion(0.994154, -0.107976, 0, 0)
                            Node {
                                id: j_Sec_L_Bust1
                                objectName: "J_Sec_L_Bust1"
                                position: Qt.vector3d(0.0611993, -0.0345069, 0.0727298)
                                rotation: Qt.quaternion(0.966512, 0.105634, 0.232051, 0.0291196)
                                scale: Qt.vector3d(1, 1, 1)
                                Node {
                                    id: j_Sec_L_Bust2
                                    objectName: "J_Sec_L_Bust2"
                                    position: Qt.vector3d(-1.00248e-05, 1.19209e-07, 0.001277)
                                    rotation: Qt.quaternion(1, -6.14673e-08, 2.30968e-07, -2.32831e-08)
                                    scale: Qt.vector3d(1, 1, 1)
                                }
                            }
                            Node {
                                id: j_Sec_R_Bust1
                                objectName: "J_Sec_R_Bust1"
                                position: Qt.vector3d(-0.0611993, -0.0345069, 0.0727298)
                                rotation: Qt.quaternion(0.966512, 0.105634, -0.232051, -0.0291196)
                                scale: Qt.vector3d(1, 1, 1)
                                Node {
                                    id: j_Sec_R_Bust2
                                    objectName: "J_Sec_R_Bust2"
                                    position: Qt.vector3d(1.00248e-05, 1.19209e-07, 0.001277)
                                    rotation: Qt.quaternion(1, -6.14673e-08, -2.30968e-07, 2.32831e-08)
                                    scale: Qt.vector3d(1, 1, 1)
                                }
                            }
                            Node {
                                id: j_Bip_C_Neck
                                objectName: "J_Bip_C_Neck"
                                position: Qt.vector3d(-1.09133e-16, 0.159609, 0.00894487)
                                rotation: Qt.quaternion(0.973925, 0.22687, 0, 0)
                                scale: Qt.vector3d(1, 1, 1)
                                Node {
                                    id: j_Bip_C_Head
                                    objectName: "J_Bip_C_Head"
                                    position: Qt.vector3d(-2.49361e-12, 0.0965347, -5.57303e-06)
                                    rotation: Qt.quaternion(0.998523, -0.054336, 2.20206e-07, 1.19822e-08)
                                    scale: Qt.vector3d(1, 1, 1)
                                    Node {
                                        id: j_Adj_L_FaceEye
                                        objectName: "J_Adj_L_FaceEye"
                                        position: Qt.vector3d(0.0162448, 0.0634009, 0.0215714)
                                        rotation: Qt.quaternion(0.982245, 0.0203793, 0.186388, -0.00621223)
                                        scale: Qt.vector3d(1, 1, 1)
                                    }
                                    Node {
                                        id: j_Adj_R_FaceEye
                                        objectName: "J_Adj_R_FaceEye"
                                        position: Qt.vector3d(-0.0162448, 0.0634006, 0.0215714)
                                        rotation: Qt.quaternion(0.982245, 0.0203792, -0.186387, 0.00621222)
                                        scale: Qt.vector3d(1, 1, 1)
                                    }
                                    Node {
                                        id: j_Sec_Hair1_01
                                        objectName: "J_Sec_Hair1_01"
                                        position: Qt.vector3d(-0.113222, 0.104905, 0.0080847)
                                        rotation: Qt.quaternion(0.53565, -0.110753, 0.169507, 0.819805)
                                        scale: Qt.vector3d(1, 1, 1)
                                        Node {
                                            id: j_Sec_Hair2_01
                                            objectName: "J_Sec_Hair2_01"
                                            position: Qt.vector3d(-0.000146151, 0.050388, -1.78814e-07)
                                            rotation: Qt.quaternion(1, 2.23517e-08, -7.45058e-08, -1.19209e-07)
                                            scale: Qt.vector3d(1, 1, 1)
                                            Node {
                                                id: j_Sec_Hair2_01_end
                                                objectName: "J_Sec_Hair2_01_end"
                                                position: Qt.vector3d(-0.000203035, 0.0699997, -2.48411e-07)
                                            }
                                        }
                                    }
                                    Node {
                                        id: j_Sec_Hair1_02
                                        objectName: "J_Sec_Hair1_02"
                                        position: Qt.vector3d(0.111774, 0.110024, 0.00813038)
                                        rotation: Qt.quaternion(-0.444358, 0.0497451, 0.0995124, 0.888914)
                                        scale: Qt.vector3d(1, 1, 1)
                                        Node {
                                            id: j_Sec_Hair2_02
                                            objectName: "J_Sec_Hair2_02"
                                            position: Qt.vector3d(0.00014317, 0.0378416, 0)
                                            rotation: Qt.quaternion(1, -7.45058e-09, 3.72529e-08, -7.40402e-08)
                                            scale: Qt.vector3d(0.999999, 1, 1)
                                            Node {
                                                id: j_Sec_Hair2_02_end
                                                objectName: "J_Sec_Hair2_02_end"
                                                position: Qt.vector3d(0.000264837, 0.0699995, 0)
                                            }
                                        }
                                    }
                                    Node {
                                        id: j_Sec_Hair1_03
                                        objectName: "J_Sec_Hair1_03"
                                        position: Qt.vector3d(-0.0879898, 0.0758955, 0.0614545)
                                        rotation: Qt.quaternion(-0.0834605, 0.00599143, 0.0713513, 0.993935)
                                        scale: Qt.vector3d(1, 1, 1)
                                        Node {
                                            id: j_Sec_Hair2_03
                                            objectName: "J_Sec_Hair2_03"
                                            position: Qt.vector3d(4.38541e-05, 0.0340691, -5.96046e-08)
                                            rotation: Qt.quaternion(0.951978, 0.230623, -0.0859071, 0.182128)
                                            scale: Qt.vector3d(0.999999, 1, 1)
                                            Node {
                                                id: j_Sec_Hair3_03
                                                objectName: "J_Sec_Hair3_03"
                                                position: Qt.vector3d(0.000117421, 0.033712, 1.19209e-07)
                                                rotation: Qt.quaternion(1, -5.96047e-08, 4.84288e-08, 1.15484e-07)
                                                scale: Qt.vector3d(1, 1, 1)
                                                Node {
                                                    id: j_Sec_Hair3_03_end
                                                    objectName: "J_Sec_Hair3_03_end"
                                                    position: Qt.vector3d(0.000243813, 0.0699996, 2.47526e-07)
                                                }
                                            }
                                        }
                                    }
                                    Node {
                                        id: j_Sec_Hair1_04
                                        objectName: "J_Sec_Hair1_04"
                                        position: Qt.vector3d(0.0873567, 0.0874751, 0.0572669)
                                        rotation: Qt.quaternion(0.0578863, -0.00350248, 0.0602913, 0.996495)
                                        scale: Qt.vector3d(1, 1, 1)
                                        Node {
                                            id: j_Sec_Hair2_04
                                            objectName: "J_Sec_Hair2_04"
                                            position: Qt.vector3d(-3.07634e-05, 0.034114, -5.96046e-08)
                                            rotation: Qt.quaternion(0.941257, 0.217203, 0.0842804, -0.244449)
                                            scale: Qt.vector3d(1, 1, 1)
                                            Node {
                                                id: j_Sec_Hair3_04
                                                objectName: "J_Sec_Hair3_04"
                                                position: Qt.vector3d(-0.000126302, 0.0338938, 0)
                                                rotation: Qt.quaternion(1, 7.45058e-09, -7.45058e-08, 4.09782e-08)
                                                scale: Qt.vector3d(1, 1, 1)
                                                Node {
                                                    id: j_Sec_Hair3_04_end
                                                    objectName: "J_Sec_Hair3_04_end"
                                                    position: Qt.vector3d(-0.000260847, 0.0699995, 0)
                                                }
                                            }
                                        }
                                    }
                                    Node {
                                        id: j_Sec_Hair1_05
                                        objectName: "J_Sec_Hair1_05"
                                        position: Qt.vector3d(0.00242201, 0.140113, 0.109105)
                                        rotation: Qt.quaternion(-0.0012545, 6.51412e-05, 0.0518531, 0.998654)
                                        scale: Qt.vector3d(1, 1, 1)
                                        Node {
                                            id: j_Sec_Hair2_05
                                            objectName: "J_Sec_Hair2_05"
                                            position: Qt.vector3d(7.86502e-07, 0.0405679, -8.9407e-08)
                                            rotation: Qt.quaternion(0.990594, -0.136407, -0.00113124, -0.0107043)
                                            scale: Qt.vector3d(0.999999, 0.999999, 1)
                                            Node {
                                                id: j_Sec_Hair3_05
                                                objectName: "J_Sec_Hair3_05"
                                                position: Qt.vector3d(-6.07595e-06, 0.0406415, 1.19209e-07)
                                                rotation: Qt.quaternion(1, 2.23517e-08, 2.73576e-09, -1.20781e-09)
                                                scale: Qt.vector3d(1, 1, 1)
                                                Node {
                                                    id: j_Sec_Hair3_05_end
                                                    objectName: "J_Sec_Hair3_05_end"
                                                    position: Qt.vector3d(-1.04651e-05, 0.07, 2.05323e-07)
                                                }
                                            }
                                        }
                                    }
                                    Node {
                                        id: j_Sec_Hair1_06
                                        objectName: "J_Sec_Hair1_06"
                                        position: Qt.vector3d(-0.0438321, 0.132837, 0.106512)
                                        rotation: Qt.quaternion(0.0691119, -0.000156941, 0.0022654, 0.997606)
                                        Node {
                                            id: j_Sec_Hair2_06
                                            objectName: "J_Sec_Hair2_06"
                                            position: Qt.vector3d(-3.40343e-05, 0.0316952, 7.45058e-09)
                                            rotation: Qt.quaternion(0.990561, -0.0611892, -0.000926257, 0.122654)
                                            scale: Qt.vector3d(1, 1, 1)
                                            Node {
                                                id: j_Sec_Hair3_06
                                                objectName: "J_Sec_Hair3_06"
                                                position: Qt.vector3d(2.64943e-05, 0.0315094, -5.96046e-08)
                                                rotation: Qt.quaternion(1, 0, -3.72529e-09, -9.48785e-09)
                                                scale: Qt.vector3d(1, 1, 1)
                                                Node {
                                                    id: j_Sec_Hair3_06_end
                                                    objectName: "J_Sec_Hair3_06_end"
                                                    position: Qt.vector3d(5.88586e-05, 0.07, -1.32415e-07)
                                                }
                                            }
                                        }
                                    }
                                    Node {
                                        id: j_Sec_Hair1_07
                                        objectName: "J_Sec_Hair1_07"
                                        position: Qt.vector3d(0.0793828, 0.11437, 0.074204)
                                        rotation: Qt.quaternion(-0.00152807, 2.55823e-05, 0.0167338, 0.999859)
                                        scale: Qt.vector3d(1, 1, 1)
                                        Node {
                                            id: j_Sec_Hair2_07
                                            objectName: "J_Sec_Hair2_07"
                                            position: Qt.vector3d(8.34465e-07, 0.0350815, -7.45058e-09)
                                            rotation: Qt.quaternion(0.979037, 0.040323, 0.00808782, -0.199486)
                                            scale: Qt.vector3d(1, 1, 1)
                                            Node {
                                                id: j_Sec_Hair3_07
                                                objectName: "J_Sec_Hair3_07"
                                                position: Qt.vector3d(-9.7692e-05, 0.0348238, 1.49012e-08)
                                                rotation: Qt.quaternion(1, -1.86265e-09, -8.3819e-09, -4.45871e-08)
                                                scale: Qt.vector3d(1, 1, 1)
                                                Node {
                                                    id: j_Sec_Hair3_07_end
                                                    objectName: "J_Sec_Hair3_07_end"
                                                    position: Qt.vector3d(-0.000196372, 0.0699997, 2.9953e-08)
                                                }
                                            }
                                        }
                                    }
                                    Node {
                                        id: j_Sec_Hair1_08
                                        objectName: "J_Sec_Hair1_08"
                                        position: Qt.vector3d(0.0431916, 0.134288, 0.100232)
                                        rotation: Qt.quaternion(-0.0671637, 0.00173018, 0.0256942, 0.99741)
                                        scale: Qt.vector3d(1, 1, 1)
                                        Node {
                                            id: j_Sec_Hair2_08
                                            objectName: "J_Sec_Hair2_08"
                                            position: Qt.vector3d(3.47197e-05, 0.0333602, 0)
                                            rotation: Qt.quaternion(0.989764, -0.056349, 0.000155823, -0.131118)
                                            scale: Qt.vector3d(1, 1, 1)
                                            Node {
                                                id: j_Sec_Hair3_08
                                                objectName: "J_Sec_Hair3_08"
                                                position: Qt.vector3d(-3.31402e-05, 0.0332941, -4.84288e-08)
                                                rotation: Qt.quaternion(1, 7.45058e-09, 8.84756e-09, 4.51982e-08)
                                                scale: Qt.vector3d(1, 1, 1)
                                                Node {
                                                    id: j_Sec_Hair3_08_end
                                                    objectName: "J_Sec_Hair3_08_end"
                                                    position: Qt.vector3d(-6.96764e-05, 0.07, -1.0182e-07)
                                                }
                                            }
                                        }
                                    }
                                    Node {
                                        id: j_Sec_Hair1_09
                                        objectName: "J_Sec_Hair1_09"
                                        position: Qt.vector3d(-0.0805399, 0.106838, 0.0744029)
                                        rotation: Qt.quaternion(-0.00121422, -2.63766e-07, -0.000195484, 0.999999)
                                        scale: Qt.vector3d(1, 1, 1)
                                        Node {
                                            id: j_Sec_Hair2_09
                                            objectName: "J_Sec_Hair2_09"
                                            position: Qt.vector3d(5.96046e-07, 0.03297, 4.09782e-08)
                                            rotation: Qt.quaternion(0.972074, 0.0608425, -0.0143137, 0.226197)
                                            scale: Qt.vector3d(1, 1, 1)
                                            Node {
                                                id: j_Sec_Hair3_09
                                                objectName: "J_Sec_Hair3_09"
                                                position: Qt.vector3d(0.000102043, 0.0327742, 0)
                                                rotation: Qt.quaternion(1, 3.72529e-09, -3.72529e-09, -3.66708e-08)
                                                scale: Qt.vector3d(1, 1, 1)
                                                Node {
                                                    id: j_Sec_Hair3_09_end
                                                    objectName: "J_Sec_Hair3_09_end"
                                                    position: Qt.vector3d(0.000217945, 0.0699997, 0)
                                                }
                                            }
                                        }
                                    }
                                    Node {
                                        id: j_Sec_Hair1_10
                                        objectName: "J_Sec_Hair1_10"
                                        position: Qt.vector3d(0.0621147, 0.141992, 0.106347)
                                        rotation: Qt.quaternion(-0.346234, -0.0754992, -0.199226, 0.913636)
                                        scale: Qt.vector3d(1, 1, 1)
                                        Node {
                                            id: j_Sec_Hair2_10
                                            objectName: "J_Sec_Hair2_10"
                                            position: Qt.vector3d(0.000158787, 0.0407298, 5.96046e-08)
                                            rotation: Qt.quaternion(0.929418, -0.27774, 0.242926, -0.00543535)
                                            scale: Qt.vector3d(1, 1, 1)
                                            Node {
                                                id: j_Sec_Hair3_10
                                                objectName: "J_Sec_Hair3_10"
                                                position: Qt.vector3d(0.000160575, 0.0413438, 0)
                                                rotation: Qt.quaternion(1, 2.01166e-07, -7.82311e-08, -1.49012e-08)
                                                scale: Qt.vector3d(1, 1, 1)
                                                Node {
                                                    id: j_Sec_Hair3_10_end
                                                    objectName: "J_Sec_Hair3_10_end"
                                                    position: Qt.vector3d(0.00027187, 0.0699995, 0)
                                                }
                                            }
                                        }
                                    }
                                    Node {
                                        id: j_Sec_Hair1_11
                                        objectName: "J_Sec_Hair1_11"
                                        position: Qt.vector3d(-0.0253072, 0.145806, 0.121749)
                                        rotation: Qt.quaternion(0.51856, 0.16888, -0.259558, 0.796997)
                                        scale: Qt.vector3d(1, 1, 1)
                                        Node {
                                            id: j_Sec_Hair2_11
                                            objectName: "J_Sec_Hair2_11"
                                            position: Qt.vector3d(-0.000108719, 0.0371557, -1.19209e-07)
                                            rotation: Qt.quaternion(0.453016, -0.104387, 0.842618, -0.271798)
                                            scale: Qt.vector3d(1, 1, 1)
                                            Node {
                                                id: j_Sec_Hair3_11
                                                objectName: "J_Sec_Hair3_11"
                                                position: Qt.vector3d(0.000142127, 0.0373381, 0)
                                                rotation: Qt.quaternion(1, -4.47035e-08, -1.22935e-07, 3.72529e-08)
                                                scale: Qt.vector3d(1, 1, 1)
                                                Node {
                                                    id: j_Sec_Hair3_11_end
                                                    objectName: "J_Sec_Hair3_11_end"
                                                    position: Qt.vector3d(0.000266453, 0.0699995, 0)
                                                }
                                            }
                                        }
                                    }
                                    Node {
                                        id: j_Sec_Hair1_12
                                        objectName: "J_Sec_Hair1_12"
                                        position: Qt.vector3d(-0.0611194, 0.013742, -0.0388366)
                                        rotation: Qt.quaternion(-0.225105, 0.0134682, 0.0581859, 0.972502)
                                        scale: Qt.vector3d(1, 1, 1)
                                        Node {
                                            id: j_Sec_Hair2_12
                                            objectName: "J_Sec_Hair2_12"
                                            position: Qt.vector3d(0.000129163, 0.0418012, 8.19564e-08)
                                            rotation: Qt.quaternion(0.885533, -0.266694, 0.0131874, -0.380173)
                                            scale: Qt.vector3d(1, 1, 1)
                                            Node {
                                                id: j_Sec_Hair3_12
                                                objectName: "J_Sec_Hair3_12"
                                                position: Qt.vector3d(-9.93013e-05, 0.0387173, -5.96046e-08)
                                                rotation: Qt.quaternion(1, 2.23517e-08, -2.23517e-08, 2.8871e-08)
                                                scale: Qt.vector3d(1, 1, 1)
                                                Node {
                                                    id: j_Sec_Hair3_12_end
                                                    objectName: "J_Sec_Hair3_12_end"
                                                    position: Qt.vector3d(-0.000179534, 0.0699998, -1.07764e-07)
                                                }
                                            }
                                        }
                                    }
                                    Node {
                                        id: j_Sec_Hair1_13
                                        objectName: "J_Sec_Hair1_13"
                                        position: Qt.vector3d(0.00668913, 0.00257957, -0.0671979)
                                        rotation: Qt.quaternion(0.000793563, -0.000157556, 0.194807, 0.980841)
                                        scale: Qt.vector3d(1, 1, 1)
                                        Node {
                                            id: j_Sec_Hair2_13
                                            objectName: "J_Sec_Hair2_13"
                                            position: Qt.vector3d(-3.46452e-07, 0.0321467, 5.96046e-08)
                                            rotation: Qt.quaternion(0.944479, -0.310792, -0.0337858, -0.101127)
                                            scale: Qt.vector3d(0.999999, 0.999999, 1)
                                            Node {
                                                id: j_Sec_Hair3_13
                                                objectName: "J_Sec_Hair3_13"
                                                position: Qt.vector3d(-5.20945e-05, 0.0318822, -5.96046e-08)
                                                rotation: Qt.quaternion(1, 4.47035e-08, 5.21541e-08, -1.72295e-08)
                                                scale: Qt.vector3d(1, 1, 1)
                                                Node {
                                                    id: j_Sec_Hair3_13_end
                                                    objectName: "J_Sec_Hair3_13_end"
                                                    position: Qt.vector3d(-0.000114378, 0.0699999, -1.30867e-07)
                                                }
                                            }
                                        }
                                    }
                                    Node {
                                        id: j_Sec_Hair1_14
                                        objectName: "J_Sec_Hair1_14"
                                        position: Qt.vector3d(0.0583514, 0.00902736, -0.0385995)
                                        rotation: Qt.quaternion(0.182769, -0.0167382, 0.0896508, 0.978917)
                                        scale: Qt.vector3d(1, 1, 1)
                                        Node {
                                            id: j_Sec_Hair2_14
                                            objectName: "J_Sec_Hair2_14"
                                            position: Qt.vector3d(-9.93013e-05, 0.0376155, 0)
                                            rotation: Qt.quaternion(0.892672, -0.332711, -0.0137147, 0.303731)
                                            scale: Qt.vector3d(0.999999, 0.999999, 1)
                                            Node {
                                                id: j_Sec_Hair3_14
                                                objectName: "J_Sec_Hair3_14"
                                                position: Qt.vector3d(7.73072e-05, 0.036397, -1.19209e-07)
                                                rotation: Qt.quaternion(1, -4.47035e-08, -1.32248e-07, 1.49012e-08)
                                                scale: Qt.vector3d(1, 1, 1)
                                                Node {
                                                    id: j_Sec_Hair3_14_end
                                                    objectName: "J_Sec_Hair3_14_end"
                                                    position: Qt.vector3d(0.00014868, 0.0699998, -2.29267e-07)
                                                }
                                            }
                                        }
                                    }
                                    Node {
                                        id: j_Sec_Hair1_15
                                        objectName: "J_Sec_Hair1_15"
                                        position: Qt.vector3d(0.105321, 0.117539, 0.0225314)
                                        rotation: Qt.quaternion(-0.100839, -0.00314617, -0.0310255, 0.994414)
                                        scale: Qt.vector3d(1, 1, 1)
                                        Node {
                                            id: j_Sec_Hair2_15
                                            objectName: "J_Sec_Hair2_15"
                                            position: Qt.vector3d(6.21676e-05, 0.0404303, 1.49012e-08)
                                            rotation: Qt.quaternion(0.971096, 0.104207, -0.0458968, 0.209778)
                                            scale: Qt.vector3d(0.999999, 0.999999, 1)
                                            Node {
                                                id: j_Sec_Hair3_15
                                                objectName: "J_Sec_Hair3_15"
                                                position: Qt.vector3d(0.00014782, 0.0396421, -5.96046e-08)
                                                rotation: Qt.quaternion(1, 2.98023e-08, 1.86265e-09, -2.37487e-08)
                                                scale: Qt.vector3d(1, 1, 1)
                                                Node {
                                                    id: j_Sec_Hair3_15_end
                                                    objectName: "J_Sec_Hair3_15_end"
                                                    position: Qt.vector3d(0.000261018, 0.0699995, -1.05249e-07)
                                                }
                                            }
                                        }
                                    }
                                    Node {
                                        id: j_Sec_Hair1_16
                                        objectName: "J_Sec_Hair1_16"
                                        position: Qt.vector3d(-0.106508, 0.1045, 0.0241027)
                                        rotation: Qt.quaternion(0.228677, 0.0339414, -0.142839, 0.962368)
                                        scale: Qt.vector3d(1, 1, 1)
                                        Node {
                                            id: j_Sec_Hair2_16
                                            objectName: "J_Sec_Hair2_16"
                                            position: Qt.vector3d(-8.73804e-05, 0.0277244, -5.96046e-08)
                                            rotation: Qt.quaternion(0.957408, -0.214467, -0.14611, -0.12659)
                                            scale: Qt.vector3d(1, 1, 1)
                                            Node {
                                                id: j_Sec_Hair3_16
                                                objectName: "J_Sec_Hair3_16"
                                                position: Qt.vector3d(-0.000108302, 0.0277833, 0)
                                                rotation: Qt.quaternion(1, 6.70552e-08, 2.01166e-07, -2.38419e-07)
                                                scale: Qt.vector3d(1, 1, 1)
                                                Node {
                                                    id: j_Sec_Hair3_16_end
                                                    objectName: "J_Sec_Hair3_16_end"
                                                    position: Qt.vector3d(-0.000272863, 0.0699995, 0)
                                                }
                                            }
                                        }
                                    }
                                    Node {
                                        id: j_Sec_Hair1_17
                                        objectName: "J_Sec_Hair1_17"
                                        position: Qt.vector3d(-0.0651184, 0.0128672, -0.0106534)
                                        rotation: Qt.quaternion(-0.144299, 0.0178939, 0.121755, 0.981852)
                                        scale: Qt.vector3d(1, 1, 1)
                                        Node {
                                            id: j_Sec_Hair2_17
                                            objectName: "J_Sec_Hair2_17"
                                            position: Qt.vector3d(5.03957e-05, 0.0233616, -2.98023e-08)
                                            rotation: Qt.quaternion(0.922522, 0.220022, 0.00860944, -0.316969)
                                            scale: Qt.vector3d(1, 1, 1)
                                            Node {
                                                id: j_Sec_Hair3_17
                                                objectName: "J_Sec_Hair3_17"
                                                position: Qt.vector3d(-5.93662e-05, 0.0224702, -1.19209e-07)
                                                rotation: Qt.quaternion(1, -7.45058e-09, 4.47035e-08, 2.04891e-07)
                                                scale: Qt.vector3d(1, 1, 1)
                                                Node {
                                                    id: j_Sec_Hair3_17_end
                                                    objectName: "J_Sec_Hair3_17_end"
                                                    position: Qt.vector3d(-0.000184939, 0.0699998, -3.71363e-07)
                                                }
                                            }
                                        }
                                    }
                                    Node {
                                        id: j_Sec_Hair1_18
                                        objectName: "J_Sec_Hair1_18"
                                        position: Qt.vector3d(0.0641965, 0.0115831, -0.00606752)
                                        rotation: Qt.quaternion(0.111021, -0.02333, 0.204321, 0.972308)
                                        scale: Qt.vector3d(1, 1, 1)
                                        Node {
                                            id: j_Sec_Hair2_18
                                            objectName: "J_Sec_Hair2_18"
                                            position: Qt.vector3d(-4.4018e-05, 0.0255684, -1.19209e-07)
                                            rotation: Qt.quaternion(0.930478, 0.2807, -0.00571253, 0.235342)
                                            scale: Qt.vector3d(1, 1, 1)
                                            Node {
                                                id: j_Sec_Hair3_18
                                                objectName: "J_Sec_Hair3_18"
                                                position: Qt.vector3d(5.05149e-05, 0.0252166, 1.19209e-07)
                                                rotation: Qt.quaternion(1, -3.72529e-08, 5.40167e-08, 5.21541e-08)
                                                scale: Qt.vector3d(1, 1, 1)
                                                Node {
                                                    id: j_Sec_Hair3_18_end
                                                    objectName: "J_Sec_Hair3_18_end"
                                                    position: Qt.vector3d(0.000140226, 0.0699999, 3.30918e-07)
                                                }
                                            }
                                        }
                                    }
                                    Node {
                                        id: j_Sec_Hair1_19
                                        objectName: "J_Sec_Hair1_19"
                                        position: Qt.vector3d(0.0092409, 0.234622, 0.0173007)
                                        rotation: Qt.quaternion(-0.252864, 0.176329, 0.544134, 0.780311)
                                        scale: Qt.vector3d(1, 1, 1)
                                        Node {
                                            id: j_Sec_Hair2_19
                                            objectName: "J_Sec_Hair2_19"
                                            position: Qt.vector3d(0.000242472, 0.0650207, -2.38419e-07)
                                            rotation: Qt.quaternion(1, -3.72529e-08, 6.333e-08, 7.45059e-09)
                                            scale: Qt.vector3d(0.999999, 1, 1)
                                            Node {
                                                id: j_Sec_Hair2_19_end
                                                objectName: "J_Sec_Hair2_19_end"
                                                position: Qt.vector3d(0.000261038, 0.0699995, -2.56675e-07)
                                            }
                                        }
                                    }
                                    Node {
                                        id: j_Sec_Hair1_20
                                        objectName: "J_Sec_Hair1_20"
                                        position: Qt.vector3d(-0.00164626, 0.234612, 0.0145708)
                                        rotation: Qt.quaternion(0.508709, -0.17769, 0.277789, 0.795283)
                                        scale: Qt.vector3d(1, 1, 1)
                                        Node {
                                            id: j_Sec_Hair2_20
                                            objectName: "J_Sec_Hair2_20"
                                            position: Qt.vector3d(-0.000153899, 0.0511592, 0)
                                            rotation: Qt.quaternion(1, -1.49012e-08, 2.98023e-08, 1.78814e-07)
                                            scale: Qt.vector3d(1, 1, 1)
                                            Node {
                                                id: j_Sec_Hair2_20_end
                                                objectName: "J_Sec_Hair2_20_end"
                                                position: Qt.vector3d(-0.000210576, 0.0699997, 0)
                                            }
                                        }
                                    }
                                }
                            }

                            Node {
                                id: j_Bip_L_Shoulder
                                objectName: "J_Bip_L_Shoulder"
                                position: Qt.vector3d(0.0248794, 0.127253, 0.00788438)
                                rotation: Qt.quaternion(0.983277, 0.16787, 0.0118837, -0.0696071)
                                scale: Qt.vector3d(1, 1, 1)
                                Node {
                                    id: j_Bip_L_UpperArm
                                    objectName: "J_Bip_L_UpperArm"
                                    position: Qt.vector3d(0.110808, -0.000690699, -4.09782e-08)
                                    rotation: Qt.quaternion(0.997504, 2.23815e-08, 1.25862e-09, 0.0706143)
                                    scale: Qt.vector3d(1, 1, 1)
                                    Node {
                                        id: j_Bip_L_LowerArm
                                        objectName: "J_Bip_L_LowerArm"
                                        position: Qt.vector3d(0.232799, -2.38419e-07, 9.31323e-09)
                                        rotation: Qt.quaternion(1, 5.10232e-11, 5.3549e-10, 3.72529e-09)
                                        scale: Qt.vector3d(1, 1, 1)
                                        Node {
                                            id: j_Bip_L_Hand
                                            objectName: "J_Bip_L_Hand"
                                            position: Qt.vector3d(0.251337, 2.86102e-06, 3.46638e-05)
                                            rotation: Qt.quaternion(1, 4.44089e-16, 0, -8.88178e-16)
                                            Node {
                                                id: j_Bip_L_Index1
                                                objectName: "J_Bip_L_Index1"
                                                position: Qt.vector3d(0.0727565, 0.00856686, 0.0228174)
                                                rotation: Qt.quaternion(0.999953, -1.4175e-08, 0.00970428, 2.52802e-08)
                                                Node {
                                                    id: j_Bip_L_Index2
                                                    objectName: "J_Bip_L_Index2"
                                                    position: Qt.vector3d(0.036965, 0, -3.27313e-05)
                                                    rotation: Qt.quaternion(0.99985, 0.000137837, 0.0095633, -0.0144418)
                                                    scale: Qt.vector3d(1, 1, 1)
                                                    Node {
                                                        id: j_Bip_L_Index3
                                                        objectName: "J_Bip_L_Index3"
                                                        position: Qt.vector3d(0.0227605, -2.93255e-05, -3.91454e-05)
                                                        rotation: Qt.quaternion(0.999992, 5.59234e-08, -0.00258984, -0.00292625)
                                                        scale: Qt.vector3d(1, 1, 1)
                                                    }
                                                }
                                            }
                                            Node {
                                                id: j_Bip_L_Little1
                                                objectName: "J_Bip_L_Little1"
                                                position: Qt.vector3d(0.0678877, 0.00856686, -0.0338669)
                                                rotation: Qt.quaternion(1, 4.44089e-16, 0, 0)
                                                Node {
                                                    id: j_Bip_L_Little2
                                                    objectName: "J_Bip_L_Little2"
                                                    position: Qt.vector3d(0.0349358, 1.19209e-07, 2.98023e-08)
                                                    rotation: Qt.quaternion(1, 4.44089e-16, 0, 0)
                                                    Node {
                                                        id: j_Bip_L_Little3
                                                        objectName: "J_Bip_L_Little3"
                                                        position: Qt.vector3d(0.0201347, 0, 1.49012e-08)
                                                        rotation: Qt.quaternion(0.999924, -6.25416e-08, -0.00960976, 0.00776877)
                                                    }
                                                }
                                            }
                                            Node {
                                                id: j_Bip_L_Middle1
                                                objectName: "J_Bip_L_Middle1"
                                                position: Qt.vector3d(0.0737476, 0.00856698, 0.0023761)
                                                rotation: Qt.quaternion(1, 4.44089e-16, 0, 0)
                                                Node {
                                                    id: j_Bip_L_Middle2
                                                    objectName: "J_Bip_L_Middle2"
                                                    position: Qt.vector3d(0.0411736, -1.19209e-07, -2.79397e-08)
                                                    rotation: Qt.quaternion(1, 4.44089e-16, 0, 0)
                                                    Node {
                                                        id: j_Bip_L_Middle3
                                                        objectName: "J_Bip_L_Middle3"
                                                        position: Qt.vector3d(0.0254008, 1.19209e-07, 2.42144e-08)
                                                        rotation: Qt.quaternion(1, 4.44089e-16, 0, 0)
                                                    }
                                                }
                                            }
                                            Node {
                                                id: j_Bip_L_Ring1
                                                objectName: "J_Bip_L_Ring1"
                                                position: Qt.vector3d(0.0729076, 0.00856686, -0.0157729)
                                                rotation: Qt.quaternion(1, 4.44089e-16, 0, 0)
                                                Node {
                                                    id: j_Bip_L_Ring2
                                                    objectName: "J_Bip_L_Ring2"
                                                    position: Qt.vector3d(0.0381937, 1.19209e-07, -3.72529e-08)
                                                    rotation: Qt.quaternion(1, 4.44089e-16, 0, 0)
                                                    Node {
                                                        id: j_Bip_L_Ring3
                                                        objectName: "J_Bip_L_Ring3"
                                                        position: Qt.vector3d(0.0220416, 0, 0)
                                                        rotation: Qt.quaternion(0.999915, -3.68668e-08, 0.0114384, -0.00621871)
                                                        scale: Qt.vector3d(1, 1, 1)
                                                    }
                                                }
                                            }
                                            Node {
                                                id: j_Bip_L_Thumb1
                                                objectName: "J_Bip_L_Thumb1"
                                                position: Qt.vector3d(0.00391525, -0.0116175, 0.0185301)
                                                rotation: Qt.quaternion(0.620582, 0.703166, -0.246799, 0.24398)
                                                scale: Qt.vector3d(1, 1, 1)
                                                Node {
                                                    id: j_Bip_L_Thumb2
                                                    objectName: "J_Bip_L_Thumb2"
                                                    position: Qt.vector3d(0.052756, 0.00114274, -6.46114e-05)
                                                    rotation: Qt.quaternion(0.999746, -5.98695e-05, 0.00279444, -0.0223553)
                                                    scale: Qt.vector3d(1, 1, 1)
                                                    Node {
                                                        id: j_Bip_L_Thumb3
                                                        objectName: "J_Bip_L_Thumb3"
                                                        position: Qt.vector3d(0.0323893, 0.000690162, -4.60148e-05)
                                                        rotation: Qt.quaternion(0.999161, 0.000382159, -0.00800169, 0.0401746)
                                                        scale: Qt.vector3d(1, 1, 1)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            Node {
                                id: j_Bip_R_Shoulder
                                objectName: "J_Bip_R_Shoulder"
                                position: Qt.vector3d(-0.0248794, 0.127253, 0.00788438)
                                rotation: Qt.quaternion(0.983277, 0.16787, -0.0118837, 0.0696071)
                                scale: Qt.vector3d(1, 1, 1)
                                Node {
                                    id: j_Bip_R_UpperArm
                                    objectName: "J_Bip_R_UpperArm"
                                    position: Qt.vector3d(-0.110808, -0.000690699, -4.09782e-08)
                                    rotation: Qt.quaternion(0.997504, 2.23815e-08, -1.25862e-09, -0.0706143)
                                    scale: Qt.vector3d(1, 1, 1)
                                    Node {
                                        id: j_Bip_R_LowerArm
                                        objectName: "J_Bip_R_LowerArm"
                                        position: Qt.vector3d(-0.232799, -2.38419e-07, 9.31323e-09)
                                        rotation: Qt.quaternion(1, 5.10232e-11, -5.3549e-10, -3.72529e-09)
                                        scale: Qt.vector3d(1, 1, 1)
                                        Node {
                                            id: j_Bip_R_Hand
                                            objectName: "J_Bip_R_Hand"
                                            position: Qt.vector3d(-0.251337, 2.86102e-06, 3.46638e-05)
                                            rotation: Qt.quaternion(1, 4.44089e-16, 0, 8.88178e-16)
                                            Node {
                                                id: j_Bip_R_Index1
                                                objectName: "J_Bip_R_Index1"
                                                position: Qt.vector3d(-0.0727565, 0.00856686, 0.0228174)
                                                rotation: Qt.quaternion(0.999953, -1.4175e-08, -0.00970428, -2.52802e-08)
                                                Node {
                                                    id: j_Bip_R_Index2
                                                    objectName: "J_Bip_R_Index2"
                                                    position: Qt.vector3d(-0.036965, 0, -3.27313e-05)
                                                    rotation: Qt.quaternion(0.99985, 0.000137837, -0.0095633, 0.0144418)
                                                    scale: Qt.vector3d(1, 1, 1)
                                                    Node {
                                                        id: j_Bip_R_Index3
                                                        objectName: "J_Bip_R_Index3"
                                                        position: Qt.vector3d(-0.0227605, -2.93255e-05, -3.91454e-05)
                                                        rotation: Qt.quaternion(0.999992, 5.59234e-08, 0.00258984, 0.00292625)
                                                        scale: Qt.vector3d(1, 1, 1)
                                                    }
                                                }
                                            }
                                            Node {
                                                id: j_Bip_R_Little1
                                                objectName: "J_Bip_R_Little1"
                                                position: Qt.vector3d(-0.0678877, 0.00856686, -0.0338669)
                                                rotation: Qt.quaternion(1, 4.44089e-16, 0, 0)
                                                Node {
                                                    id: j_Bip_R_Little2
                                                    objectName: "J_Bip_R_Little2"
                                                    position: Qt.vector3d(-0.0349358, 1.19209e-07, 2.98023e-08)
                                                    rotation: Qt.quaternion(1, 4.44089e-16, 0, 0)
                                                    Node {
                                                        id: j_Bip_R_Little3
                                                        objectName: "J_Bip_R_Little3"
                                                        position: Qt.vector3d(-0.0201347, 0, 1.49012e-08)
                                                        rotation: Qt.quaternion(0.999924, -6.25416e-08, 0.00960976, -0.00776877)
                                                    }
                                                }
                                            }
                                            Node {
                                                id: j_Bip_R_Middle1
                                                objectName: "J_Bip_R_Middle1"
                                                position: Qt.vector3d(-0.0737476, 0.00856698, 0.0023761)
                                                rotation: Qt.quaternion(1, 4.44089e-16, 0, 0)
                                                Node {
                                                    id: j_Bip_R_Middle2
                                                    objectName: "J_Bip_R_Middle2"
                                                    position: Qt.vector3d(-0.0411736, -1.19209e-07, -2.79397e-08)
                                                    rotation: Qt.quaternion(1, 4.44089e-16, 0, 0)
                                                    Node {
                                                        id: j_Bip_R_Middle3
                                                        objectName: "J_Bip_R_Middle3"
                                                        position: Qt.vector3d(-0.0254008, 1.19209e-07, 2.42144e-08)
                                                        rotation: Qt.quaternion(1, 4.44089e-16, 0, 0)
                                                    }
                                                }
                                            }
                                            Node {
                                                id: j_Bip_R_Ring1
                                                objectName: "J_Bip_R_Ring1"
                                                position: Qt.vector3d(-0.0729076, 0.00856686, -0.0157729)
                                                rotation: Qt.quaternion(1, 4.44089e-16, 0, 0)
                                                Node {
                                                    id: j_Bip_R_Ring2
                                                    objectName: "J_Bip_R_Ring2"
                                                    position: Qt.vector3d(-0.0381937, 1.19209e-07, -3.72529e-08)
                                                    rotation: Qt.quaternion(1, 4.44089e-16, 0, 0)
                                                    Node {
                                                        id: j_Bip_R_Ring3
                                                        objectName: "J_Bip_R_Ring3"
                                                        position: Qt.vector3d(-0.0220416, 0, 0)
                                                        rotation: Qt.quaternion(0.999915, -3.68668e-08, -0.0114384, 0.00621871)
                                                        scale: Qt.vector3d(1, 1, 1)
                                                    }
                                                }
                                            }
                                            Node {
                                                id: j_Bip_R_Thumb1
                                                objectName: "J_Bip_R_Thumb1"
                                                position: Qt.vector3d(-0.00391525, -0.0116175, 0.0185301)
                                                rotation: Qt.quaternion(0.620582, 0.703166, 0.246799, -0.24398)
                                                scale: Qt.vector3d(1, 1, 1)
                                                Node {
                                                    id: j_Bip_R_Thumb2
                                                    objectName: "J_Bip_R_Thumb2"
                                                    position: Qt.vector3d(-0.052756, 0.00114274, -6.46114e-05)
                                                    rotation: Qt.quaternion(0.999746, -5.98695e-05, -0.00279444, 0.0223553)
                                                    scale: Qt.vector3d(1, 1, 1)
                                                    Node {
                                                        id: j_Bip_R_Thumb3
                                                        objectName: "J_Bip_R_Thumb3"
                                                        position: Qt.vector3d(-0.0323893, 0.000690162, -4.60148e-05)
                                                        rotation: Qt.quaternion(0.999161, 0.000382159, 0.00800169, -0.0401746)
                                                        scale: Qt.vector3d(1, 1, 1)
                                                    }
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
                    id: j_Bip_L_UpperLeg
                    objectName: "J_Bip_L_UpperLeg"
                    position: Qt.vector3d(0.0853396, -0.0463105, 0.00158563)
                    rotation: Qt.quaternion(0.998623, -0.0524548, 0, 0)
                    scale: Qt.vector3d(1, 1, 1)
                    Node {
                        id: j_Bip_L_LowerLeg
                        objectName: "J_Bip_L_LowerLeg"
                        position: Qt.vector3d(-1.49012e-08, -0.461928, -0.00277995)
                        rotation: Qt.quaternion(0.99974, 0.0228115, 0, 0)
                        scale: Qt.vector3d(1, 1, 1)
                        Node {
                            id: j_Sec_L_CoatSkirtBack_01
                            objectName: "J_Sec_L_CoatSkirtBack_01"
                            position: Qt.vector3d(0.0301625, -0.184404, -0.223139)
                            rotation: Qt.quaternion(0.147704, -0.0687551, 0.985732, 0.0422834)
                            scale: Qt.vector3d(1, 1, 1)
                            Node {
                                id: j_Sec_L_CoatSkirtBack_end_01
                                objectName: "J_Sec_L_CoatSkirtBack_end_01"
                                position: Qt.vector3d(0.0155051, -0.186075, -0.000241607)
                                rotation: Qt.quaternion(1, 2.23517e-08, 7.45058e-09, 1.86265e-08)
                                scale: Qt.vector3d(1, 1, 1)
                                Node {
                                    id: j_Sec_L_CoatSkirtBack_end_01_end
                                    objectName: "J_Sec_L_CoatSkirtBack_end_01_end"
                                    position: Qt.vector3d(0.00581275, -0.0697582, -9.05767e-05)
                                }
                            }
                        }
                        Node {
                            id: j_Sec_L_CoatSkirtFront_01
                            objectName: "J_Sec_L_CoatSkirtFront_01"
                            position: Qt.vector3d(0.0205037, -0.183903, 0.185708)
                            rotation: Qt.quaternion(0.991165, -0.0424111, 0.118396, 0.0421282)
                            scale: Qt.vector3d(1, 1, 1)
                            Node {
                                id: j_Sec_L_CoatSkirtFront_end_01
                                objectName: "J_Sec_L_CoatSkirtFront_end_01"
                                position: Qt.vector3d(-0.0070188, -0.18503, 0.00592194)
                                rotation: Qt.quaternion(1, 2.59606e-08, -3.72529e-09, -1.43191e-08)
                                scale: Qt.vector3d(1, 1, 1)
                                Node {
                                    id: j_Sec_L_CoatSkirtFront_end_01_end
                                    objectName: "J_Sec_L_CoatSkirtFront_end_01_end"
                                    position: Qt.vector3d(-0.00265206, -0.0699139, 0.00223761)
                                }
                            }
                        }
                        Node {
                            id: j_Sec_L_CoatSkirtSide1_01
                            objectName: "J_Sec_L_CoatSkirtSide1_01"
                            position: Qt.vector3d(0.160275, 0.026233, -0.00214953)
                            rotation: Qt.quaternion(0.707988, -0.042575, 0.703415, 0.046344)
                            scale: Qt.vector3d(1, 1, 1)
                            Node {
                                id: j_Sec_L_CoatSkirtSide2_01
                                objectName: "J_Sec_L_CoatSkirtSide2_01"
                                position: Qt.vector3d(-0.00536321, -0.202323, 0.000352979)
                                rotation: Qt.quaternion(1, 9.98261e-09, 1.16881e-07, 1.30385e-08)
                                scale: Qt.vector3d(1, 1, 1)
                                Node {
                                    id: j_Sec_L_CoatSkirtSide2_end_01
                                    objectName: "J_Sec_L_CoatSkirtSide2_end_01"
                                    position: Qt.vector3d(-0.00470615, -0.185712, -0.00333479)
                                    rotation: Qt.quaternion(1, -3.52156e-09, 0, 3.72529e-09)
                                    scale: Qt.vector3d(1, 1, 1)
                                    Node {
                                        id: j_Sec_L_CoatSkirtSide2_end_01_end
                                        objectName: "J_Sec_L_CoatSkirtSide2_end_01_end"
                                        position: Qt.vector3d(-0.00177302, -0.0699663, -0.00125637)
                                    }
                                }
                            }
                        }
                        Node {
                            id: j_Sec_L_CoatSkirtBack_02
                            objectName: "J_Sec_L_CoatSkirtBack_02"
                            position: Qt.vector3d(0.0301625, -0.184404, -0.223139)
                            rotation: Qt.quaternion(0.147704, -0.0687551, 0.985732, 0.0422834)
                            scale: Qt.vector3d(1, 1, 1)
                            Node {
                                id: j_Sec_L_CoatSkirtBack_end_02
                                objectName: "J_Sec_L_CoatSkirtBack_end_02"
                                position: Qt.vector3d(0.0155051, -0.186075, -0.000241607)
                                rotation: Qt.quaternion(1, 2.23517e-08, 7.45058e-09, 1.86265e-08)
                                scale: Qt.vector3d(1, 1, 1)
                                Node {
                                    id: j_Sec_L_CoatSkirtBack_end_02_end
                                    objectName: "J_Sec_L_CoatSkirtBack_end_02_end"
                                    position: Qt.vector3d(0.00581275, -0.0697582, -9.05767e-05)
                                }
                            }
                        }
                        Node {
                            id: j_Sec_L_CoatSkirtFront_02
                            objectName: "J_Sec_L_CoatSkirtFront_02"
                            position: Qt.vector3d(0.0205037, -0.183903, 0.185708)
                            rotation: Qt.quaternion(0.991165, -0.0424111, 0.118396, 0.0421282)
                            scale: Qt.vector3d(1, 1, 1)
                            Node {
                                id: j_Sec_L_CoatSkirtFront_end_02
                                objectName: "J_Sec_L_CoatSkirtFront_end_02"
                                position: Qt.vector3d(-0.0070188, -0.18503, 0.00592194)
                                rotation: Qt.quaternion(1, 2.59606e-08, -3.72529e-09, -1.43191e-08)
                                scale: Qt.vector3d(1, 1, 1)
                                Node {
                                    id: j_Sec_L_CoatSkirtFront_end_02_end
                                    objectName: "J_Sec_L_CoatSkirtFront_end_02_end"
                                    position: Qt.vector3d(-0.00265206, -0.0699139, 0.00223761)
                                }
                            }
                        }
                        Node {
                            id: j_Sec_L_CoatSkirtSide1_02
                            objectName: "J_Sec_L_CoatSkirtSide1_02"
                            position: Qt.vector3d(0.160275, 0.026233, -0.00214953)
                            rotation: Qt.quaternion(0.707988, -0.042575, 0.703415, 0.046344)
                            scale: Qt.vector3d(1, 1, 1)
                            Node {
                                id: j_Sec_L_CoatSkirtSide2_02
                                objectName: "J_Sec_L_CoatSkirtSide2_02"
                                position: Qt.vector3d(-0.00536321, -0.202323, 0.000352979)
                                rotation: Qt.quaternion(1, 9.98261e-09, 1.16881e-07, 1.30385e-08)
                                scale: Qt.vector3d(1, 1, 1)
                                Node {
                                    id: j_Sec_L_CoatSkirtSide2_end_02
                                    objectName: "J_Sec_L_CoatSkirtSide2_end_02"
                                    position: Qt.vector3d(-0.00470615, -0.185712, -0.00333479)
                                    rotation: Qt.quaternion(1, -3.52156e-09, 0, 3.72529e-09)
                                    scale: Qt.vector3d(1, 1, 1)
                                    Node {
                                        id: j_Sec_L_CoatSkirtSide2_end_02_end
                                        objectName: "J_Sec_L_CoatSkirtSide2_end_02_end"
                                        position: Qt.vector3d(-0.00177302, -0.0699663, -0.00125637)
                                    }
                                }
                            }
                        }
                        Node {
                            id: j_Sec_L_CoatSkirtBack_03
                            objectName: "J_Sec_L_CoatSkirtBack_03"
                            position: Qt.vector3d(0.0301625, -0.184404, -0.223139)
                            rotation: Qt.quaternion(0.147704, -0.0687551, 0.985732, 0.0422834)
                            scale: Qt.vector3d(1, 1, 1)
                            Node {
                                id: j_Sec_L_CoatSkirtBack_end_03
                                objectName: "J_Sec_L_CoatSkirtBack_end_03"
                                position: Qt.vector3d(0.0155051, -0.186075, -0.000241607)
                                rotation: Qt.quaternion(1, 2.23517e-08, 7.45058e-09, 1.86265e-08)
                                scale: Qt.vector3d(1, 1, 1)
                                Node {
                                    id: j_Sec_L_CoatSkirtBack_end_03_end
                                    objectName: "J_Sec_L_CoatSkirtBack_end_03_end"
                                    position: Qt.vector3d(0.00581275, -0.0697582, -9.05767e-05)
                                }
                            }
                        }
                        Node {
                            id: j_Sec_L_CoatSkirtFront_03
                            objectName: "J_Sec_L_CoatSkirtFront_03"
                            position: Qt.vector3d(0.0205037, -0.183903, 0.185708)
                            rotation: Qt.quaternion(0.991165, -0.0424111, 0.118396, 0.0421282)
                            scale: Qt.vector3d(1, 1, 1)
                            Node {
                                id: j_Sec_L_CoatSkirtFront_end_03
                                objectName: "J_Sec_L_CoatSkirtFront_end_03"
                                position: Qt.vector3d(-0.0070188, -0.18503, 0.00592194)
                                rotation: Qt.quaternion(1, 2.59606e-08, -3.72529e-09, -1.43191e-08)
                                scale: Qt.vector3d(1, 1, 1)
                                Node {
                                    id: j_Sec_L_CoatSkirtFront_end_03_end
                                    objectName: "J_Sec_L_CoatSkirtFront_end_03_end"
                                    position: Qt.vector3d(-0.00265206, -0.0699139, 0.00223761)
                                }
                            }
                        }
                        Node {
                            id: j_Sec_L_CoatSkirtSide1_03
                            objectName: "J_Sec_L_CoatSkirtSide1_03"
                            position: Qt.vector3d(0.160275, 0.026233, -0.00214953)
                            rotation: Qt.quaternion(0.707988, -0.042575, 0.703415, 0.046344)
                            scale: Qt.vector3d(1, 1, 1)
                            Node {
                                id: j_Sec_L_CoatSkirtSide2_03
                                objectName: "J_Sec_L_CoatSkirtSide2_03"
                                position: Qt.vector3d(-0.00536321, -0.202323, 0.000352979)
                                rotation: Qt.quaternion(1, 9.98261e-09, 1.16881e-07, 1.30385e-08)
                                scale: Qt.vector3d(1, 1, 1)
                                Node {
                                    id: j_Sec_L_CoatSkirtSide2_end_03
                                    objectName: "J_Sec_L_CoatSkirtSide2_end_03"
                                    position: Qt.vector3d(-0.00470615, -0.185712, -0.00333479)
                                    rotation: Qt.quaternion(1, -3.52156e-09, 0, 3.72529e-09)
                                    scale: Qt.vector3d(1, 1, 1)
                                    Node {
                                        id: j_Sec_L_CoatSkirtSide2_end_03_end
                                        objectName: "J_Sec_L_CoatSkirtSide2_end_03_end"
                                        position: Qt.vector3d(-0.00177302, -0.0699663, -0.00125637)
                                    }
                                }
                            }
                        }
                        Node {
                            id: j_Bip_L_Foot
                            objectName: "J_Bip_L_Foot"
                            position: Qt.vector3d(0, -0.523354, 0.00603596)
                            rotation: Qt.quaternion(0.999534, -0.0305294, 0, 0)
                            scale: Qt.vector3d(1, 1, 1)
                            Node {
                                id: j_Bip_L_ToeBase
                                objectName: "J_Bip_L_ToeBase"
                                position: Qt.vector3d(0, -0.0807655, 0.131427)
                                rotation: Qt.quaternion(0.999998, 0.0021667, 0, 0)
                                scale: Qt.vector3d(1, 1, 1)
                            }
                        }
                    }
                }
                Node {
                    id: j_Bip_R_UpperLeg
                    objectName: "J_Bip_R_UpperLeg"
                    position: Qt.vector3d(-0.0853396, -0.0463105, 0.00158563)
                    rotation: Qt.quaternion(0.998623, -0.0524548, 0, 0)
                    scale: Qt.vector3d(1, 1, 1)
                    Node {
                        id: j_Bip_R_LowerLeg
                        objectName: "J_Bip_R_LowerLeg"
                        position: Qt.vector3d(1.49012e-08, -0.461928, -0.00277995)
                        rotation: Qt.quaternion(0.99974, 0.0228115, 0, 0)
                        scale: Qt.vector3d(1, 1, 1)
                        Node {
                            id: j_Sec_R_CoatSkirtBack_01
                            objectName: "J_Sec_R_CoatSkirtBack_01"
                            position: Qt.vector3d(-0.0301625, -0.184404, -0.223139)
                            rotation: Qt.quaternion(-0.147704, 0.0687551, 0.985732, 0.0422834)
                            scale: Qt.vector3d(1, 1, 1)
                            Node {
                                id: j_Sec_R_CoatSkirtBack_end_01
                                objectName: "J_Sec_R_CoatSkirtBack_end_01"
                                position: Qt.vector3d(-0.0155051, -0.186075, -0.000241548)
                                rotation: Qt.quaternion(1, 2.98023e-08, 1.56462e-07, -2.11758e-22)
                                scale: Qt.vector3d(1, 1, 1)
                                Node {
                                    id: j_Sec_R_CoatSkirtBack_end_01_end
                                    objectName: "J_Sec_R_CoatSkirtBack_end_01_end"
                                    position: Qt.vector3d(-0.00581275, -0.0697582, -9.05544e-05)
                                }
                            }
                        }
                        Node {
                            id: j_Sec_R_CoatSkirtFront_01
                            objectName: "J_Sec_R_CoatSkirtFront_01"
                            position: Qt.vector3d(-0.0205037, -0.183903, 0.185708)
                            rotation: Qt.quaternion(0.991165, -0.0424111, -0.118396, -0.0421282)
                            scale: Qt.vector3d(1, 1, 1)
                            Node {
                                id: j_Sec_R_CoatSkirtFront_end_01
                                objectName: "J_Sec_R_CoatSkirtFront_end_01"
                                position: Qt.vector3d(0.00701879, -0.18503, 0.00592199)
                                rotation: Qt.quaternion(1, 2.59606e-08, 3.72529e-09, 1.43191e-08)
                                scale: Qt.vector3d(1, 1, 1)
                                Node {
                                    id: j_Sec_R_CoatSkirtFront_end_01_end
                                    objectName: "J_Sec_R_CoatSkirtFront_end_01_end"
                                    position: Qt.vector3d(0.00265206, -0.0699139, 0.00223763)
                                }
                            }
                        }
                        Node {
                            id: j_Sec_R_CoatSkirtSide1_01
                            objectName: "J_Sec_R_CoatSkirtSide1_01"
                            position: Qt.vector3d(-0.160275, 0.0262333, -0.00214956)
                            rotation: Qt.quaternion(0.707988, -0.042575, -0.703415, -0.046344)
                            scale: Qt.vector3d(1, 1, 1)
                            Node {
                                id: j_Sec_R_CoatSkirtSide2_01
                                objectName: "J_Sec_R_CoatSkirtSide2_01"
                                position: Qt.vector3d(0.00536322, -0.202322, 0.000353038)
                                rotation: Qt.quaternion(1, 9.98261e-09, -1.16881e-07, -1.30385e-08)
                                scale: Qt.vector3d(1, 1, 1)
                                Node {
                                    id: j_Sec_R_CoatSkirtSide2_end_01
                                    objectName: "J_Sec_R_CoatSkirtSide2_end_01"
                                    position: Qt.vector3d(0.00470616, -0.185712, -0.00333482)
                                    rotation: Qt.quaternion(1, -3.52156e-09, 0, -3.72529e-09)
                                    scale: Qt.vector3d(1, 1, 1)
                                    Node {
                                        id: j_Sec_R_CoatSkirtSide2_end_01_end
                                        objectName: "J_Sec_R_CoatSkirtSide2_end_01_end"
                                        position: Qt.vector3d(0.00177302, -0.0699663, -0.00125638)
                                    }
                                }
                            }
                        }
                        Node {
                            id: j_Sec_R_CoatSkirtBack_02
                            objectName: "J_Sec_R_CoatSkirtBack_02"
                            position: Qt.vector3d(-0.0301625, -0.184404, -0.223139)
                            rotation: Qt.quaternion(-0.147704, 0.0687551, 0.985732, 0.0422834)
                            scale: Qt.vector3d(1, 1, 1)
                            Node {
                                id: j_Sec_R_CoatSkirtBack_end_02
                                objectName: "J_Sec_R_CoatSkirtBack_end_02"
                                position: Qt.vector3d(-0.0155051, -0.186075, -0.000241548)
                                rotation: Qt.quaternion(1, 2.98023e-08, 1.56462e-07, -2.11758e-22)
                                scale: Qt.vector3d(1, 1, 1)
                                Node {
                                    id: j_Sec_R_CoatSkirtBack_end_02_end
                                    objectName: "J_Sec_R_CoatSkirtBack_end_02_end"
                                    position: Qt.vector3d(-0.00581275, -0.0697582, -9.05544e-05)
                                }
                            }
                        }
                        Node {
                            id: j_Sec_R_CoatSkirtFront_02
                            objectName: "J_Sec_R_CoatSkirtFront_02"
                            position: Qt.vector3d(-0.0205037, -0.183903, 0.185708)
                            rotation: Qt.quaternion(0.991165, -0.0424111, -0.118396, -0.0421282)
                            scale: Qt.vector3d(1, 1, 1)
                            Node {
                                id: j_Sec_R_CoatSkirtFront_end_02
                                objectName: "J_Sec_R_CoatSkirtFront_end_02"
                                position: Qt.vector3d(0.00701879, -0.18503, 0.00592199)
                                rotation: Qt.quaternion(1, 2.59606e-08, 3.72529e-09, 1.43191e-08)
                                scale: Qt.vector3d(1, 1, 1)
                                Node {
                                    id: j_Sec_R_CoatSkirtFront_end_02_end
                                    objectName: "J_Sec_R_CoatSkirtFront_end_02_end"
                                    position: Qt.vector3d(0.00265206, -0.0699139, 0.00223763)
                                }
                            }
                        }
                        Node {
                            id: j_Sec_R_CoatSkirtSide1_02
                            objectName: "J_Sec_R_CoatSkirtSide1_02"
                            position: Qt.vector3d(-0.160275, 0.0262333, -0.00214956)
                            rotation: Qt.quaternion(0.707988, -0.042575, -0.703415, -0.046344)
                            scale: Qt.vector3d(1, 1, 1)
                            Node {
                                id: j_Sec_R_CoatSkirtSide2_02
                                objectName: "J_Sec_R_CoatSkirtSide2_02"
                                position: Qt.vector3d(0.00536322, -0.202322, 0.000353038)
                                rotation: Qt.quaternion(1, 9.98261e-09, -1.16881e-07, -1.30385e-08)
                                scale: Qt.vector3d(1, 1, 1)
                                Node {
                                    id: j_Sec_R_CoatSkirtSide2_end_02
                                    objectName: "J_Sec_R_CoatSkirtSide2_end_02"
                                    position: Qt.vector3d(0.00470616, -0.185712, -0.00333482)
                                    rotation: Qt.quaternion(1, -3.52156e-09, 0, -3.72529e-09)
                                    scale: Qt.vector3d(1, 1, 1)
                                    Node {
                                        id: j_Sec_R_CoatSkirtSide2_end_02_end
                                        objectName: "J_Sec_R_CoatSkirtSide2_end_02_end"
                                        position: Qt.vector3d(0.00177302, -0.0699663, -0.00125638)
                                    }
                                }
                            }
                        }
                        Node {
                            id: j_Sec_R_CoatSkirtBack_03
                            objectName: "J_Sec_R_CoatSkirtBack_03"
                            position: Qt.vector3d(-0.0301625, -0.184404, -0.223139)
                            rotation: Qt.quaternion(-0.147704, 0.0687551, 0.985732, 0.0422834)
                            scale: Qt.vector3d(1, 1, 1)
                            Node {
                                id: j_Sec_R_CoatSkirtBack_end_03
                                objectName: "J_Sec_R_CoatSkirtBack_end_03"
                                position: Qt.vector3d(-0.0155051, -0.186075, -0.000241548)
                                rotation: Qt.quaternion(1, 2.98023e-08, 1.56462e-07, -2.11758e-22)
                                scale: Qt.vector3d(1, 1, 1)
                                Node {
                                    id: j_Sec_R_CoatSkirtBack_end_03_end
                                    objectName: "J_Sec_R_CoatSkirtBack_end_03_end"
                                    position: Qt.vector3d(-0.00581275, -0.0697582, -9.05544e-05)
                                }
                            }
                        }
                        Node {
                            id: j_Sec_R_CoatSkirtFront_03
                            objectName: "J_Sec_R_CoatSkirtFront_03"
                            position: Qt.vector3d(-0.0205037, -0.183903, 0.185708)
                            rotation: Qt.quaternion(0.991165, -0.0424111, -0.118396, -0.0421282)
                            scale: Qt.vector3d(1, 1, 1)
                            Node {
                                id: j_Sec_R_CoatSkirtFront_end_03
                                objectName: "J_Sec_R_CoatSkirtFront_end_03"
                                position: Qt.vector3d(0.00701879, -0.18503, 0.00592199)
                                rotation: Qt.quaternion(1, 2.59606e-08, 3.72529e-09, 1.43191e-08)
                                scale: Qt.vector3d(1, 1, 1)
                                Node {
                                    id: j_Sec_R_CoatSkirtFront_end_03_end
                                    objectName: "J_Sec_R_CoatSkirtFront_end_03_end"
                                    position: Qt.vector3d(0.00265206, -0.0699139, 0.00223763)
                                }
                            }
                        }
                        Node {
                            id: j_Sec_R_CoatSkirtSide1_03
                            objectName: "J_Sec_R_CoatSkirtSide1_03"
                            position: Qt.vector3d(-0.160275, 0.0262333, -0.00214956)
                            rotation: Qt.quaternion(0.707988, -0.042575, -0.703415, -0.046344)
                            scale: Qt.vector3d(1, 1, 1)
                            Node {
                                id: j_Sec_R_CoatSkirtSide2_03
                                objectName: "J_Sec_R_CoatSkirtSide2_03"
                                position: Qt.vector3d(0.00536322, -0.202322, 0.000353038)
                                rotation: Qt.quaternion(1, 9.98261e-09, -1.16881e-07, -1.30385e-08)
                                scale: Qt.vector3d(1, 1, 1)
                                Node {
                                    id: j_Sec_R_CoatSkirtSide2_end_03
                                    objectName: "J_Sec_R_CoatSkirtSide2_end_03"
                                    position: Qt.vector3d(0.00470616, -0.185712, -0.00333482)
                                    rotation: Qt.quaternion(1, -3.52156e-09, 0, -3.72529e-09)
                                    scale: Qt.vector3d(1, 1, 1)
                                    Node {
                                        id: j_Sec_R_CoatSkirtSide2_end_03_end
                                        objectName: "J_Sec_R_CoatSkirtSide2_end_03_end"
                                        position: Qt.vector3d(0.00177302, -0.0699663, -0.00125638)
                                    }
                                }
                            }
                        }
                        Node {
                            id: j_Bip_R_Foot
                            objectName: "J_Bip_R_Foot"
                            position: Qt.vector3d(0, -0.523354, 0.00603596)
                            rotation: Qt.quaternion(0.999534, -0.0305294, 0, 0)
                            scale: Qt.vector3d(1, 1, 1)
                            Node {
                                id: j_Bip_R_ToeBase
                                objectName: "J_Bip_R_ToeBase"
                                position: Qt.vector3d(0, -0.0807655, 0.131427)
                                rotation: Qt.quaternion(0.999998, 0.0021667, 0, 0)
                                scale: Qt.vector3d(1, 1, 1)
                            }
                        }
                    }
                }
            }
        }
        Model {
            id: face
            objectName: "Face"
            source: "meshes/face_mesh.mesh"
            skin: skin226
            materials: [n00_000_00_FaceMouth_00_FACE__Instance__material, n00_000_00_EyeIris_00_EYE__Instance__material, n00_000_00_EyeHighlight_00_EYE__Instance__material, n00_000_00_Face_00_SKIN__Instance__material, n00_000_00_EyeWhite_00_EYE__Instance__material, n00_000_00_FaceBrow_00_FACE__Instance__material, n00_000_00_FaceEyeline_00_FACE__Instance__material]
            morphTargets: [fcl_ALL_Neutral_morphtarget227, fcl_ALL_Angry_morphtarget228, fcl_ALL_Fun_morphtarget229, fcl_ALL_Joy_morphtarget230, fcl_ALL_Sorrow_morphtarget231, fcl_ALL_Surprised_morphtarget232, fcl_BRW_Angry_morphtarget233, fcl_BRW_Fun_morphtarget234, fcl_BRW_Joy_morphtarget235, fcl_BRW_Sorrow_morphtarget236, fcl_BRW_Surprised_morphtarget237, fcl_EYE_Natural_morphtarget238, fcl_EYE_Angry_morphtarget239, fcl_EYE_Close_morphtarget240, fcl_EYE_Close_R_morphtarget241, fcl_EYE_Close_L_morphtarget242, fcl_EYE_Fun_morphtarget243, fcl_EYE_Joy_morphtarget244, fcl_EYE_Joy_R_morphtarget245, fcl_EYE_Joy_L_morphtarget246, fcl_EYE_Sorrow_morphtarget247, fcl_EYE_Surprised_morphtarget248, fcl_EYE_Spread_morphtarget249, fcl_EYE_Iris_Hide_morphtarget250, fcl_EYE_Highlight_Hide_morphtarget251, fcl_MTH_Close_morphtarget252, fcl_MTH_Up_morphtarget253, fcl_MTH_Down_morphtarget254, fcl_MTH_Angry_morphtarget255, fcl_MTH_Small_morphtarget256, fcl_MTH_Large_morphtarget257, fcl_MTH_Neutral_morphtarget258, fcl_MTH_Fun_morphtarget259, fcl_MTH_Joy_morphtarget260, fcl_MTH_Sorrow_morphtarget261, fcl_MTH_Surprised_morphtarget262, fcl_MTH_SkinFung_morphtarget263, fcl_MTH_SkinFung_R_morphtarget264, fcl_MTH_SkinFung_L_morphtarget265, fcl_MTH_A_morphtarget266, fcl_MTH_I_morphtarget267, fcl_MTH_U_morphtarget268, fcl_MTH_E_morphtarget269, fcl_MTH_O_morphtarget270, fcl_HA_Hide_morphtarget271, fcl_HA_Fung1_morphtarget272, fcl_HA_Fung1_Low_morphtarget273, fcl_HA_Fung1_Up_morphtarget274, fcl_HA_Fung2_morphtarget275, fcl_HA_Fung2_Low_morphtarget276, fcl_HA_Fung2_Up_morphtarget277, fcl_HA_Fung3_morphtarget278, fcl_HA_Fung3_Up_morphtarget279, fcl_HA_Fung3_Low_morphtarget280, fcl_HA_Short_morphtarget281, fcl_HA_Short_Up_morphtarget282, fcl_HA_Short_Low_morphtarget283, fcl_ALL_Neutral_morphtarget284, fcl_ALL_Angry_morphtarget285, fcl_ALL_Fun_morphtarget286, fcl_ALL_Joy_morphtarget287, fcl_ALL_Sorrow_morphtarget288, fcl_ALL_Surprised_morphtarget289, fcl_BRW_Angry_morphtarget290, fcl_BRW_Fun_morphtarget291, fcl_BRW_Joy_morphtarget292, fcl_BRW_Sorrow_morphtarget293, fcl_BRW_Surprised_morphtarget294, fcl_EYE_Natural_morphtarget295, fcl_EYE_Angry_morphtarget296, fcl_EYE_Close_morphtarget297, fcl_EYE_Close_R_morphtarget298, fcl_EYE_Close_L_morphtarget299, fcl_EYE_Fun_morphtarget300, fcl_EYE_Joy_morphtarget301, fcl_EYE_Joy_R_morphtarget302, fcl_EYE_Joy_L_morphtarget303, fcl_EYE_Sorrow_morphtarget304, fcl_EYE_Surprised_morphtarget305, fcl_EYE_Spread_morphtarget306, fcl_EYE_Iris_Hide_morphtarget307, fcl_EYE_Highlight_Hide_morphtarget308, fcl_MTH_Close_morphtarget309, fcl_MTH_Up_morphtarget310, fcl_MTH_Down_morphtarget311, fcl_MTH_Angry_morphtarget312, fcl_MTH_Small_morphtarget313, fcl_MTH_Large_morphtarget314, fcl_MTH_Neutral_morphtarget315, fcl_MTH_Fun_morphtarget316, fcl_MTH_Joy_morphtarget317, fcl_MTH_Sorrow_morphtarget318, fcl_MTH_Surprised_morphtarget319, fcl_MTH_SkinFung_morphtarget320, fcl_MTH_SkinFung_R_morphtarget321, fcl_MTH_SkinFung_L_morphtarget322, fcl_MTH_A_morphtarget323, fcl_MTH_I_morphtarget324, fcl_MTH_U_morphtarget325, fcl_MTH_E_morphtarget326, fcl_MTH_O_morphtarget327, fcl_HA_Hide_morphtarget328, fcl_HA_Fung1_morphtarget329, fcl_HA_Fung1_Low_morphtarget330, fcl_HA_Fung1_Up_morphtarget331, fcl_HA_Fung2_morphtarget332, fcl_HA_Fung2_Low_morphtarget333, fcl_HA_Fung2_Up_morphtarget334, fcl_HA_Fung3_morphtarget335, fcl_HA_Fung3_Up_morphtarget336, fcl_HA_Fung3_Low_morphtarget337, fcl_HA_Short_morphtarget338, fcl_HA_Short_Up_morphtarget339, fcl_HA_Short_Low_morphtarget340, fcl_ALL_Neutral_morphtarget341, fcl_ALL_Angry_morphtarget342, fcl_ALL_Fun_morphtarget343, fcl_ALL_Joy_morphtarget344, fcl_ALL_Sorrow_morphtarget345, fcl_ALL_Surprised_morphtarget346, fcl_BRW_Angry_morphtarget347, fcl_BRW_Fun_morphtarget348, fcl_BRW_Joy_morphtarget349, fcl_BRW_Sorrow_morphtarget350, fcl_BRW_Surprised_morphtarget351, fcl_EYE_Natural_morphtarget352, fcl_EYE_Angry_morphtarget353, fcl_EYE_Close_morphtarget354, fcl_EYE_Close_R_morphtarget355, fcl_EYE_Close_L_morphtarget356, fcl_EYE_Fun_morphtarget357, fcl_EYE_Joy_morphtarget358, fcl_EYE_Joy_R_morphtarget359, fcl_EYE_Joy_L_morphtarget360, fcl_EYE_Sorrow_morphtarget361, fcl_EYE_Surprised_morphtarget362, fcl_EYE_Spread_morphtarget363, fcl_EYE_Iris_Hide_morphtarget364, fcl_EYE_Highlight_Hide_morphtarget365, fcl_MTH_Close_morphtarget366, fcl_MTH_Up_morphtarget367, fcl_MTH_Down_morphtarget368, fcl_MTH_Angry_morphtarget369, fcl_MTH_Small_morphtarget370, fcl_MTH_Large_morphtarget371, fcl_MTH_Neutral_morphtarget372, fcl_MTH_Fun_morphtarget373, fcl_MTH_Joy_morphtarget374, fcl_MTH_Sorrow_morphtarget375, fcl_MTH_Surprised_morphtarget376, fcl_MTH_SkinFung_morphtarget377, fcl_MTH_SkinFung_R_morphtarget378, fcl_MTH_SkinFung_L_morphtarget379, fcl_MTH_A_morphtarget380, fcl_MTH_I_morphtarget381, fcl_MTH_U_morphtarget382, fcl_MTH_E_morphtarget383, fcl_MTH_O_morphtarget384, fcl_HA_Hide_morphtarget385, fcl_HA_Fung1_morphtarget386, fcl_HA_Fung1_Low_morphtarget387, fcl_HA_Fung1_Up_morphtarget388, fcl_HA_Fung2_morphtarget389, fcl_HA_Fung2_Low_morphtarget390, fcl_HA_Fung2_Up_morphtarget391, fcl_HA_Fung3_morphtarget392, fcl_HA_Fung3_Up_morphtarget393, fcl_HA_Fung3_Low_morphtarget394, fcl_HA_Short_morphtarget395, fcl_HA_Short_Up_morphtarget396, fcl_HA_Short_Low_morphtarget397, fcl_ALL_Neutral_morphtarget398, fcl_ALL_Angry_morphtarget399, fcl_ALL_Fun_morphtarget400, fcl_ALL_Joy_morphtarget401, fcl_ALL_Sorrow_morphtarget402, fcl_ALL_Surprised_morphtarget403, fcl_BRW_Angry_morphtarget404, fcl_BRW_Fun_morphtarget405, fcl_BRW_Joy_morphtarget406, fcl_BRW_Sorrow_morphtarget407, fcl_BRW_Surprised_morphtarget408, fcl_EYE_Natural_morphtarget409, fcl_EYE_Angry_morphtarget410, fcl_EYE_Close_morphtarget411, fcl_EYE_Close_R_morphtarget412, fcl_EYE_Close_L_morphtarget413, fcl_EYE_Fun_morphtarget414, fcl_EYE_Joy_morphtarget415, fcl_EYE_Joy_R_morphtarget416, fcl_EYE_Joy_L_morphtarget417, fcl_EYE_Sorrow_morphtarget418, fcl_EYE_Surprised_morphtarget419, fcl_EYE_Spread_morphtarget420, fcl_EYE_Iris_Hide_morphtarget421, fcl_EYE_Highlight_Hide_morphtarget422, fcl_MTH_Close_morphtarget423, fcl_MTH_Up_morphtarget424, fcl_MTH_Down_morphtarget425, fcl_MTH_Angry_morphtarget426, fcl_MTH_Small_morphtarget427, fcl_MTH_Large_morphtarget428, fcl_MTH_Neutral_morphtarget429, fcl_MTH_Fun_morphtarget430, fcl_MTH_Joy_morphtarget431, fcl_MTH_Sorrow_morphtarget432, fcl_MTH_Surprised_morphtarget433, fcl_MTH_SkinFung_morphtarget434, fcl_MTH_SkinFung_R_morphtarget435, fcl_MTH_SkinFung_L_morphtarget436, fcl_MTH_A_morphtarget437, fcl_MTH_I_morphtarget438, fcl_MTH_U_morphtarget439, fcl_MTH_E_morphtarget440, fcl_MTH_O_morphtarget441, fcl_HA_Hide_morphtarget442, fcl_HA_Fung1_morphtarget443, fcl_HA_Fung1_Low_morphtarget444, fcl_HA_Fung1_Up_morphtarget445, fcl_HA_Fung2_morphtarget446, fcl_HA_Fung2_Low_morphtarget447, fcl_HA_Fung2_Up_morphtarget448, fcl_HA_Fung3_morphtarget449, fcl_HA_Fung3_Up_morphtarget450, fcl_HA_Fung3_Low_morphtarget451, fcl_HA_Short_morphtarget452, fcl_HA_Short_Up_morphtarget453, fcl_HA_Short_Low_morphtarget454, fcl_ALL_Neutral_morphtarget455, fcl_ALL_Angry_morphtarget456, fcl_ALL_Fun_morphtarget457, fcl_ALL_Joy_morphtarget458, fcl_ALL_Sorrow_morphtarget459, fcl_ALL_Surprised_morphtarget460, fcl_BRW_Angry_morphtarget461, fcl_BRW_Fun_morphtarget462, fcl_BRW_Joy_morphtarget463, fcl_BRW_Sorrow_morphtarget464, fcl_BRW_Surprised_morphtarget465, fcl_EYE_Natural_morphtarget466, fcl_EYE_Angry_morphtarget467, fcl_EYE_Close_morphtarget468, fcl_EYE_Close_R_morphtarget469, fcl_EYE_Close_L_morphtarget470, fcl_EYE_Fun_morphtarget471, fcl_EYE_Joy_morphtarget472, fcl_EYE_Joy_R_morphtarget473, fcl_EYE_Joy_L_morphtarget474, fcl_EYE_Sorrow_morphtarget475, fcl_EYE_Surprised_morphtarget476, fcl_EYE_Spread_morphtarget477, fcl_EYE_Iris_Hide_morphtarget478, fcl_EYE_Highlight_Hide_morphtarget479, fcl_MTH_Close_morphtarget480, fcl_MTH_Up_morphtarget481, fcl_MTH_Down_morphtarget, fcl_MTH_Angry_morphtarget, fcl_MTH_Small_morphtarget, fcl_MTH_Large_morphtarget, fcl_MTH_Neutral_morphtarget, fcl_MTH_Fun_morphtarget, fcl_MTH_Joy_morphtarget, fcl_MTH_Sorrow_morphtarget, fcl_MTH_Surprised_morphtarget, fcl_MTH_SkinFung_morphtarget, fcl_MTH_SkinFung_R_morphtarget, fcl_MTH_SkinFung_L_morphtarget, fcl_MTH_A_morphtarget, fcl_MTH_I_morphtarget, fcl_MTH_U_morphtarget, fcl_MTH_E_morphtarget, fcl_MTH_O_morphtarget, fcl_HA_Hide_morphtarget, fcl_HA_Fung1_morphtarget, fcl_HA_Fung1_Low_morphtarget, fcl_HA_Fung1_Up_morphtarget, fcl_HA_Fung2_morphtarget, fcl_HA_Fung2_Low_morphtarget, fcl_HA_Fung2_Up_morphtarget, fcl_HA_Fung3_morphtarget, fcl_HA_Fung3_Up_morphtarget, fcl_HA_Fung3_Low_morphtarget, fcl_HA_Short_morphtarget, fcl_HA_Short_Up_morphtarget, fcl_HA_Short_Low_morphtarget, fcl_ALL_Neutral_morphtarget, fcl_ALL_Angry_morphtarget, fcl_ALL_Fun_morphtarget, fcl_ALL_Joy_morphtarget, fcl_ALL_Sorrow_morphtarget, fcl_ALL_Surprised_morphtarget, fcl_BRW_Angry_morphtarget, fcl_BRW_Fun_morphtarget, fcl_BRW_Joy_morphtarget, fcl_BRW_Sorrow_morphtarget, fcl_BRW_Surprised_morphtarget, fcl_EYE_Natural_morphtarget, fcl_EYE_Angry_morphtarget, fcl_EYE_Close_morphtarget, fcl_EYE_Close_R_morphtarget, fcl_EYE_Close_L_morphtarget, fcl_EYE_Fun_morphtarget, fcl_EYE_Joy_morphtarget, fcl_EYE_Joy_R_morphtarget, fcl_EYE_Joy_L_morphtarget, fcl_EYE_Sorrow_morphtarget, fcl_EYE_Surprised_morphtarget, fcl_EYE_Spread_morphtarget, fcl_EYE_Iris_Hide_morphtarget, fcl_EYE_Highlight_Hide_morphtarget, fcl_MTH_Close_morphtarget, fcl_MTH_Up_morphtarget, fcl_MTH_Down_morphtarget539, fcl_MTH_Angry_morphtarget540, fcl_MTH_Small_morphtarget541, fcl_MTH_Large_morphtarget542, fcl_MTH_Neutral_morphtarget543, fcl_MTH_Fun_morphtarget544, fcl_MTH_Joy_morphtarget545, fcl_MTH_Sorrow_morphtarget546, fcl_MTH_Surprised_morphtarget547, fcl_MTH_SkinFung_morphtarget548, fcl_MTH_SkinFung_R_morphtarget549, fcl_MTH_SkinFung_L_morphtarget550, fcl_MTH_A_morphtarget551, fcl_MTH_I_morphtarget552, fcl_MTH_U_morphtarget553, fcl_MTH_E_morphtarget554, fcl_MTH_O_morphtarget555, fcl_HA_Hide_morphtarget556, fcl_HA_Fung1_morphtarget557, fcl_HA_Fung1_Low_morphtarget558, fcl_HA_Fung1_Up_morphtarget559, fcl_HA_Fung2_morphtarget560, fcl_HA_Fung2_Low_morphtarget561, fcl_HA_Fung2_Up_morphtarget562, fcl_HA_Fung3_morphtarget563, fcl_HA_Fung3_Up_morphtarget564, fcl_HA_Fung3_Low_morphtarget565, fcl_HA_Short_morphtarget566, fcl_HA_Short_Up_morphtarget567, fcl_HA_Short_Low_morphtarget568, fcl_ALL_Neutral_morphtarget569, fcl_ALL_Angry_morphtarget570, fcl_ALL_Fun_morphtarget571, fcl_ALL_Joy_morphtarget572, fcl_ALL_Sorrow_morphtarget573, fcl_ALL_Surprised_morphtarget574, fcl_BRW_Angry_morphtarget575, fcl_BRW_Fun_morphtarget576, fcl_BRW_Joy_morphtarget577, fcl_BRW_Sorrow_morphtarget578, fcl_BRW_Surprised_morphtarget579, fcl_EYE_Natural_morphtarget580, fcl_EYE_Angry_morphtarget581, fcl_EYE_Close_morphtarget582, fcl_EYE_Close_R_morphtarget583, fcl_EYE_Close_L_morphtarget584, fcl_EYE_Fun_morphtarget585, fcl_EYE_Joy_morphtarget586, fcl_EYE_Joy_R_morphtarget587, fcl_EYE_Joy_L_morphtarget588, fcl_EYE_Sorrow_morphtarget589, fcl_EYE_Surprised_morphtarget590, fcl_EYE_Spread_morphtarget591, fcl_EYE_Iris_Hide_morphtarget592, fcl_EYE_Highlight_Hide_morphtarget593, fcl_MTH_Close_morphtarget594, fcl_MTH_Up_morphtarget595, fcl_MTH_Down_morphtarget596, fcl_MTH_Angry_morphtarget597, fcl_MTH_Small_morphtarget598, fcl_MTH_Large_morphtarget599, fcl_MTH_Neutral_morphtarget600, fcl_MTH_Fun_morphtarget601, fcl_MTH_Joy_morphtarget602, fcl_MTH_Sorrow_morphtarget603, fcl_MTH_Surprised_morphtarget604, fcl_MTH_SkinFung_morphtarget605, fcl_MTH_SkinFung_R_morphtarget606, fcl_MTH_SkinFung_L_morphtarget607, fcl_MTH_A_morphtarget608, fcl_MTH_I_morphtarget609, fcl_MTH_U_morphtarget610, fcl_MTH_E_morphtarget611, fcl_MTH_O_morphtarget612, fcl_HA_Hide_morphtarget613, fcl_HA_Fung1_morphtarget614, fcl_HA_Fung1_Low_morphtarget615, fcl_HA_Fung1_Up_morphtarget616, fcl_HA_Fung2_morphtarget617, fcl_HA_Fung2_Low_morphtarget618, fcl_HA_Fung2_Up_morphtarget619, fcl_HA_Fung3_morphtarget620, fcl_HA_Fung3_Up_morphtarget621, fcl_HA_Fung3_Low_morphtarget622, fcl_HA_Short_morphtarget623, fcl_HA_Short_Up_morphtarget624, fcl_HA_Short_Low_morphtarget625]
        }
        Model {
            id: body
            objectName: "Body"
            source: "meshes/body_mesh.mesh"
            skin: skin653
            materials: [n00_000_00_Body_00_SKIN__Instance__material, n00_007_01_Tops_01_CLOTH_01__Instance__material, n00_007_01_Tops_01_CLOTH_02__Instance__material, n00_007_01_Tops_01_CLOTH_03__Instance__material, n00_000_00_HairBack_00_HAIR__Instance__material, n00_001_02_Bottoms_01_CLOTH__Instance__material, n00_008_01_Shoes_01_CLOTH__Instance__material]
        }
        Model {
            id: hair
            objectName: "Hair"
            source: "meshes/hair001__merged__mesh.mesh"
            skin: skin
            materials: [n00_000_Hair_00_HAIR__Instance__material]
        }
    }

    // Animations:
}
