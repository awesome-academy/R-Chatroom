<template>
  <nav class="pagination" role="navigation" aria-label="pagination"
    :class="{'is-small': smaller}">
    <div class="dropdown-background"
      v-if="isDropdownActive" @click="isDropdownActive = false"></div>
    <button class="button pagination-previous" :disabled="currentPage <= 1"
      @click="pageChanging(currentPage - 1)">
      {{ $t("previous") }}
    </button>
    <button class="button pagination-next" :disabled="currentPage >= totalPages"
      @click="pageChanging(currentPage + 1)">
      {{ $t("next") }}
    </button>
    <div class="pagination-list dropdown is-up" :class="{'is-active': isDropdownActive}">
      <div class="dropdown-trigger" @click="isDropdownActive = !isDropdownActive">
        <button class="button" aria-haspopup="true" aria-controls="dropdown-menu"
          :class="{'is-small': smaller}">
          <span>{{ currentPage }}</span>
          <span class="icon">
            ▼
          </span>
        </button>
      </div>
      <div class="dropdown-menu" id="dropdown-menu" role="menu">
        <div class="dropdown-content">
          <a @click="pageChanging(index)"
            v-for="index in totalPages" :key="index"
            class="dropdown-item" :class="{'is-active': index == currentPage}">
            {{ index }}
          </a>
        </div>
      </div>
    </div>
  </nav>
</template>

<style scoped lang="scss">
  .dropdown.is-active {
    z-index: 1001;
  }
  .dropdown-background {
    width: 100vw;
    height: 100vh;
    position: absolute;
    top: 0;
    left: 0;
    z-index: 1000;
    background-color: rgba(0, 0, 0, 0.14);
  }
  nav {
    margin: 0.25rem;
  }
</style>

<script>
  export default {
    data() {
      return {
        isDropdownActive: false
      }
    },
    props: {
      currentPage: Number,
      totalEntries: Number,
      perPage: Number,
      smaller: Boolean
    },
    computed: {
      totalPages() {
        if (this.totalEntries) {
          return Math.ceil(this.totalEntries/this.perPage);
        } else {
          return 0;
        }
      }
    },
    methods: {
      pageChanging(changeToPage) {
        this.$emit("pageChanged", changeToPage);
        this.isDropdownActive = false;
      }
    }
  }
</script>
