<template>
  <div id="app-root" :class="{ welcome: isWelcome }">
    <div class="global-bg" :class="{ active: bgLoaded }">
      <img
        v-if="coverUrl"
        :src="coverUrl"
        class="global-bg-img"
        @load="onCoverLoad"
        @error="onCoverError"
      />
    </div>
    <Sidebar />
    <BottomNav />
    <main id="main">
      <router-view />
    </main>
  </div>
  <div id="toast" :class="{ show: toastMsg }" v-text="toastMsg || ''"></div>
</template>

<script setup>
import { computed, ref, watch, provide, onMounted, onUnmounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useMpd } from './composables/useMpd.js'
import { useTheme } from './composables/useTheme.js'
import Sidebar from './components/Sidebar.vue'
import BottomNav from './components/BottomNav.vue'

const router = useRouter()
const route = useRoute()
const mpd = useMpd()
useTheme()

const toastMsg = ref('')
let toastTimer = null
function toast(msg) {
  toastMsg.value = msg
  clearTimeout(toastTimer)
  toastTimer = setTimeout(() => { toastMsg.value = '' }, 2500)
}

const isWelcome = computed(() => route.name === 'welcome')

const activePlayerCount = ref(1)
provide('activePlayerCount', activePlayerCount)

const coverUrl = ref('')
const bgLoaded = ref(false)

watch(mpd.currentSong, (song) => {
  const file = song?.file
  const url = file ? mpd.coverUrl(file) : ''
  if (url !== coverUrl.value) {
    coverUrl.value = url
    bgLoaded.value = false
  }
}, { immediate: true })

function onCoverLoad() {
  bgLoaded.value = true
}
function onCoverError() {
  coverUrl.value = ''
  bgLoaded.value = false
}

async function fetchPlayers() {
  try {
    const resp = await fetch('/api/players')
    if (resp.ok) {
      const data = await resp.json()
      activePlayerCount.value = Object.values(data).filter(p => p.running).length
    }
  } catch (_) {}
}

mpd.onConnected = () => {
  toast('Connected to ' + mpd.player)
  fetchPlayers()
  router.push('/player')
}

mpd.onDisconnected = () => {
  toast('Disconnected')
  router.push('/welcome')
}

function onKey(e) {
  const tag = e.target.tagName
  if (tag === 'INPUT' || tag === 'TEXTAREA' || tag === 'SELECT') return
  if (!mpd.connected.value) return

  switch (e.code) {
    case 'Space':
      e.preventDefault()
      mpd.do('pause', mpd.status.state === 'play' ? '1' : '0')
      break
    case 'ArrowLeft':
      e.preventDefault()
      mpd.do('seekcur', -5)
      break
    case 'ArrowRight':
      e.preventDefault()
      mpd.do('seekcur', +5)
      break
    case 'ArrowUp':
      e.preventDefault()
      mpd.do('setvol', Math.min(100, parseInt(mpd.status.volume || 0) + 5))
      break
    case 'ArrowDown':
      e.preventDefault()
      mpd.do('setvol', Math.max(0, parseInt(mpd.status.volume || 0) - 5))
      break
    case 'KeyN':
      mpd.do('next')
      break
    case 'KeyP':
      mpd.do('previous')
      break
    case 'KeyM':
      mpd.do('setvol', parseInt(mpd.status.volume || 0) > 0 ? '0' : '50')
      break
  }
}

onMounted(() => {
  window.addEventListener('keydown', onKey)
  const restored = mpd.restore()
  if (!restored) {
    fetchPlayers()
  }
})

onUnmounted(() => {
  window.removeEventListener('keydown', onKey)
})
</script>

<style>
#app-root {
  display: flex;
  height: 100vh;
  width: 100%;
  position: relative;
}
#app-root.welcome #sidebar,
#app-root.welcome #bottom-nav { display: none; }
#app-root.welcome #main {
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.global-bg {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  overflow: hidden;
  opacity: 0;
  z-index: 0;
  pointer-events: none;
  transition: opacity 0.8s ease;
  isolation: isolate;
}

.global-bg.active {
  opacity: 1;
}

.global-bg-img {
  position: absolute;
  top: -10%;
  left: -10%;
  width: 120%;
  height: 120%;
  object-fit: cover;
  filter: blur(50px) saturate(120%);
  opacity: 0.06;
}

#sidebar { position: relative; z-index: 1; }

#main {
  flex: 1;
  overflow-y: auto;
  padding: 32px 40px;
  position: relative;
  z-index: 1;
}
#main::-webkit-scrollbar { width: 6px; }
#main::-webkit-scrollbar-track { background: transparent; }
#main::-webkit-scrollbar-thumb { background: var(--border); border-radius: 3px; }

@media (max-width: 768px) {
  #main {
    padding: 16px 16px max(80px, calc(env(safe-area-inset-bottom) + 64px));
  }
}
</style>
