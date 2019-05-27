<template>
  <div class="form-container">
    <div class="form-box">
      <div v-if="isLoading" class="notification is-primary">{{ $t("pleaseWait") }}</div>
      <div v-if="isSuccess" class="notification is-success">{{ $t("signedInSuccessfully")}}</div>
      <div v-if="errorMsg" class="notification is-warning">{{ errorMsg }}</div>
      <form @submit.prevent="doLogin">
        <div class="field">
          <label class="label">{{ $t("username") }}</label>
          <div class="control">
            <input v-model="inputUsername" class="input" type="text">
          </div>
        </div>
        <div class="field">
          <label class="label">{{ $t("password") }}</label>
          <div class="control">
            <input v-model="inputPassword" class="input" type="password">
          </div>
        </div>
        <div class="field">
          <label class="checkbox">
            <input type="checkbox" v-model="remember">
            {{ $t("rememberMe") }}
          </label>
        </div>
        <div class="control">
          <button class="button is-primary">{{ $t("login") }}</button>
        </div>
      </form>
    </div>
  </div>
</template>

<style lang="scss">
</style>

<script>
import axios from "axios";
import { mapState } from "vuex";

export default {
  name: "home",
  data() {
    return {
      inputUsername: null,
      inputPassword: null,
      errorMsg: null,
      isSuccess: false,
      isLoading: false,
      remember: false
    };
  },
  computed: {
    ...mapState(["storedApiUrl", "storedUsername"])
  },
  methods: {
    doLogin: function() {
      this.isLoading = true;
      axios
        .post(`${this.storedApiUrl}/sign_in`, {
          user: {
            user_name: this.inputUsername,
            password: this.inputPassword
          }
        })
        .then(result => {
          this.isSuccess = true;
          setTimeout(() => {
            this.$store.commit("setAuthInfo", {
              id: result.data.data.user.id,
              username: this.inputUsername,
              authToken: result.data.data.token
            });

            if (this.remember == false) {
              sessionStorage.setItem("id", result.data.data.user.id);
              sessionStorage.setItem("username", this.inputUsername);
              sessionStorage.setItem("authToken", result.data.data.token);
            } else {
              localStorage.setItem("id", result.data.data.user.id);
              localStorage.setItem("username", this.inputUsername);
              localStorage.setItem("authToken", result.data.data.token);
            }

            this.$router.push("/chat");
          }, 500);
        })
        .catch(e => {
          this.errorMsg = e.response.data.message;
          setTimeout(() => {
            this.errorMsg = null;
          }, 2000);
        })
        .then(() => {
          this.isLoading = false;
        });
    }
  },
  mounted() {
    this.inputUsername = this.storedUsername;
  }
};
</script>
