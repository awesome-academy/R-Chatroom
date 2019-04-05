<template>
  <div class="modal is-active">
    <div class="modal-background" @click="$emit('close')"></div>
    <div class="modal-card">
      <header class="modal-card-head">
        <p class="modal-card-title">{{ $t("updateRoom") }}</p>
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
            <label class="label">Room Name</label>
            <div class="control">
              <input v-model="inputRoomName" class="input" type="text" disabled>
            </div>
          </div>
          <div class="field">
            <label class="label">Show Name</label>
            <div class="control">
              <input v-model="inputShowName" class="input" type="text">
            </div>
          </div>
          <div class="field">
            <label class="label">Description</label>
            <div class="control">
              <textarea v-model="inputDescription" class="textarea"></textarea>
            </div>
          </div>
        </section>
        <footer class="modal-card-foot">
          <button class="button is-primary">{{ $t("update") }}</button>
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
      inputRoomName: this.roomObj.room_name,
      inputShowName: this.roomObj.show_name,
      inputDescription: this.roomObj.description,
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
  props: ["roomObj"],
  methods: {
    doCreate() {
      this.isLoading = true;
      axios
        .put(
          `${this.storedApiUrl}/rooms/${this.roomObj.id}`,
          {
            room: {
              show_name: this.inputShowName,
              description: this.inputDescription
            }
          },
          {
            auth: {
              username: this.storedUsername,
              password: this.storedAuthToken
            }
          }
        )
        .then(result => {
          this.isSuccess = true;
          setTimeout(() => {
            this.$emit("reloadJoinedRoomList");
            this.$emit("reloadCurrentRoom");
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
