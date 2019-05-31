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
  grid-template-columns: 1fr 4fr 1fr;
  grid-template-rows: 60px 1fr;
  grid-template-areas:
    "navbar navbar navbar"
    "rooms main info"
    "rooms main info";
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
      overflow: auto;

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

      .no-item {
        font-size: small;
        color: $grey;
        margin-left: 0.6em;
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
    grid-template-rows: 1fr auto 120px;
    grid-area: main;

    #message-panel {
      overflow: auto;
      border-bottom: 1px solid $border;

      .chat-message {
        display: grid;
        padding: 0.7em;
        border-bottom: 1px solid $white-ter;
        grid-template-areas:
          "showname chat-time"
          "username chat-time"
          "chat-content chat-content";
        justify-content: space-between;
        align-content: space-evenly;

        .showname {
          grid-area: showname;
        }

        .username {
          grid-area: username;
          color: $grey;
          font-size: small;
          font-family: monospace;
        }

        .chat-time {
          grid-area: chat-time;
          color: $grey-light;
          font-size: small;
          align-self: center;
          text-align: right;
        }

        .chat-content {
          margin-top: 0.5em;
          grid-area: chat-content;
        }

        .load-more {
          grid-row: 1 / span 3;
          grid-column: 1 / span 2;
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
          grid-row: 1 / span 3;
        }
      }
    }

    #error {
      display: grid;
      border-bottom: 1px solid $border;

      .error-message {
        justify-self: center;
        font-size: small;
        color: red;
      }
    }

    #write-panel {
      display: grid;
      grid-template-columns: 1fr 80px;
      grid-gap: 6px;
      padding: 6px;

      #input-message {
        overflow: auto;
      }

      #message-submit {
        justify-self: center;
        align-self: center;
      }
    }

    .disconnected {
      color: $red;
      font-size: small;
      justify-self: center;
      align-self: center;
    }
  }

  .no-room {
    font-size: small;
    color: $grey;
    justify-self: center;
    align-self: center;
    grid-row: 2 / span 1;
    grid-column: 2 / span 2;
  }

  #info {
    grid-area: info;
    border-left: 1px solid $border;
    overflow: auto;

    .info-item {
      .info-header {
        padding: 0.6em;
        background-color: $white-ter;
        color: $black-bis;
      }

      .info-content {
        padding: 0.6em;
      }

      .info-content-empty {
        padding: 0.6em;
        font-size: small;
        color: $grey-light;
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
  td {
    vertical-align: middle;
  }

  .room-list-item {
    .show-name {
      width: 40%;
    }

    .room-name {
      width: 40%;
    }

    .room-action {
      text-align: right;
      width: 20%;
    }
  }
}

.modal-member-list {
  .member-list-item {
    td {
      vertical-align: middle;
    }

    .show-name {
      width: 30%;
    }

    .user-name {
      width: 30%;
    }

    .user-action {
      text-align: right;
      width: 40%;
    }
  }
}

.modal-room-reject .modal-content {
  text-align: center;
}
</style>
