<template>
  <div class="libv3">
    <header class="v3-header">
      <div class="search-wrap">
        <span class="icon search-icon">search</span>
        <input
          class="search-input" type="text" placeholder="Search by genre, decade, artist…"
          v-model="search"
        />
      </div>
    </header>

    <div v-if="!loaded" class="loading">Loading library…</div>

    <template v-else>
      <div class="spectrum-bar" v-if="genreStats.length">
        <button
          v-for="g in genreStats"
          :key="g.genre"
          class="genre-chip"
          :class="{ active: activeGenre === g.genre }"
          :style="{ '--chip-hue': genreHue(g.genre) }"
          @click="toggleGenre(g.genre)"
        >
          <span class="chip-dot"></span>
          <span class="chip-label">{{ g.genre }}</span>
          <span class="chip-count">{{ g.count }}</span>
        </button>
        <button
          v-if="activeGenre"
          class="genre-chip chip-clear"
          @click="activeGenre = ''"
        >
          <span class="chip-label">Clear</span>
        </button>
      </div>

      <div class="album-spectrum">
        <button
          v-for="a in filteredAlbums"
          :key="a.artist + a.album"
          class="spec-card"
          :style="{ '--card-hue': genreHue(a.genre) }"
          @click="playAlbum(a.artist, a.album)"
        >
          <div class="spec-art">
            <img v-if="a.cover" :src="mpd.coverUrl(a.cover)" loading="lazy"
              @error="e => e.target.style.display='none'"
            />
            <div class="spec-fallback" v-else><span class="icon">music_note</span></div>
          </div>
          <div class="spec-body">
            <div class="spec-album">{{ a.album }}</div>
            <div class="spec-artist">{{ a.artist }}</div>
            <div class="spec-meta-row">
              <span class="spec-year" v-if="a.year">{{ a.year }}</span>
              <span class="spec-genre" v-if="a.genre">{{ a.genre }}</span>
              <span class="spec-tracks">{{ a.trackCount }} tracks</span>
            </div>
          </div>
        </button>
      </div>

      <div v-if="emptyAlbums" class="empty">No albums match</div>
    </template>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useMpd } from '../composables/useMpd.js'
import { useLibrary } from '../composables/useLibrary.js'

const mpd = useMpd()
const { load, tracks, albums } = useLibrary()

const loaded = ref(false)
const search = ref('')
const activeGenre = ref('')

function genreHue(genre) {
  if (!genre) return 0
  let hash = 0
  for (let i = 0; i < genre.length; i++) {
    hash = genre.charCodeAt(i) + ((hash << 5) - hash)
  }
  return Math.abs(hash) % 360
}

const genreStats = computed(() => {
  const map = {}
  for (const a of albums.value) {
    if (a.genre) {
      map[a.genre] = (map[a.genre] || 0) + 1
    }
  }
  return Object.entries(map)
    .sort((a, b) => b[1] - a[1])
    .map(([genre, count]) => ({ genre, count }))
})

const albumsWithMeta = computed(() => {
  const trackMap = {}
  for (const t of tracks.value) {
    const key = t.artist + '///' + t.album
    if (!trackMap[key]) trackMap[key] = []
    trackMap[key].push(t)
  }

  return albums.value.map(a => {
    const key = a.artist + '///' + a.album
    const albumTracks = trackMap[key] || []

    const genres = [...new Set(albumTracks.map(t => t.genre).filter(Boolean))]
    const genre = genres[0] || ''

    const years = albumTracks.map(t => {
      const y = parseInt(t.date, 10)
      return isNaN(y) ? null : y
    }).filter(y => y !== null)
    const year = years.length ? Math.min(...years) : null

    return { ...a, genre, year }
  })
})

function filterItems(items) {
  let result = items
  const q = search.value.toLowerCase()
  if (q) {
    result = result.filter(i => JSON.stringify(i).toLowerCase().includes(q))
  }
  if (activeGenre.value) {
    result = result.filter(i => i.genre === activeGenre.value)
  }
  return result
}

const filteredAlbums = computed(() => filterItems(albumsWithMeta.value))
const emptyAlbums = computed(() => loaded.value && filteredAlbums.value.length === 0)

function toggleGenre(genre) {
  activeGenre.value = activeGenre.value === genre ? '' : genre
}

