<template>
    <nav id="bottom-nav">
        <div
            v-for="t in tabs"
            :key="t.view"
            class="tab"
            :class="{ active: $route.name === t.view }"
            @click="navigate(t.view)"
        >
            <span class="icon">{{ t.icon }}</span>
            <span class="label">{{ t.label }}</span>
        </div>
        <div
            v-show="activePlayerCount > 1"
            class="tab"
            @click="switchPlayer"
        >
            <span class="icon">swap_horiz</span>
            <span class="label">Switch</span>
        </div>
    </nav>
</template>

<script setup>
import { inject, ref } from "vue";
import { useRouter, useRoute } from "vue-router";
import { useMpd } from "../composables/useMpd.js";

const router = useRouter();
const route = useRoute();
const mpd = useMpd();
const activePlayerCount = inject("activePlayerCount", ref(1));

const tabs = [
    { view: "player", icon: "music_note", label: "Now Playing" },
    { view: "tracks", icon: "library_music", label: "Tracks" },
    { view: "library", icon: "grid_view", label: "Library" },
];

function navigate(view) {
    const map = {
        player: "/player",
        tracks: "/tracks",
        albums: "/albums",
        artists: "/artists",
        library: "/library",
    };
    router.push(map[view] || "/player");
}

function switchPlayer() {
    mpd.disconnect();
    router.push("/welcome");
}
</script>

<style scoped>
#bottom-nav {
    display: none;
}

@media (max-width: 768px) {
    #bottom-nav {
        display: flex;
        position: fixed;
        bottom: 0;
        left: 0;
        right: 0;
        background: var(--surface);
        border-top: 1px solid var(--border);
        padding: 0 env(safe-area-inset-bottom, 12px) max(env(safe-area-inset-bottom, 8px), 12px);
        z-index: 100;
    }

    #bottom-nav .tab {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        gap: 2px;
        flex: 1;
        min-width: 0;
        overflow: hidden;
        padding: 8px 4px 10px;
        cursor: pointer;
        color: var(--text2);
        font-family: var(--font-body);
        font-size: 10px;
        transition: 150ms;
        position: relative;
        -webkit-tap-highlight-color: transparent;
        user-select: none;
    }

    #bottom-nav .tab:hover {
        color: var(--text);
    }

    #bottom-nav .tab.active {
        color: var(--text);
    }

    #bottom-nav .tab .icon {
        font-size: 22px;
        line-height: 1;
        transition: 150ms;
    }

    #bottom-nav .tab.active .icon {
        font-variation-settings: "FILL" 1, "wght" 400;
    }

    #bottom-nav .tab .label {
        font-size: 10px;
        line-height: 1.2;
        font-weight: 500;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        max-width: 100%;
    }

    #bottom-nav .tab.active .label {
        font-weight: 600;
    }
}
</style>
