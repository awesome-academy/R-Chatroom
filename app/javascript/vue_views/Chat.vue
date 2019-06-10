<template>
  <div class="home-container">
    <nav id="navbar" class="navbar is-dark">
      <div class="navbar-brand">
        <a class="navbar-item">R-chatroom</a>
      </div>
      <div class="navbar-menu">
        <div class="navbar-end">
          <a class="navbar-item">{{ userDetail.user_name }}</a>
          <router-link class="navbar-item" to="/logout">{{ $t("logout") }}</router-link>
        </div>
      </div>
    </nav>
    <aside id="rooms">
      <div id="room-list" class="info-item">
          <div class="info-header">{{ $t("groups") }}</div>
          <div class="info-list" v-if="rooms.length > 0">
            <div class="info-item" v-for="room in rooms" :key="room.id"
              :class="{'info-item-active': selectedRoom == room.id}"
            >
              <a @click="selectedRoom = room.id">
                <div class="show-name">{{ room.show_name }}</div>
                <div class="room-name">{{ room.room_name }}</div>
              </a>
            </div>
          </div>
          <Paginator v-if="rooms.length > 0"
            :currentPage="roomsPage.currentPage"
            :perPage="roomsPage.perPage"
            :totalEntries="roomsPage.totalEntries"
            :smaller="true"
            @pageChanged="getRoomList"></Paginator>
          <div class="info-content-empty" v-if="rooms.length == 0">
            {{ $t("nothingHere") }}
          </div>
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
          <button
            @click="showUpdateRoom = true"
            class="button is-primary is-small"
          >{{ $t("update") }}</button>
          <button
            @click="showMembersRoom = true"
            class="button is-primary is-small"
          >{{ $t("members") }}</button>
          <button
            @click="showDeleteRoom = true"
            class="button is-danger is-small"
          >{{ $t("delete") }}</button>
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
import Paginator from "../vue_components/Paginator";
var ac = {};

export default {
  name: "chat",
  data() {
    return {
      userDetail: {},
      rooms: [],
      roomsPage: {
        currentPage: 1,
        perPage: null,
        totalEntries: null
      },
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
    RoomMembers,
    Paginator
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
      if (this.selectedRoomObj.description) {
        return paragraphs(this.selectedRoomObj.description);
      } else {
        return null;
      }
    }
  },
  methods: {
    async getUserDetail() {
      await axios
        .get(
          `${this.storedApiUrl}/users/${this.storedUserId}`,
          {
            headers: this.loginHeader
          }
        )
        .then(result => {
          this.userDetail = result.data.data.user;
        })
        .catch(e => {
          this.$router.push("/login");
        });
    },
    async getRoomList(navigatePage = null) {
      if (navigatePage) {
        this.roomsPage.currentPage = navigatePage;
      }
      await axios
        .get(
          `${this.storedApiUrl}/users/${this.storedUserId}/rooms`,
          {
            params: {
              page: this.roomsPage.currentPage
            },
            headers: this.loginHeader
          }
        )
        .then(result => {
          this.roomsPage.perPage = result.data.data.page.per_page;
          this.roomsPage.totalEntries = result.data.data.page.total_entries;
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
