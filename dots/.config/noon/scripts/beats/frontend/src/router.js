import { createRouter, createWebHashHistory } from 'vue-router'
import WelcomePage from './components/WelcomePage.vue'
import NowPlaying from './components/NowPlaying.vue'
import LibraryView from './components/LibraryView.vue'
import LibraryViewV1 from './components/LibraryViewV1.vue'

const routes = [
  { path: '/', redirect: '/welcome' },
  { path: '/welcome', name: 'welcome', component: WelcomePage },
  { path: '/player', name: 'player', component: NowPlaying },
  { path: '/tracks', name: 'tracks', component: LibraryView },
  { path: '/albums', name: 'albums', component: LibraryView },
  { path: '/artists', name: 'artists', component: LibraryView },
  { path: '/library', name: 'library', component: LibraryViewV1 },
]

export default createRouter({
  history: createWebHashHistory(),
  routes,
})
