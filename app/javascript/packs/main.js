import Vue from "vue"
import App from "../app.vue"
import router from "./router"

Vue.config.productionTip = false

document.addEventListener("DOMContentLoaded", () => {
  new Vue({
    router,
    render: h => h(App)
  }).$mount("#app")
})

router.beforeEach((to, from, next) => {
  document.title = to.meta.title
  next()
})
