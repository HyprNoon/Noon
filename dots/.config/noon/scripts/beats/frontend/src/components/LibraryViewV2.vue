<template>
  <div class="libv2">
    <header class="v2-header">
      <div class="search-wrap">
        <span class="icon search-icon">search</span>
        <input
          class="search-input" type="text" placeholder="Search tracks…"
          v-model="search"
        />
      </div>
    </header>

    <div v-if="!loaded" class="loading">Loading library…</div>

    <template v-else>
      <div
        v-for="shelf in filteredShelves"
        :key="shelf.artist + shelf.album"
        class="shelf"
        :class="{ expanded: expandedAlbum === shelf.artist + shelf.album }"
      >
        <button class="shelf-header" @click="toggleShelf(shelf)">
          <div class="shelf-art">
            <img v-if="shelf.cover" :src="mpd.coverUrl(shelf.cover)" loading="lazy"
              @error="e => e.target.style.display='none'"
            />
            <div class="shelf-art-fallback" v-else><span class="icon">album</span></div>
          </div>
          <div class="shelf-head-body">
            <h3 class="shelf-label">{{ shelf.album }}</h3>
            <span class="shelf-artist">{{ shelf.artist }}</span>
            <span class="shelf-tracks-count">{{ shelf.tracks.length }} tracks</span>
          </div>
          <span class="shelf-chevron icon">expand_more</span>
        </button>

        <div class="shelf-tracks" v-if="expandedAlbum === shelf.artist + shelf.album">
          <button
            v-for="t in shelf.tracks"
            :key="t.file"
            class="track-item"
            @click="playTrack(t)"
          >
            <span class="track-idx">{{ t.track || '-' }}</span>
            <span class="track-title">{{ t.title || t.file.split('/').pop() }}</span>
            <span class="track-dur">{{ fmtDuration(t.duration) }}</span>
          </button>
        </div>
      </div>

      <div v-if="emptyShelves" class="empty">No tracks match</div>
    </template>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useMpd } from '../composables/useMpd.js'
import { useLibrary } from '../composables/useLibrary.js'

const mpd = useMpd()
const { load, tracks } = useLibrary()

const loaded = ref(false)
const search = ref('')
const expandedAlbum = ref('')

const shelves = computed(() => {
  const groups = {}
  for (const t of tracks.value) {
    const key = t.artist + '///' + t.album
    if (!groups[key]) {
      groups[key] = {
        artist: t.artist,
        album: t.album,
        cover: t.cover,
        tracks: [],
      }
    }
    groups[key].tracks.push(t)
  }
  return Object.values(groups)
    .sort((a, b) => a.artist.localeCompare(b.artist))
})

function filterItems(items) {
  const q = search.value.toLowerCase()
  if (!q) return items
  return items.filter(i => {
    for (const t of i.tracks) {
      if (JSON.stringify(t).toLowerCase().includes(q)) return true
    }
    return false
  })
}

const filteredShelves = computed(() => filterItems(shelves.value))
const emptyShelves = computed(() => loaded.value && filteredShelves.value.length === 0)

function toggleShelf(shelf) {
  const key = shelf.artist + shelf.album
  expandedAlbum.value = expandedAlbum.value === key ? '' : key
}

function playTrack(t) {
  mpd.cmd('clear').then(() =>
    mpd.cmd('add', `"${t.file}"`)
  ).then(() => mpd.cmd('play', '0')).then(() => mpd.refresh())
}

function fmtDuration(sec) {
  if (!sec || isNaN(sec)) return '-:--'
  const m = Math.floor(sec / 60)
  const s = Math.floor(sec % 60)
  return `${m}:${s.toString().padStart(2, '0')}`
}

onMounted(async () => {
  await load()
  loaded.value = true
})
</script>

<style scoped>
.libv2 {
  animation: fadeUp 500ms ease both;
  margin: -32px -40px;
  padding: 32px 0 0;
}

@keyframes fadeUp {
  from { opacity: 0; transform: translateY(12px); }
  to { opacity: 1; transform: translateY(0); }
}

.v2-header {
  margin-bottom: 32px;
  padding: 0 40px;
}

.search-wrap {
  display: flex;
  align-items: center;
  gap: 10px;
  background: transparent;
  border-bottom: 1.5px solid var(--border);
  padding: 0 0 10px;
  transition: border-color var(--transition);
}

.search-wrap:focus-within {
  border-color: var(--text);
}

