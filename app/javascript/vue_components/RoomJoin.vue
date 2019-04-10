<template>
  <div class="modal is-active">
    <div class="modal-background" @click="$emit('close')"></div>
    <div class="modal-card">
      <header class="modal-card-head">
        <p class="modal-card-title">{{ $t("roomList") }}</p>
        <button class="delete" aria-label="close" @click="$emit('close')"></button>
      </header>
      <section class="modal-card-body modal-room-join">
        <form @submit="getAllRoomList">
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
            <tr class="room-list-item" v-for="room in rooms" :key="room.id">
              <td class="show-name">{{ room.show_name }}</td>
              <td class="room-name">{{ room.room_name }}</td>
              <td class="room-action">
                <a class="button is-primary" v-if="!room.joined" @click="joinRoom(room.id)">Join</a>
                <a class="button is-danger" v-else @click="leaveRoom(room.id)">Leave</a>
              </td>
            </tr>
          </table>
          <Pagination
            v-model="page.currentPage"
            :records="page.totalEntries"
            :per-page="page.perPage"
            @paginate="getAllRoomList"
            :options="{theme: 'bulma'}"
          ></Pagination>
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
import Pagination from "vue-pagination-2";

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
    Pagination
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
    async getAllRoomList() {
      let page = this.page.currentPage;
      await axios
        .get(
          `${this.storedApiUrl}/rooms?search_string=${this.searchString}&page=${page}`,
          {
            auth: {
              username: this.storedUsername,
              password: this.storedAuthToken
            }
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
    async joinRoom(roomId) {
      await axios
        .post(
          `${this.storedApiUrl}/rooms/join`,
          {
            id: roomId
          },
          {
            auth: {
              username: this.storedUsername,
              password: this.storedAuthToken
            }
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
    async leaveRoom(roomId) {
      await axios
        .post(
          `${this.storedApiUrl}/rooms/leave`,
          {
            id: roomId
          },
          {
            auth: {
              username: this.storedUsername,
              password: this.storedAuthToken
            }
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
