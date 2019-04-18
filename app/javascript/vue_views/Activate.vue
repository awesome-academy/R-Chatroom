<template>
  <div class="form-container">
    <div class="form-box">
      <div v-if="isLoading" class="notification is-primary">{{ $t("pleaseWait") }}</div>
      <div v-if="isSuccess" class="notification is-success">{{ $t("activatedSuccessfully") }}</div>
      <div v-if="errorMsg" class="notification is-warning">{{ errorMsg }}</div>
      <form @submit.prevent="doActivate">
        <div class="field">
          <label class="label">{{ $t("id") }}</label>
          <div class="control">
            <input v-model="userId" class="input disabled" type="text" disabled>
          </div>
        </div>
        <div class="field">
          <label class="label">{{ $t("activationToken") }}</label>
          <div class="control">
            <input v-model="inputActivationToken" class="input" type="text">
          </div>
        </div>
        <div class="control">
          <button class="button is-primary">{{ $t("activate") }}</button>
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
  name: "activate",
  data() {
    return {
      userId: null,
      inputActivationToken: null,
      errorMsg: null,
      isSuccess: false,
      isLoading: false
    };
  },
  computed: {
    ...mapState(["storedApiUrl"])
  },
  methods: {
    doActivate() {
      this.isLoading = true;
      axios
        .get(`${this.storedApiUrl}/users/${this.userId}/activate/${this.inputActivationToken}`)
        .then(result => {
          this.isSuccess = true;
          setTimeout(() => {
            this.$store.commit("setAuthInfo", {
              id: this.userId,
              username: result.data.data.user.user_name,
              authToken: result.data.data.token
            });

            sessionStorage.setItem("id", this.userId);
            sessionStorage.setItem("username", result.data.data.user.user_name);
            sessionStorage.setItem("authToken", result.data.data.token);

            this.$router.push("/chat");
          }, 500);
        })
        .catch(e => {
          if (e.response.data.message) {
            this.errorMsg = e.response.data.message;
          } else {
            this.errorMsg = this.$t("somethingWrong");
          }
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
    this.userId = this.$route.query.id;
    this.inputActivationToken = this.$route.query.token;
  }
};
</script>
