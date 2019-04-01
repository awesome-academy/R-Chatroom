import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    storedUsername: null,
    storedAuthToken: null,
    storedUserId: null,
    storedApiUrl: "http://0.0.0.0:3000"
  },
  mutations: {
    setAuthInfo(state, payload) {
      state.storedUserId = payload.id;
      state.storedUsername = payload.username;
      state.storedAuthToken = payload.authToken;
    }
  },
  actions: {

  }
});
