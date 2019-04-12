<template></template>

<style></style>

<script>
export default {
  mounted() {
    localStorage.clear();
    sessionStorage.clear();
    this.$store.commit("setAuthInfo", {
      id: null,
      username: null,
      authToken: null
    });
    this.$router.push("/login");
  }
};
</script>
