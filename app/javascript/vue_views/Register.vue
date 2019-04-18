<template>
  <div class="form-container">
    <div class="form-box">
      <div v-if="isLoading" class="notification is-primary">{{ $t("pleaseWait") }}</div>
      <div v-if="isSuccess" class="notification is-success">{{ $t("signedUpSuccessfully") }}</div>
      <div v-if="errorMsg" class="notification is-warning">
        <ul>
          <li v-for="(err, index) in errorMsg" :key="index">{{ err }}</li>
        </ul>
      </div>
      <form @submit.prevent="doRegister">
        <div class="field">
          <label class="label">{{ $t("username") }}</label>
          <div class="control">
            <input v-model="inputUsername" class="input" type="text">
          </div>
        </div>
        <div class="field">
          <label class="label">{{ $t("showName") }}</label>
          <div class="control">
            <input v-model="inputShowName" class="input" type="text">
          </div>
        </div>
        <div class="field">
          <label class="label">{{ $t("password") }}</label>
          <div class="control">
            <input v-model="inputPassword" class="input" type="password">
          </div>
        </div>
        <div class="field">
          <label class="label">{{ $t("passwordConfirm") }}</label>
          <div class="control">
            <input v-model="inputPasswordConfirm" class="input" type="password">
          </div>
        </div>
        <div class="field">
          <label class="label">{{ $t("email") }}</label>
          <div class="control">
            <input v-model="inputEmail" class="input" type="email">
          </div>
        </div>
        <div class="control">
          <button class="button is-primary">{{ $t("signUp") }}</button>
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
  name: "register",
  data() {
    return {
      inputUsername: null,
      inputShowName: null,
      inputPassword: null,
      inputPasswordConfirm: null,
      inputEmail: null,
      errorMsg: null,
      isSuccess: false,
      isLoading: false
    };
  },
  computed: {
    ...mapState(["storedApiUrl"])
  },
  methods: {
    doRegister: function() {
      this.isLoading = true;
      axios
        .post(`${this.storedApiUrl}/users`, {
          user: {
            user_name: this.inputUsername,
            show_name: this.inputShowName,
            password: this.inputPassword,
            password_confirmation: this.inputPasswordConfirm,
            email: this.inputEmail
          }
        })
        .then(result => {
          this.isSuccess = true;
          setTimeout(() => {
            this.$store.commit("setAuthInfo", {
              username: this.inputUsername,
              authToken: null
            });
            this.$router.push(`/activate?id=${result.data.data.user.id}`);
          }, 1500);
        })
        .catch(e => {
          if (e.response.data.data) {
            this.errorMsg = e.response.data.data;
          } else {
            this.errorMsg = e;
          }
          setTimeout(() => {
            this.errorMsg = null;
          }, 2000);
        })
        .then(() => {
          this.isLoading = false;
        });
    }
  }
};
</script>
