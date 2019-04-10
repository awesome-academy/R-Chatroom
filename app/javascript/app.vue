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

.index-container {
  display: grid;
  width: 100vw;
  height: 100vh;

  .index-box {
    align-self: center;
    justify-self: center;
    width: 35%;
    display: grid;
    grid-template-areas:
      "info info"
      "login-nav logout-nav";

    #info {
      grid-area: info;
      font-weight: bold;
      font-size: large;
      text-align: center;
    }

    #login-nav {
      grid-area: login-nav;
      justify-self: center;
    }

    #register-nav {
      grid-area: logout-nav;
      justify-self: center;
    }
  }
}

.home-container {
  display: grid;
  grid-template-columns: 1fr 4fr;
  grid-template-rows: 60px 1fr;
  grid-template-areas:
    "navbar navbar"
    "rooms main"
    "rooms main";
  height: 100vh;

  #navbar {
    grid-area: navbar;
    border-bottom: 1px solid $border;
  }

  #rooms {
    grid-area: rooms;
    border-right: 1px solid $border;
    display: grid;
    grid-template-areas:
      "room-list room-list"
      "room-join room-add";
    grid-template-columns: 1fr 1fr;
    grid-template-rows: 1fr 60px;

    #room-list {
      grid-area: room-list;
      border-bottom: 1px solid $border;
      padding: 1em;

      .room-selected {
        font-weight: bold;
      }

      .show-name {
        text-transform: uppercase;
        font-size: small;
      }

      .room-name {
        text-transform: lowercase;
        font-size: x-small;
        color: $grey-dark;
      }
    }

    #room-join {
      grid-area: room-join;
      justify-self: center;
      align-self: center;
    }

    #room-add {
      grid-area: room-add;
      justify-self: center;
      align-self: center;
    }
  }

  #main {
    display: grid;
    grid-template-rows: 1fr 120px;
    grid-area: main;

    #message-panel {
      overflow: auto;
      border-bottom: 1px solid $border;
      .chat-user {
        margin-bottom: 6px;
      }

      .chat-user a {
        font-family: monospace;
      }

      .chat-time {
        color: $grey-light;
        font-size: small;
      }

      .chat-message {
        padding: 0.5rem;
        border-bottom: 1px solid $white-ter;

        .load-more {
          text-align: center;
          font-size: small;

          a {
            color: $grey-light;

            &:hover {
              color: $grey;
            }
          }
        }

        .no-message {
          text-align: center;
          font-size: small;
          color: $grey-light;
        }
      }
    }

    #write-panel {
      display: grid;
      grid-template-columns: 1fr 80px;
      grid-gap: 6px;
      padding: 6px;

      #input-message {
        textarea {
          height: 100%;
          max-height: 100%;
          min-height: 100%;
        }
      }

      #message-submit {
        justify-self: center;
        align-self: center;
      }
    }
  }

  .navbar-brand {
    text-transform: uppercase;
    font-weight: bold;
    font-size: 1.2rem;
  }
}

.modal-room-join {
  .room-list-item {
    .show-name {
      width: 40%;
    }

    .room-name {
      width: 40%;
    }

    .room-action {
      width: 20%;
    }
  }
}
</style>
