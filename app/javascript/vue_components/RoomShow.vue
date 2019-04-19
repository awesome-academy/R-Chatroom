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
      <RoomMessage v-for="message in messages" :key="`${RoomId}-${message.id}`" :message="message"/>
    </div>
    <div id="error"><div class="error-message">{{ err }}</div></div>
    <form id="write-panel" @submit.prevent="doSend">
      <textarea
        :disabled="!roomConnected"
        rows="6"
        id="input-message"
        class="textarea has-fixed-size"
        v-model="inputMessage"
        autofocus="true"
        ref="inputMsg"
      ></textarea>
      <button :disabled="!roomConnected" id="message-submit" class="button is-white">
        {{ $t("sendMessage") }}
      </button>
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

var messagesCable = {};

export default {
  data() {
    return {
      messages: [],
      inputMessage: null,
      messagesBehind: null,
      roomConnected: false,
      roomRejected: false,
      err: null
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
      let sendData = {
        content: this.inputMessage
      };
      messagesCable.channel.sendMessage(sendData);
      this.inputMessage = null;
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
