import Vue from "vue"
import Router from "vue-router"
import Home from "../vue_views/Home.vue"

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: "/",
      name: "home",
      meta: { title: "Home" },
      component: Home
    }
  ]
})