function playAlbum(artist, album) {
  const t = tracks.value.filter(tr => tr.artist === artist && tr.album === album)
  if (!t.length) return
  mpd.cmd('clear').then(() => {
    return Promise.all(t.map(tr => mpd.cmd('add', `"${tr.file}"`)))
  }).then(() => mpd.cmd('play', '0')).then(() => mpd.refresh())
}

onMounted(async () => {
  await load()
  loaded.value = true
})
</script>

<style scoped>
.libv3 {
  animation: fadeUp 500ms ease both;
  max-width: 1040px;
}

@keyframes fadeUp {
  from { opacity: 0; transform: translateY(12px); }
  to { opacity: 1; transform: translateY(0); }
}

.v3-header {
  margin-bottom: 28px;
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

.spectrum-bar {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  margin-bottom: 28px;
  padding-bottom: 24px;
  border-bottom: 1px solid var(--border);
}

.genre-chip {
  display: flex;
  align-items: center;
  gap: 6px;
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: 20px;
  padding: 6px 14px 6px 10px;
  cursor: pointer;
  font-family: var(--font-body);
  font-size: 12px;
  color: var(--text2);
  transition: all 150ms ease;
}

.genre-chip:hover {
  border-color: var(--text3);
  color: var(--text);
}

.genre-chip.active {
  border-color: hsl(var(--chip-hue), 35%, 55%);
  color: var(--text);
  background: hsla(var(--chip-hue), 35%, 55%, 0.08);
}

.chip-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: hsl(var(--chip-hue), 35%, 55%);
  flex-shrink: 0;
}

.chip-label {
  font-weight: 500;
}

.chip-count {
  font-weight: 400;
  color: var(--text3);
  font-size: 11px;
}

.chip-clear {
  border-style: dashed;
  border-color: var(--border);
}

.chip-clear .chip-label {
  font-weight: 400;
  font-size: 11px;
  text-transform: uppercase;
  letter-spacing: 0.3px;
}

.album-spectrum {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
  gap: 12px;
}

.spec-card {
  display: flex;
  gap: 14px;
  background: var(--surface);
  border: 1px solid var(--border);
  border-left: 3px solid hsl(var(--card-hue, 0), 30%, 50%);
  border-radius: var(--radius);
  padding: 12px;
  cursor: pointer;
  text-align: left;
  font-family: var(--font-body);
  transition: border-color 150ms, box-shadow 150ms, transform 150ms;
}

.spec-card:hover {
  border-color: hsl(var(--card-hue, 0), 40%, 65%);
  box-shadow: 0 0 0 1px hsla(var(--card-hue, 0), 40%, 65%, 0.3);
  transform: translateX(2px);
}

.spec-card:active {
  transform: translateX(0) scale(0.99);
}

.spec-art {
  width: 64px;
  height: 64px;
  border-radius: 4px;
  background: var(--surface2);
  flex-shrink: 0;
  overflow: hidden;
}

.spec-art img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.spec-fallback {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--text3);
}

.spec-fallback .icon {
  font-size: 28px;
  font-variation-settings: 'FILL' 0;
}

.spec-body {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 1px;
}

.spec-album {
  font-size: 14px;
  font-weight: 600;
  color: var(--text);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  line-height: 1.3;
}

.spec-artist {
  font-size: 12px;
  font-weight: 400;
  color: var(--text2);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.spec-meta-row {
  display: flex;
  gap: 8px;
  align-items: center;
  margin-top: 4px;
  flex-wrap: wrap;
}

.spec-year {
  font-size: 11px;
  font-weight: 500;
  color: var(--text3);
  font-variant-numeric: tabular-nums;
}

.spec-genre {
  font-size: 10px;
  font-weight: 500;
  color: hsl(var(--card-hue, 0), 30%, 55%);
  background: hsla(var(--card-hue, 0), 30%, 55%, 0.1);
  padding: 1px 7px;
  border-radius: 10px;
  white-space: nowrap;
}

.spec-tracks {
  font-size: 11px;
  color: var(--text3);
}

@media (max-width: 768px) {
  .album-spectrum {
    grid-template-columns: 1fr;
    gap: 8px;
  }

  .spectrum-bar {
    gap: 4px;
    margin-bottom: 20px;
    padding-bottom: 16px;
  }

  .genre-chip {
    padding: 5px 11px 5px 8px;
    font-size: 11px;
  }

  .v3-header {
    margin-bottom: 20px;
  }
}
</style>
