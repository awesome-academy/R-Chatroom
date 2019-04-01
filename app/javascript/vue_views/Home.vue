<template>
  <div>
    <div>Welcome {{ storedUsername }}!</div>
    <div>{{ userDetail }}</div>
  </div>
</template>

<style scoped>
</style>

<script>
import axios from "axios";
import { mapState } from "vuex";

export default {
  name: "home",
  data() {
    return {
      userId: null,
      username: null,
      userDetail: {}
    };
  },
  computed: {
    ...mapState([
      "storedApiUrl",
      "storedAuthToken",
      "storedUserId",
      "storedUsername"
    ])
  },
  methods: {
    getUserDetail: function() {
      axios
        .get(`${this.storedApiUrl}/users/${this.storedUserId}`, {
          withCredentials: true,
          auth: {
            username: this.storedUsername,
            password: this.storedAuthToken
          }
        })
        .then(result => {
          this.userDetail = result.data.data;
        })
        .catch(e => {
          console.log(e.response);
          console.log(e.request);
          this.userDetail = e;
        });
    }
  },
  mounted() {
    this.getUserDetail();
  }
};
</script>
