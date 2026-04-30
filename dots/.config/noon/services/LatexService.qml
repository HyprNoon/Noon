pragma Singleton
pragma ComponentBehavior: Bound
// import Noon.Utils.Latex
import QtQuick
import Quickshell

Singleton {
    id: root

    property var renderedImagePaths: ({})
    property var latexExpressions: ({})

    signal renderFinished(string hash, string imagePath)

    // readonly property LatexRenderer renderer: LatexRenderer {
    //     fontSize: 18
    //     padding: 4
    // }

    function detectAndRenderLatex(content, colorHex = "#ffffff") {
        const contentStr = String(content ?? "");
        if (!contentStr)
            return [];

        const regex = /\$\$([\s\S]+?)\$\$|\$([^\$\n]+?)\$|\\\[([\s\S]+?)\\\]|\\\(([\s\S]+?)\\\)/g;
        let match;
        const hashes = [];

        while ((match = regex.exec(contentStr)) !== null) {
            const raw = match[0];
            const expr = (match[1] || match[2] || match[3] || match[4] || "").trim();
            if (!expr)
                continue;

            const hash = Qt.md5(expr + colorHex);
            latexExpressions[hash] = raw;
            hashes.push(hash);

            if (!renderedImagePaths[hash]) {
                const path = renderer.render(expr, colorHex);
                if (path) {
                    renderedImagePaths[hash] = path;
                    renderFinished(hash, path);
                }
            }
        }
        return hashes;
    }

    function replaceLatexWithImages(content, hashes) {
        let result = String(content ?? "");
        if (!hashes || hashes.length === 0)
            return result;

        const sorted = [...hashes].sort((a, b) => (latexExpressions[b] || "").length - (latexExpressions[a] || "").length);

        for (const hash of sorted) {
            const path = renderedImagePaths[hash];
            const original = latexExpressions[hash];
            if (path && original) {
                result = result.split(original).join(`![latex](${path})`);
            }
        }
        return result;
    }
}
