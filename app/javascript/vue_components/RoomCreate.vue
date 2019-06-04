<template>
  <div class="modal is-active">
    <div class="modal-background" @click="$emit('close')"></div>
    <div class="modal-card">
      <header class="modal-card-head">
        <p class="modal-card-title">{{ $t("createNewRoom") }}</p>
        <button class="delete" aria-label="close" @click="$emit('close')"></button>
      </header>
      <form @submit.prevent="doCreate">
        <section class="modal-card-body">
          <div v-if="isLoading" class="notification is-primary">{{ $t("pleaseWait") }}</div>
          <div v-if="isSuccess" class="notification is-success">{{ $t("createdSuccessfully") }}</div>
          <div v-if="errorMsg" class="notification is-warning">
            <ul>
              <li v-for="(err, index) in errorMsg" :key="index">{{ err }}</li>
            </ul>
          </div>

          <div class="field">
            <label class="label">{{ $t("roomName") }}</label>
            <div class="control">
              <input v-model="inputRoomName" class="input" type="text">
            </div>
          </div>
          <div class="field">
            <label class="label">{{ $t("roomShowName") }}</label>
            <div class="control">
              <input v-model="inputShowName" class="input" type="text">
            </div>
          </div>
          <div class="field">
            <label class="label">{{ $t("description") }}</label>
            <div class="control">
              <textarea v-model="inputDescription" class="textarea"></textarea>
            </div>
          </div>
        </section>
        <footer class="modal-card-foot">
          <button class="button is-primary">{{ $t("create") }}</button>
          <button class="button" @click="$emit('close')">{{ $t("close") }}</button>
        </footer>
      </form>
    </div>
  </div>
</template>

<script>
import { mapState } from "vuex";
import axios from "axios";

export default {
  data() {
    return {
      inputRoomName: null,
      inputShowName: null,
      inputDescription: null,
      errorMsg: null,
      isLoading: null,
      isSuccess: null
    };
  },
  computed: {
    ...mapState([
      "storedApiUrl",
      "storedWsUrl",
      "storedAuthToken",
      "storedUserId",
      "storedUsername"
    ])
  },
  props: [""],
  methods: {
    doCreate() {
      this.isLoading = true;
      axios
        .post(
          `${this.storedApiUrl}/rooms`,
          {
            room: {
              show_name: this.inputShowName,
              room_name: this.inputRoomName,
              description: this.inputDescription
            }
          },
          {
            headers: this.loginHeader
          }
        )
        .then(result => {
          this.isSuccess = true;
          setTimeout(() => {
            this.$emit("reloadJoinedRoomList");
            this.$emit("close");
          }, 500);
        })
        .catch(e => {
          this.errorMsg = e.response.data.data;
          setTimeout(() => {
            this.errorMsg = null;
          }, 2000);
        })
        .then(() => {
          this.isLoading = false;
        });
    }
  },
  async mounted() {}
};
</script>