.search-icon {
  font-size: 20px;
  color: var(--text3);
  font-variation-settings: 'FILL' 0, 'wght' 300;
}

.search-input {
  flex: 1;
  padding: 0;
  border: none;
  background: transparent;
  color: var(--text);
  font-size: 15px;
  font-family: var(--font-body);
  outline: none;
  letter-spacing: 0.2px;
}

.search-input::placeholder {
  color: var(--text3);
  font-weight: 300;
}

.loading {
  color: var(--text3);
  font-size: 14px;
  text-align: center;
  padding: 80px 40px;
  font-weight: 400;
}

.empty {
  color: var(--text3);
  text-align: center;
  padding: 60px 40px;
  font-size: 14px;
}

.shelf {
  border-bottom: 1px solid var(--border);
  transition: background 120ms;
}

.shelf-header {
  display: flex;
  align-items: center;
  gap: 16px;
  width: 100%;
  padding: 16px 40px;
  background: none;
  border: none;
  cursor: pointer;
  text-align: left;
  color: var(--text);
  transition: background 120ms;
}

.shelf-header:hover {
  background: var(--surface);
}

.shelf-art {
  width: 48px;
  height: 48px;
  border-radius: 4px;
  overflow: hidden;
  background: var(--surface2);
  flex-shrink: 0;
  box-shadow:
    0 2px 8px rgba(0,0,0,0.3),
    0 1px 2px rgba(0,0,0,0.15);
}

.shelf-art img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.shelf-art-fallback {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--text3);
}

.shelf-art-fallback .icon {
  font-size: 24px;
  font-variation-settings: 'FILL' 0;
}

.shelf-head-body {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 1px;
}

.shelf-label {
  font-family: var(--font-body);
  font-size: 15px;
  font-weight: 600;
  color: var(--text);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  line-height: 1.3;
}

.shelf-artist {
  font-family: var(--font-body);
  font-size: 13px;
  font-weight: 400;
  color: var(--text2);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.shelf-tracks-count {
  font-family: var(--font-body);
  font-size: 11px;
  font-weight: 400;
  color: var(--text3);
  margin-top: 1px;
}

.shelf-chevron {
  font-size: 24px;
  color: var(--text3);
  flex-shrink: 0;
  transition: transform 200ms ease;
  font-variation-settings: 'FILL' 0;
}

.expanded .shelf-chevron {
  transform: rotate(180deg);
}

.shelf-tracks {
  animation: slideDown 200ms ease both;
  overflow: hidden;
}

@keyframes slideDown {
  from { opacity: 0; max-height: 0; }
  to { opacity: 1; max-height: 2000px; }
}

.track-item {
  display: flex;
  align-items: center;
  gap: 12px;
  width: 100%;
  padding: 10px 40px 10px 104px;
  background: none;
  border: none;
  cursor: pointer;
  text-align: left;
  color: var(--text);
  transition: background 100ms;
}

.track-item:hover {
  background: var(--surface2);
}

.track-item:active {
  background: var(--border);
}

.track-idx {
  width: 24px;
  font-size: 12px;
  font-weight: 400;
  color: var(--text3);
  text-align: right;
  font-variant-numeric: tabular-nums;
  flex-shrink: 0;
}

.track-title {
  flex: 1;
  min-width: 0;
  font-size: 14px;
  font-weight: 500;
  color: var(--text);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  font-family: var(--font-body);
}

.track-dur {
  font-size: 12px;
  font-weight: 400;
  color: var(--text3);
  font-variant-numeric: tabular-nums;
  flex-shrink: 0;
  font-family: var(--font-body);
}

@media (max-width: 768px) {
  .v2-header {
    margin-bottom: 24px;
  }

  .libv2 {
    margin: -16px -16px;
    padding: 16px 0 0;
  }

  .v2-header {
    padding: 0 16px;
  }

  .shelf-header {
    padding: 14px 16px;
    gap: 12px;
  }

  .shelf-art {
    width: 42px;
    height: 42px;
  }

  .shelf-label {
    font-size: 14px;
  }

  .shelf-artist {
    font-size: 12px;
  }

  .track-item {
    padding: 8px 16px 8px 70px;
  }

  .track-idx {
    width: 20px;
    font-size: 11px;
  }

  .track-title {
    font-size: 13px;
  }
}

@media (max-width: 480px) {
  .shelf-header {
    padding: 12px 12px;
  }
}
</style>
