pragma Singleton
pragma ComponentBehavior: Bound

import qs.common.functions
import qs.common
import QtQuick
import Quickshell
import Noon.Utils.Latex

Singleton {
    id: root

    property list<string> processedHashes: []
    property string latexOutputPath: FileUtils.trimFileProtocol(Directories.services.latex)

    signal renderFinished(string hash, string imagePath)

    property LatexRenderer _renderer: LatexRenderer {
        width: 0
        height: 0
        visible: false
        cacheDir: root.latexOutputPath
        foreground: Colors.colOnLayer1
    }

    Component.onCompleted: {
        _renderer.cached.connect((hash, filePath) => {
            if (root.processedHashes.includes(hash)) {
                root.renderFinished(hash, filePath);
            }
        });
    }

    function requestRender(expression) {
        if (!expression)
            return ["", false];
        const hash = _renderer.hashFor(expression);

        if (!root.processedHashes.includes(hash)) {
            root.processedHashes.push(hash);

            if (_renderer.isCached(expression)) {
                root.renderFinished(hash, `${root.latexOutputPath}/${hash}.png`);
                return [hash, true];
            }

            _renderer.preRender(expression);
            return [hash, false];
        }

        return [hash, _renderer.isCached(expression)];
    }

    function cleanFormula(input) {
        if (!input)
            return "";
        return input.replace(/^\$\$[\s\S]*?\$\$/gm, m => m.slice(2, -2).trim()).replace(/\\\(/g, '').replace(/\\\)/g, '').replace(/\\\[/g, '').replace(/\\\]/g, '').replace(/^\$|\$$/gm, '').trim();
    }
}
