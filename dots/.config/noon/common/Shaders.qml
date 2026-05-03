pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import qs.common.utils
import qs.common.functions
import qs.common.widgets
import Qt.labs.folderlistmodel

/*
    Simple Wrapper for Shaders..
*/
Singleton {
    id: root

    readonly property bool enabled: (isValidShader && opts.shaders) ?? false
    readonly property string currentShaderName: opts.currentShader
    readonly property var available: opts.availableShaders
    readonly property bool isValidShader: (currentShaderName !== "none" && available.includes(currentShaderName))
    readonly property var opts: Mem.options.appearance.effects

    readonly property Component currentShaderComp: {
        const path = Qt.resolvedUrl(`widgets/${StringUtils.capitalizeFirstLetter(currentShaderName)}Shader.qml`);
        return Qt.createComponent(path);
    }

    function reload() {
        opts.availableShaders = [];
        opts.availableShaders.push("none");
        for (let i = 0; i < diskModel.count; i++)
            opts.availableShaders.push(diskModel.get(i, "fileBaseName"));
    }

    FolderListModel {
        id: diskModel
        nameFilters: ["*.frag.qsb"]
        folder: Qt.resolvedUrl("widgets/shaders")
        showDirs: false
        showFiles: true
        onCountChanged: {
            if (root.available.length < count)
                root.reload();
        }
    }
}
