import QtQuick
import QtQuick3D

Node {
    id: node
    property alias baseColor: material0_material.baseColor
    // Resources
    PrincipledMaterial {
        id: material0_material
        objectName: "material0"
        roughness: 1
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }

    // Nodes:
    Node {
        id: sketchfab_model
        objectName: "Sketchfab_model"
        position: Qt.vector3d(-0.0193769, -1.2612e-16, 0.567993)
        rotation: Qt.quaternion(1.57009e-16, -4.32978e-17, 0.707107, 0.707107)
        scale: Qt.vector3d(0.112769, 0.112769, 0.112769)
        Node {
            id: node123e8ee908d3496daa7045ceadb9e181_fbx
            objectName: "123e8ee908d3496daa7045ceadb9e181.fbx"
            rotation: Qt.quaternion(0.707107, 0.707107, 0, 0)
            Node {
                id: rootNode
                objectName: "RootNode"
                Node {
                    id: merged_Extract6
                    objectName: "Merged_Extract6"
                    Model {
                        id: merged_Extract6_material0_0
                        objectName: "Merged_Extract6_material0_0"
                        source: "meshes/merged_Extract6_material0_0_mesh.mesh"
                        materials: [material0_material]
                    }
                    Model {
                        id: merged_Extract6_material0_08
                        objectName: "Merged_Extract6_material0_0"
                        source: "meshes/merged_Extract6_material0_0_mesh9.mesh"
                        materials: [material0_material]
                    }
                    Model {
                        id: merged_Extract6_material0_010
                        objectName: "Merged_Extract6_material0_0"
                        source: "meshes/merged_Extract6_material0_0_mesh11.mesh"
                        materials: [material0_material]
                    }
                    Model {
                        id: merged_Extract6_material0_012
                        objectName: "Merged_Extract6_material0_0"
                        source: "meshes/merged_Extract6_material0_0_mesh13.mesh"
                        materials: [material0_material]
                    }
                    Model {
                        id: merged_Extract6_material0_014
                        objectName: "Merged_Extract6_material0_0"
                        source: "meshes/merged_Extract6_material0_0_mesh15.mesh"
                        materials: [material0_material]
                    }
                    Model {
                        id: merged_Extract6_material0_016
                        objectName: "Merged_Extract6_material0_0"
                        source: "meshes/merged_Extract6_material0_0_mesh17.mesh"
                        materials: [material0_material]
                    }
                }
            }
        }
    }

    // Animations:
}
