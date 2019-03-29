import Vue from "vue"
import Router from "vue-router"
import Rooms from "../vue_views/Rooms.vue";
import Register from "../vue_views/Register.vue";
import Login from "../vue_views/Login.vue";
import Logout from "../vue_views/Logout.vue";
import Index from "../vue_views/Index.vue";

Vue.use(Router);

export default new Router({
  routes: [
    {
      path: "/",
      name: "index",
      meta: { title: "Home" },
      component: Index
    },
    {
      path: "/rooms",
      name: "rooms",
      meta: { title: "R-Chatroom" },
      component: Rooms
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
    },
    {
      path: "/logout",
      name: "logout",
      meta: { title: "logout" },
      component: Logout
    }
  ]
});
