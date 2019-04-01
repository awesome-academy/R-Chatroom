import Vue from "vue";
import App from "../app.vue";
import router from "./router";
import store from "./store";
import i18n from "./i18n";

Vue.config.productionTip = false;

document.addEventListener("DOMContentLoaded", () => {
  new Vue({
    router,
    store,
    i18n,
    render: h => h(App)
  }).$mount("#app");
});

router.beforeEach((to, from, next) => {
  document.title = to.meta.title;
  next();
});
