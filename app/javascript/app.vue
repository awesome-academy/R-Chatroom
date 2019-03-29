<template>
  <div id="app">
    <router-view/>
  </div>
</template>

<style lang="scss">
@import "bulma/bulma.sass";

html {
  overflow-y: auto;
}

.form-container {
  display: grid;
  width: 100vw;
  height: 100vh;
  .form-box {
    align-self: center;
    justify-self: center;
    padding: $size-4;
    background-color: $white-bis;
    border: 1px solid $border;
    border-radius: $radius-large;
    width: 35%;
  }
}
</style>
