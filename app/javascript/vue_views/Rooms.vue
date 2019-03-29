<template>
  <div class="home-container">
    <nav id="navbar" class="navbar">
      <div class="navbar-brand">
        <a class="navbar-item">R-chatroom</a>
      </div>
      <div class="navbar-menu">
        <div class="navbar-end">
          <div class="navbar-item">
            Logged in as
            <a href="#" style="margin-left: 4px;">{{ storedUsername }}</a>.
          </div>
          <div class="navbar-item">
            <router-link to="/logout" class="button">{{ $t("logout") }}</router-link>
          </div>
        </div>
      </div>
    </nav>
    <aside id="rooms" class="menu">
      <ul class="menu-list">
        <li v-for="room in rooms" :key="room.id">
          <a
            @click="selectedRoom = room.id"
            v-bind:class="{'room-selected': selectedRoom == room.id}"
          >
            <div class="show-name">{{ room.show_name }}</div>
            <div class="room-name">{{ room.room_name }}</div>
          </a>
        </li>
      </ul>
    </aside>
    <RoomShow :RoomId="selectedRoom"/>
  </div>
</template>

<style lang="scss" scoped>
</style>

<script>
import axios from "axios";
import { mapState } from "vuex";
import ActionCable from "actioncable";
import RoomShow from "../vue_components/RoomShow.vue";

var ac = {};

export default {
  name: "rooms",
  data() {
    return {
      userDetail: {},
      rooms: [],
      messages: [],
      inputMessage: null,
      selectedRoom: null
    };
  },
  components: {
    RoomShow
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
    async getUserDetail() {
      await axios
        .get(`${this.storedApiUrl}/users/${this.storedUserId}`, {
          auth: {
            username: this.storedUsername,
            password: this.storedAuthToken
          }
        })
        .then(result => {
          this.userDetail = result.data;
        })
        .catch(e => {
          this.$router.push("/login");
        });
    },
    async getRoomList() {
      await axios
        .get(`${this.storedApiUrl}/rooms`, {
          auth: {
            username: this.storedUsername,
            password: this.storedAuthToken
          }
        })
        .then(result => {
          this.rooms = result.data.data.rooms;
          this.selectedRoom = this.rooms[0].id;
        })
        .catch(e => {
          console.log(e);
        });
    },
    checkLoggedIn() {
      if (!this.storedUsername || !this.storedUserId || !this.storedAuthToken) {
        return false;
      } else {
        return true;
      }
    }
  },
  async mounted() {
    if (this.checkLoggedIn() == false) {
      this.$router.push("/");
    } else {
      await this.getUserDetail();
      await this.getRoomList();
    }
  }
};
</script>
