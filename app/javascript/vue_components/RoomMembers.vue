<template>
  <div class="modal is-active">
    <div class="modal-background" @click="$emit('close')"></div>
    <div class="modal-card">
      <header class="modal-card-head">
        <p class="modal-card-title">{{ $t("memberList") }}</p>
        <button class="delete" aria-label="close" @click="$emit('close')"></button>
      </header>
      <section class="modal-card-body modal-member-list">
        <form @submit.prevent="getMemberList">
          <div class="field has-addons has-addons-centered">
            <div class="control">
              <input class="input" type="text" v-model="searchString">
            </div>
            <div class="control">
              <button class="button is-info">{{ $t("search") }}</button>
            </div>
          </div>
        </form>
        <div v-if="members.length > 0">
          <table class="member-list table is-fullwidth">
            <tr class="member-list-item" v-for="member in members" :key="member.id">
              <td class="show-name">{{ member.show_name }}</td>
              <td class="user-name">{{ member.user_name }}</td>
              <td class="user-action">
                <a class="button is-danger" @click="removeMember(member.id)">{{ $t("remove") }}</a>
              </td>
            </tr>
          </table>
          <Pagination
            v-model="page.currentPage"
            :records="page.totalEntries"
            :per-page="page.perPage"
            @paginate="getMemberList"
            :options="{theme: 'bulma'}"
          ></Pagination>
        </div>
        <div class v-else>{{ $t("nothingFound") }}</div>
      </section>
      <footer class="modal-card-foot">
        <button class="button" @click="$emit('close')">{{ $t("close") }}</button>
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
      members: [],
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
  props: ["roomObj"],
  methods: {
    async getMemberList() {
      await axios
        .get(
          `${this.storedApiUrl}/rooms/${this.roomObj.id}/users`,
          {
            params: {
              "page": this.page.currentPage,
              "q[user_name_or_show_name_cont]": this.searchString
            },
            headers: this.loginHeader
          }
        )
        .then(result => {
          this.members = result.data.data.users;
          this.page.perPage = result.data.data.page.per_page;
          this.page.totalEntries = result.data.data.page.total_entries;
        })
        .catch(e => {
          console.log(e);
        });
    },
    async removeMember(memberId) {
      await axios
        .delete(
          `${this.storedApiUrl}/rooms/${this.roomObj.id}/users/${memberId}/kick`,
          this.axiosOptionObject
        )
        .then(result => {
          this.getMemberList();
        })
        .catch(e => {
          console.log(e);
        });
    }
  },
  async mounted() {
    await this.getMemberList();
  }
};
</script>
