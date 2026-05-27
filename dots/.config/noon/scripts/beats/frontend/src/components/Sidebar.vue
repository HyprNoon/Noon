<template>
    <aside id="sidebar" :class="{ collapsed }">
        <div class="brand">
            <img src="/assets/icon.svg" class="brand-icon" alt="" />
            <span class="brand-text">beats</span>
            <span
                class="icon brand-dot"
                :class="{ connected: mpd.connected.value }"
                >link</span
            >
        </div>
        <nav>
            <button
                v-for="t in tabs"
                :key="t.view"
                class="tab"
                :class="{ active: $route.name === t.view }"
                @click="navigate(t.view)"
            >
                <span class="icon">{{ t.icon }}</span>
                <span class="tab-label">{{ t.label }}</span>
            </button>
            <button
                v-show="activePlayerCount > 1"
                class="tab"
                @click="switchPlayer"
            >
                <span class="icon">swap_horiz</span>
                <span class="tab-label">Switch Player</span>
            </button>
        </nav>
        <div id="theme-switcher">
            <button
                v-for="o in themeOpts"
                :key="o.mode"
                class="theme-opt"
                :class="{ active: theme === o.mode }"
                @click="setTheme(o.mode)"
            >
                <span class="icon">{{ o.icon }}</span>
            </button>
        </div>
        <button
            id="theme-cycle"
            v-show="collapsed"
            class="icon"
            @click="cycleTheme"
            title="Theme"
        >
            {{ themeIcon }}
        </button>
        <button id="collapse-btn" class="icon" @click="toggleCollapse">
            {{ collapsed ? "chevron_right" : "chevron_left" }}
        </button>
    </aside>
</template>

<script setup>
import { inject, ref, computed, onMounted } from "vue";
import { useRouter, useRoute } from "vue-router";
import { useMpd } from "../composables/useMpd.js";
import { useTheme } from "../composables/useTheme.js";

const router = useRouter();
const route = useRoute();
const mpd = useMpd();
const { theme, setTheme } = useTheme();
const activePlayerCount = inject("activePlayerCount", ref(1));

const collapsed = ref(false);

const tabs = [
    { view: "player", icon: "music_note", label: "Now Playing" },
    { view: "tracks", icon: "library_music", label: "Tracks" },
    { view: "library", icon: "grid_view", label: "Library" },
];

const themeOpts = [
    { mode: "system", icon: "desktop_windows" },
    { mode: "light", icon: "routine" },
    { mode: "dark", icon: "dark_mode" },
];

const themeOrder = ["system", "light", "dark"];
const themeIcons = {
    system: "desktop_windows",
    light: "routine",
    dark: "dark_mode",
};
const themeIcon = computed(() => themeIcons[theme.value]);

function cycleTheme() {
    const idx = themeOrder.indexOf(theme.value);
    setTheme(themeOrder[(idx + 1) % themeOrder.length]);
}

function toggleCollapse() {
    collapsed.value = !collapsed.value;
    localStorage.setItem("beats-sidebar-collapsed", collapsed.value ? "1" : "");
}

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

onMounted(() => {
    collapsed.value = localStorage.getItem("beats-sidebar-collapsed") === "1";
});
</script>

<style scoped>
#sidebar {
    width: var(--sidebar-w);
    background: var(--surface);
    border-right: 1px solid var(--border);
    display: flex;
    flex-direction: column;
    padding: 20px 12px;
    gap: 28px;
    flex-shrink: 0;
    transition:
        width 0.15s,
        padding 0.15s;
    overflow: hidden;
    position: relative;
}
#sidebar.collapsed {
    width: 60px;
    padding: 20px 8px;
}

.brand {
    display: flex;
    align-items: center;
    gap: 8px;
    font-family: var(--font-display);
    font-size: 22px;
    font-weight: 700;
    color: var(--text);
    letter-spacing: -0.3px;
    padding: 0 8px;
    white-space: nowrap;
    line-height: 1;
}
.brand-icon {
    width: 22px;
    height: 22px;
    flex-shrink: 0;
}
.brand-dot {
    font-size: 18px;
    color: var(--text3);
    flex-shrink: 0;
    margin-left: auto;
}
.brand-dot.connected {
    color: var(--accent);
}
.collapsed .brand-text {
    display: none;
}
.collapsed .brand-dot {
    display: none;
}
.collapsed .brand {
    justify-content: center;
    padding: 0;
    gap: 0;
}

nav {
    display: flex;
    flex-direction: column;
    gap: 2px;
}

.tab {
    font-family: var(--font-body);
    background: none;
    border: none;
    color: var(--text2);
    padding: 10px 12px;
    text-align: left;
    border-radius: var(--radius-sm);
    cursor: pointer;
    font-size: 13px;
    font-weight: 500;
    display: flex;
    align-items: center;
    gap: 10px;
    transition: 0.12s;
    white-space: nowrap;
}
.tab:hover {
    background: var(--surface2);
    color: var(--text);
}
.tab.active {
    color: var(--accent);
    font-weight: 600;
}
.tab .icon {
    font-size: 20px;
    font-variation-settings:
        "FILL" 0,
        "wght" 400;
    flex-shrink: 0;
}
.tab.active .icon {
    font-variation-settings:
        "FILL" 1,
        "wght" 400;
}
.collapsed .tab-label {
    display: none;
}
.collapsed .tab {
    justify-content: center;
    padding: 10px 0;
}
.collapsed #theme-switcher {
    display: none;
}

#theme-cycle {
    display: none;
    background: none;
    border: none;
    color: var(--text3);
    cursor: pointer;
    padding: 8px;
    border-radius: var(--radius-sm);
    align-items: center;
    justify-content: center;
    font-size: 18px;
    transition: 0.12s;
}
#theme-cycle:hover {
    background: var(--surface2);
    color: var(--text);
}
#theme-cycle:active {
    transform: scale(0.95);
}
.collapsed #theme-cycle {
    display: flex;
}

#theme-switcher {
    display: flex;
    gap: 2px;
    background: var(--bg);
    border-radius: var(--radius-sm);
    padding: 2px;
    flex-shrink: 0;
}
.theme-opt {
    flex: 1;
    background: none;
    border: none;
    color: var(--text3);
    padding: 6px 0;
    border-radius: 5px;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: 0.12s;
}
.theme-opt:hover {
    color: var(--text);
}
.theme-opt.active {
    background: var(--surface);
    color: var(--accent);
    box-shadow: var(--shadow);
}
.theme-opt .icon {
    font-size: 16px;
}

#collapse-btn {
    background: none;
    border: none;
    color: var(--text3);
    cursor: pointer;
    padding: 8px;
    border-radius: var(--radius-sm);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 18px;
    transition: 0.12s;
    margin-top: auto;
}
#collapse-btn:hover {
    background: var(--surface2);
    color: var(--text);
}

@media (max-width: 768px) {
    #sidebar {
        display: none;
    }
}
</style>
