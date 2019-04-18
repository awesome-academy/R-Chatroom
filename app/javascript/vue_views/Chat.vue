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
              <a class="button is-light">{{ userDetail.user_name }}</a>
              <router-link to="/logout" class="button is-danger">{{ $t("logout") }}</router-link>
            </div>
          </div>
        </div>
      </div>
    </nav>
    <aside id="rooms">
      <div class="menu" id="room-list">
        <p class="menu-label">{{ $t("groups") }}</p>
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
        <div class="no-item" v-if="rooms.length == 0">{{ $t("nothingHere") }}</div>
        <p class="menu-label">{{ $t("friends") }}</p>
        <div class="no-item">{{ $t("nothingHere") }}</div>
      </div>
      <div id="room-join" class="is-white">
        <a class="button" @click="showRoomJoin = true">{{ $t("joinRoom") }}</a>
      </div>
      <div id="room-add" class="is-white">
        <a class="button" @click="showRoomCreate = true">{{ $t("addRoom") }}</a>
      </div>
    </aside>
    <RoomShow v-if="selectedRoom" :RoomId="selectedRoom"/>
    <div class="no-room" v-else>{{ $t("noRoom") }}</div>
    <aside id="info" v-if="selectedRoomObj">
      <div class="info-item">
        <div class="info-header">{{ $t("description") }}</div>
        <p class="info-content content" v-if="selectedRoomObj.description" v-html="roomDescription"></p>
        <p class="info-content-empty" v-else>{{ $t("missingDescriptionMsg") }}</p>
      </div>
      <div class="info-item" v-if="selectedRoomObj.is_admin == true">
        <div class="info-header">{{ $t("adminActions") }}</div>
        <p class="info-content">
          <button @click="showUpdateRoom = true" class="button is-primary is-small">{{ $t("update") }}</button>
          <button @click="showMembersRoom = true" class="button is-primary is-small">{{ $t("members") }}</button>
          <button @click="showDeleteRoom = true" class="button is-danger is-small">{{ $t("delete") }}</button>
        </p>
      </div>
    </aside>
    <RoomUpdate
      v-if="showUpdateRoom"
      :roomObj="selectedRoomObj"
      @close="showUpdateRoom = false"
      @reloadJoinedRoomList="getRoomList"
      @reloadCurrentRoom="selectedRoom = selectedRoomObj.id"
    />
    <RoomMembers
      v-if="showMembersRoom"
      :roomObj="selectedRoomObj"
      @close="showMembersRoom = false"
      @reloadCurrentRoom="selectedRoom = selectedRoomObj.id"
    />
    <RoomDelete
      v-if="showDeleteRoom"
      :roomObj="selectedRoomObj"
      @close="showDeleteRoom = false"
      @reloadJoinedRoomList="getRoomList"
      @reloadCurrentRoom="selectedRoom = selectedRoomObj.id"
    />
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
import paragraphs from "lines-to-paragraphs";
import RoomShow from "../vue_components/RoomShow.vue";
import RoomJoin from "../vue_components/RoomJoin.vue";
import RoomCreate from "../vue_components/RoomCreate.vue";
import RoomUpdate from "../vue_components/RoomUpdate.vue";
import RoomDelete from "../vue_components/RoomDelete.vue";
import RoomMembers from "../vue_components/RoomMembers.vue";

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
      showRoomCreate: false,
      showUpdateRoom: false,
      showMembersRoom: false,
      showDeleteRoom: false
    };
  },
  components: {
    RoomShow,
    RoomJoin,
    RoomCreate,
    RoomUpdate,
    RoomDelete,
    RoomMembers
  },
  computed: {
    ...mapState([
      "storedApiUrl",
      "storedAuthToken",
      "storedUserId",
      "storedUsername"
    ]),
    selectedRoomObj() {
      return this.rooms.find(room => room.id == this.selectedRoom);
    },
    roomDescription() {
      if (this.selectedRoomObj.description){
        return paragraphs(this.selectedRoomObj.description);
      } else {
        return null;
      }
    }
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
          this.userDetail = result.data.data.user;
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
          if (this.rooms[0]) {
            this.selectedRoom = this.rooms[0].id;
          } else {
            this.selectedRoom = null;
          }
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
