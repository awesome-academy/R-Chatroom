<template>
  <div class="modal is-active">
    <div class="modal-background" @click="$emit('close')"></div>
    <div class="modal-card">
      <header class="modal-card-head">
        <p class="modal-card-title">{{ $t("roomList") }}</p>
        <button class="delete" aria-label="close" @click="$emit('close')"></button>
      </header>
      <section class="modal-card-body modal-room-join">
        <form @submit.prevent="searchSubmit">
          <div class="field has-addons has-addons-centered">
            <div class="control">
              <input class="input" type="text" v-model="searchString">
            </div>
            <div class="control">
              <button class="button is-info">{{ $t("search") }}</button>
            </div>
          </div>
        </form>
        <div v-if="rooms.length > 0">
          <table class="room-list table is-fullwidth">
            <thead>
              <tr class="room-list-item">
                <th class="show-name">{{ $t("roomName") }}</th>
                <th class="room-name">{{ $t("roomShowName") }}</th>
                <th class="room-action">{{ $t("action") }}</th>
              </tr>
            </thead>
            <tr class="room-list-item" v-for="room in rooms" :key="room.id">
              <td class="show-name">{{ room.show_name }}</td>
              <td class="room-name">{{ room.room_name }}</td>
              <td class="room-action">
                <a class="button is-primary" v-if="!room.joined" @click="joinRoom(room.id)">{{ $t("join") }}</a>
                <a class="button is-danger" v-else @click="leaveRoom(room.id)">{{ $t("leave") }}</a>
              </td>
            </tr>
          </table>
          <Paginator
            :currentPage="page.currentPage"
            :perPage="page.perPage"
            :totalEntries="page.totalEntries"
            @pageChanged="getAllRoomList"
          ></Paginator>
        </div>
        <div class v-else>{{ $t("nothingFound") }}</div>
      </section>
      <footer class="modal-card-foot">
        <button class="button" @click="$emit('close')">Close</button>
      </footer>
    </div>
  </div>
</template>

<script>
import { mapState } from "vuex";
import axios from "axios";
import Paginator from "./Paginator";

export default {
  data() {
    return {
      page: {
        currentPage: 1,
        perPage: null,
        totalEntries: null
      },
      rooms: [],
      searchString: ""
    };
  },
  components: {
    Paginator
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
    async getAllRoomList(navigatePage = null) {
      if (navigatePage) {
        this.page.currentPage = navigatePage;
      }
      await axios
        .get(
          `${this.storedApiUrl}/rooms`,
          {
            params: {
              "page": this.page.currentPage,
              "q[room_name_or_show_name_or_description_cont]": this.searchString
            },
            headers: this.loginHeader
          }
        )
        .then(result => {
          this.rooms = result.data.data.rooms;
          this.page.perPage = result.data.data.page.per_page;
          this.page.totalEntries = result.data.data.page.total_entries;
        })
        .catch(e => {
          console.log(e);
        });
    },
    searchSubmit() {
      this.page.currentPage = 1;
      this.getAllRoomList();
    },
    async joinRoom(roomId) {
      await axios
        .post(
          `${this.storedApiUrl}/rooms/${roomId}/join`,
          {},
          {
            headers: this.loginHeader
          }
        )
        .then(result => {
          this.getAllRoomList();
          this.reloadJoinedRoomList();
        })
        .catch(e => {
          console.log(e);
        });
    },
    async leaveRoom(roomId) {
      await axios
        .post(
          `${this.storedApiUrl}/rooms/${roomId}/leave`,
          {},
          {
            headers: this.loginHeader
          }
        )
        .then(result => {
          this.getAllRoomList(this.page.currentPage);
          this.reloadJoinedRoomList();
        })
        .catch(e => {
          console.log(e);
        });
    },
    reloadJoinedRoomList() {
      this.$emit("reloadJoinedRoomList");
    }
  },
  async mounted() {
    await this.getAllRoomList();
  }
};
</script>
