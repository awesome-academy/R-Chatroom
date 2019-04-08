<template></template>

<style></style>

<script>
export default {
  mounted() {
    localStorage.clear();
    sessionStorage.clear();
    this.$router.push("/login");
  }
};
</script>
