import QtQuick
import qs.common

QtObject {
    id: root

    property string apiKey: Mem.options.keys.unsplash

    readonly property string endpoint: "https://api.unsplash.com/photos"

    readonly property var categories: [
        {
            label: "Latest",
            icon: "app_badging",
            orderBy: "latest"
        },
        {
            label: "Popular",
            icon: "social_leaderboard",
            orderBy: "popular"
        },
        {
            label: "Views",
            icon: "play_arrow",
            orderBy: "views"
        }
    ]

    function buildUrl(page, query, categoryIndex) {
        const cat = root.categories[categoryIndex];
        const base = query ? "https://api.unsplash.com/search/photos" : root.endpoint;

        let url = base + "?page=" + page + "&per_page=20" + "&order_by=" + cat.orderBy;

        if (query)
            url += "&query=" + encodeURIComponent(query);
        if (root.apiKey)
            url += "&client_id=" + root.apiKey;

        return url;
    }

    function normalizeResults(data) {
        const items = data.results ?? data;
        return items.map(function (p) {
            return {
                id: p.id,
                thumbUrl: p.urls.regular,
                fullUrl: p.urls.full,
                resolution: p.width + "x" + p.height,
                fileType: "image/jpeg"
            };
        });
    }

    function resolveDownloadInfo(item) {
        return {
            fileName: "unsplash-" + item.id + ".jpg",
            fullUrl: item.fullUrl
        };
    }

    function parseHasMore(data) {
        return (data.results ?? data).length === 20;
    }
}
