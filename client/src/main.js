import { createApp, reactive } from "vue";
import "./style.css";
import App from "./App.vue";
import router from "./router";
import '@fortawesome/fontawesome-free/css/all.min.css';

const app = createApp(App);
app.provide("user", reactive({ data: null }));
app.use(router).mount("#app");
//createApp(App).use(router).mount("#app");
