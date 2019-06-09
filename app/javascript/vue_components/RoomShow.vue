<template>
  <main id="main">
    <div id="message-panel">
      <div class="chat-message" v-if="messagesBehind > 0">
        <div class="load-more">
          <a @click="loadMoreMessages">
            {{ $t("moreMessages", { remainingMessages: messagesBehind }) }}
          </a>
        </div>
      </div>
      <div class="chat-message" v-if="messages.length == 0">
        <div class="no-message">{{ $t("noMessage") }}</div>
      </div>
      <RoomMessage v-for="message in messages" :key="`${RoomId}-${message.id}`"
        :message="message" @scrollToBottom="scrollToBottom" />
    </div>
    <div id="error">
      <div class="error-message">{{ err }}</div>
    </div>
    <form id="write-panel" @submit.prevent="doSend">
      <textarea
        :disabled="!roomConnected || sending"
        rows="6"
        id="input-message"
        class="textarea has-fixed-size"
        v-model="inputMessage"
        autofocus="true"
        ref="inputMsg"
        @keypress="chatInputKeyPressed"
      ></textarea>
      <div id="message-submit">
        <button :disabled="!roomConnected || sending"
          class="button is-info">
          {{ $t("sendMessage") }}
        </button>
      </div>
      <div class="file has-name is-small is-info">
        <label class="file-label">
          <input class="file-input" type="file" name="resume" @change="fileChanged">
          <span class="file-cta">
            <span class="file-label">
              {{ $t("chooseAFile") }}
            </span>
          </span>
          <span class="file-name" v-if="inputAttachment">{{ inputAttachment.name }}</span>
          <span class="file-name" v-else>{{ $t("noFileSelected") }}</span>
        </label>
      </div>
    </form>
    <div class="modal modal-room-reject is-active" v-if="roomRejected">
      <div class="modal-background"></div>
      <div class="modal-content">
        {{ $t("serverRejected") }}
        <a @click="reloadPage">
          {{ $t("reloadPage") }}
        </a>
      </div>
    </div>
  </main>
</template>

<script>
import { mapState } from "vuex";
import ActionCable from "actioncable";
import RoomMessage from "./RoomMessage.vue";
import axios from "axios";

var messagesCable = {};

export default {
  data() {
    return {
      messages: [],
      inputMessage: null,
      inputAttachment: null,
      messagesBehind: null,
      roomConnected: false,
      roomRejected: false,
      err: null,
      sending: false
    };
  },
  components: {
    RoomMessage
  },
  computed: {
    ...mapState([
      "storedApiUrl",
      "storedWsUrl",
      "storedAuthToken",
      "storedUserId",
      "storedUsername",
      "storedMsgNum"
    ])
  },
  props: ["RoomId"],
  mounted() {
    this.startListening();
  },
  watch: {
    RoomId() {
      this.changeRoom();
    }
  },
  methods: {
    doSend() {
      this.sending = true;
      let formData = new FormData();
      if (this.inputMessage != null) {
        formData.append("message[content]", this.inputMessage)
      }
      if (this.inputAttachment != null) {
        formData.append("message[attachment]", this.inputAttachment)
      }
      axios
        .post(
          `${this.storedApiUrl}/rooms/${this.RoomId}/messages`,
          formData,
          {
            headers: this.loginHeader
          }
        )
        .then(() => {
          this.sending = false;
          this.inputMessage = null;
          this.inputAttachment = null;
        })
        .catch(e => {
          this.sending = false;
          this.inputAttachment = null;
          console.log(e);
        });
    },
    chatInputKeyPressed(e) {
      if (e.keyCode == 13) {
        if (!e.shiftKey) {
          e.preventDefault();
          this.doSend();
        }
      }
    },
    fileChanged(e) {
      this.inputAttachment = e.target.files[0];
    },
    loadMoreMessages() {
      messagesCable.channel.getFromId(this.messages[0].id);
    },
    startListening() {
      messagesCable.cable = ActionCable.createConsumer(
        `${this.storedWsUrl}/cable?id=${this.storedUserId}&token=${this.storedAuthToken}&room_id=${this.RoomId}`
      );
      messagesCable.channel = messagesCable.cable.subscriptions.create(
        {
          channel: "MessagesChannel"
        },
        {
          connected: () => {
            if (this.messages.length == 0) {
              messagesCable.channel.getInitialMessages();
            } else {
              messagesCable.channel.getAfterId(
                this.messages[this.messages.length - 1].id
              );
            }
            this.roomConnected = true;
            this.err = null;
          },
          disconnected: () => {
            this.roomConnected = false;
            this.err = this.$t("disconnected");
            this.scrollToBottom();
          },
          rejected: () => {
            this.roomRejected = true;
          },
          received: data => {
            if (data.type == "receive" || data.type == "receive_latest") {
              this.messages = [...this.messages, ...data.messages];
              this.scrollToBottom();
            } else if (data.type == "receive_from_id") {
              this.messages = [...data.messages, ...this.messages];
            } else if (data.type == "error") {
              this.err = data.message;
              this.scrollToBottom();
              setTimeout(() => {
                this.err = null;
              }, 1200);
            }

            if (data.type == "receive_latest" || data.type == "receive_from_id") {
              this.messagesBehind = data.behind;
            }
          },
          sendMessage: data => {
            return messagesCable.channel.perform("receive", data);
          },
          getInitialMessages: () => {
            return messagesCable.channel.perform("receive_latest", {
              total_messages: this.storedMsgNum
            });
          },
          getFromId: id => {
            return messagesCable.channel.perform("receive_from_id", {
              less_than_id: id,
              total_messages: this.storedMsgNum
            });
          },
          getAfterId: id => {
            return messagesCable.channel.perform("receive_after_id", {
              more_than_id: id,
              total_messages: this.storedMsgNum
            });
          }
        }
      );
    },
    scrollToBottom() {
      this.$nextTick(() => {
        let messagesDiv = this.$el.querySelector("#message-panel");
        messagesDiv.scrollTop = messagesDiv.scrollHeight;
      });
    },
    changeRoom() {
      messagesCable.channel.unsubscribe();
      this.messagesBehind = 0;
      this.messages = [];
      this.startListening();
      this.$refs.inputMsg.focus();
    },
    reloadPage() {
      this.$router.go();
    }
  }
};
</script>
