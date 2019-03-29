import Vue from "vue"
import Router from "vue-router"
import Home from "../vue_views/Home.vue";
import Register from "../vue_views/Register.vue";
import Login from "../vue_views/Login.vue";

Vue.use(Router);

export default new Router({
  routes: [
    {
      path: "/",
      name: "home",
      meta: { title: "Home" },
      component: Home
    },
    {
      path: "/register",
      name: "register",
      meta: { title: "Register" },
      component: Register
    },
    {
      path: "/login",
      name: "login",
      meta: { title: "Login" },
      component: Login
    }
  ]
});
