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
  grid-template-rows: 3.25rem 1fr;
  grid-template-areas:
    "navbar navbar navbar"
    "rooms main info"
    "rooms main info";
  height: 100vh;
  background-color: $light;

  #navbar {
    grid-area: navbar;
    border-bottom: 1px solid $border;
  }

  #rooms {
    grid-area: rooms;
    margin: 0.8rem 0.4rem 0.8rem 0.8rem;
    display: grid;
    grid-template-areas:
      "room-list room-list"
      "room-join room-add";
    grid-template-columns: 1fr 1fr;
    grid-template-rows: 1fr 60px;
    background-color: $white;

    #room-list {
      grid-area: room-list;
      border-bottom: 1px solid $border;
      display: grid;
      grid-template-rows: auto 1fr auto;
      height: 100%;
      min-height: 0;

      .info-list {
        overflow: auto;
      }

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
    margin: 0.8rem 0.4rem 0.8rem 0.4rem;

    #message-panel {
      overflow: auto;
      margin-bottom: 0.8rem;
      background-color: $white;

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

        .attachment {
          background-color: $white-bis;
          padding: 0.5em;
          font-size: small;
          color: $grey-dark;

          &:not(:last-child) {
            margin-bottom: 0.3em;
          }
        }

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

          &:not(:last-child) {
            margin-bottom: 0.5rem;
          }
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
      border-bottom: 0.8rem;
      background-color: $white;

      .error-message {
        justify-self: center;
        font-size: small;
        color: red;
      }
    }

    #write-panel {
      display: grid;
      grid-template-columns: 1fr 80px;
      grid-template-rows: auto auto;
      grid-template-areas:
        "input-message message-submit"
        "input-attachment .";
      grid-gap: 6px;
      padding: 6px;
      background-color: $white;

      #input-message {
        grid-area: input-message;
        overflow: auto;
        box-shadow: unset;
      }

      #input-attachment {
        grid-area: input-attachment;
      }

      #message-submit {
        grid-area: message-submit;
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
    margin: 0.8rem 0.8rem 0.8rem 0.4rem;
    overflow: auto;
    background-color: $white;
  }

  .navbar-brand {
    text-transform: uppercase;
    font-weight: bold;
    font-size: 1.2rem;
  }
}

.info-item {
  .info-header {
    padding: 0.6em;
    background-color: $grey-dark;
    color: $white-bis;
  }

  .info-content {
    padding: 0.6em;
  }

  .info-list {
    .info-item {
      margin: 0.2rem 0;

      a {
        display: block;
        padding: 0.3em;
      }
      &:hover {
         background-color: $grey-lighter;
      }
    }

    .info-item-active {
      background-color: $cyan;

      a {
        color: white;
      }

      a:hover {
        color: white;
      }

      &:hover {
        background-color: $blue;
      }
    }
  }

  .info-content-empty {
    padding: 0.6em;
    font-size: small;
    color: $grey-light;
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

.modal-room-reject .modal-content {
  text-align: center;
}
</style>
