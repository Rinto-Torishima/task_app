import { fileURLToPath, URL } from 'node:url'

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import vueDevTools from 'vite-plugin-vue-devtools'

// https://vite.dev/config/
export default defineConfig({
  plugins: [
    vue(),
    vueDevTools(),
  ],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    },
  },
  // 追記
  server: {
    // --hostと同義
    host: true,
    // 立ち上げる際のポートを変更できます。
    port: 8000,
    proxy: {
      '^/api': {
        // docker-compose.ymlに記載しているbackendのIPを指定
        target: 'http://172.28.0.4:3000',
        changeOrigin: true,
      },
    },

  },
})
