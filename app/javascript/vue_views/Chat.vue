<template>
  <div class="home-container">
    <nav id="navbar" class="navbar is-light">
      <div class="navbar-brand">
        <a class="navbar-item">R-chatroom</a>
      </div>
      <div class="navbar-menu">
        <div class="navbar-end">
          <div class="navbar-item">
            <div class="buttons">
              <router-link to="/account" class="button is-light">{{ $t("account") }}</router-link>
              <router-link to="/logout" class="button is-light">{{ $t("logout") }}</router-link>
            </div>
          </div>
        </div>
      </div>
    </nav>
    <aside id="rooms">
      <div class="menu" id="room-list">
        <p class="menu-label">Groups</p>
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
        <p class="menu-label">Friends</p>
      </div>
      <div id="room-join" class="is-white">
        <a class="button" @click="showRoomJoin = true">Join Room</a>
      </div>
      <div id="room-add" class="is-white">
        <a class="button" @click="showRoomCreate = true">Add Room</a>
      </div>
    </aside>
    <RoomShow v-if="selectedRoom != null" :RoomId="selectedRoom"/>
    <RoomJoin
      v-if="showRoomJoin"
      @close="showRoomJoin = false"
      @reloadJoinedRoomList="getRoomList"
    />
    <RoomCreate
      v-if="showRoomCreate"
      @close="showRoomCreate = false"
      @reloadJoinedRoomList="getRoomList"
    />
  </div>
</template>

<style lang="scss" scoped>
</style>

<script>
import axios from "axios";
import { mapState } from "vuex";
import ActionCable from "actioncable";
import RoomShow from "../vue_components/RoomShow.vue";
import RoomJoin from "../vue_components/RoomJoin.vue";
import RoomCreate from "../vue_components/RoomCreate.vue";

var ac = {};

export default {
  name: "chat",
  data() {
    return {
      userDetail: {},
      rooms: [],
      messages: [],
      inputMessage: null,
      selectedRoom: null,
      showRoomJoin: false,
      showRoomCreate: false
    };
  },
  components: {
    RoomShow,
    RoomJoin,
    RoomCreate
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
        .get(`${this.storedApiUrl}/users/${this.storedUserId}/rooms`, {
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
