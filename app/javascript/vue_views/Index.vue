<template>
  <div class="index-container" v-if="notLoggedIn">
    <div class="index-box">
      <div id="info">{{ $t("notSignedIn") }}</div>
      <div id="login-nav">
        <router-link to="/login" class="button">{{ $t("login") }}</router-link>
      </div>
      <div id="register-nav">
        <router-link to="/register" class="button">{{ $t("register") }}</router-link>
      </div>
    </div>
  </div>
</template>

<style></style>

<script>
export default {
  data() {
    return {
      notLoggedIn: false
    };
  },
  methods: {
    getRememberedLoginInfo() {
      let lsUserId = localStorage.getItem("id");
      let lsUserName = localStorage.getItem("username");
      let lsAuthToken = localStorage.getItem("authToken");

      let ssUserId = sessionStorage.getItem("id");
      let ssUserName = sessionStorage.getItem("username");
      let ssAuthToken = sessionStorage.getItem("authToken");

      if (lsUserId && lsUserName && lsAuthToken) {
        this.$store.commit("setAuthInfo", {
          id: lsUserId,
          username: lsUserName,
          authToken: lsAuthToken
        });
      } else if (ssUserId && ssUserName && ssAuthToken) {
        this.$store.commit("setAuthInfo", {
          id: ssUserId,
          username: ssUserName,
          authToken: ssAuthToken
        });
      } else {
        return false;
      }
      return true;
    }
  },
  mounted() {
    if (!this.getRememberedLoginInfo()) {
      this.notLoggedIn = true;
    } else {
      this.$router.push("/chat");
    }
  }
};
</script>
