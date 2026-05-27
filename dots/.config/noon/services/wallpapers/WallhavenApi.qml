import QtQuick
import qs.common

QtObject {
    id: root

    property string apiKey: Mem.options.keys.wallhaven

    readonly property string endpoint: "https://wallhaven.cc/api/v1/search"
    readonly property var categories: [
        {
            label: "Hot",
            icon: "mode_heat",
            sorting: "toplist",
            range: "1w"
        },
        {
            label: "Latest",
            icon: "app_badging",
            sorting: "date_added",
            range: ""
        },
        {
            label: "Top",
            icon: "social_leaderboard",
            sorting: "toplist",
            range: "1M"
        },
        {
            label: "Views",
            icon: "play_arrow",
            sorting: "views",
            range: ""
        },
        {
            label: "Random",
            icon: "shuffle",
            sorting: "random",
            range: ""
        }
    ]

    function buildUrl(page, query, categoryIndex) {
        const cat = root.categories[categoryIndex];
        let url = root.endpoint + "?sorting=" + cat.sorting + "&page=" + page + "&categories=110" + "&purity=100";

        if (query)
            url += "&q=" + encodeURIComponent(query);
        if (cat.range)
            url += "&toplist_range=" + cat.range;
        if (root.apiKey)
            url += "&apikey=" + root.apiKey;

        return url;
    }

    function normalizeResults(data) {
        return data.map(function (w) {
            return {
                id: w.id,
                thumbUrl: w.thumbs.large,
                fullUrl: w.path,
                resolution: w.resolution,
                fileType: w.file_type
            };
        });
    }

    function resolveDownloadInfo(item) {
        const ext = item.fileType.split("/")[1] || "jpg";
        return {
            fileName: "wallhaven-" + item.id + "." + ext,
            fullUrl: item.fullUrl
        };
    }

    function parseHasMore(meta) {
        return meta ? (meta.current_page < meta.last_page) : false;
    }
}
