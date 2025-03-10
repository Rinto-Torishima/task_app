import { createApp } from 'vue';
import App from './App.vue';
import router from './router';
import Toast from "vue-toastification";
import "vue-toastification/dist/index.css";
// import './assets/main.css';
import './index.css';

createApp(App).use(router).use(Toast).mount('#app');