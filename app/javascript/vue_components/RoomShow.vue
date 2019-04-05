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
    <form id="write-panel" v-on:submit="doSend">
      <textarea
        rows="6"
        id="input-message"
        class="textarea has-fixed-size"
        v-model="inputMessage"
        autofocus="true"
        ref="inputMsg"
      ></textarea>
      <button id="message-submit" class="button is-white">{{ $t("sendMessage") }}</button>
    </form>
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
      wsUrlString: null
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
      messagesCable.channel.unsubscribe();
      this.messagesBehind = 0;
      this.messages = [];
      this.startListening();
      this.$refs.inputMsg.focus();
    }
  },
  methods: {
    doSend() {
      let sendData = {
        room_id: this.$route.params.roomId,
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
        `${this.storedWsUrl}/cable?id=${this.storedUserId}&token=${this.storedAuthToken}`
      );
      messagesCable.channel = messagesCable.cable.subscriptions.create(
        {
          channel: "MessagesChannel",
          room_id: this.RoomId
        },
        {
          connected: () => {
            messagesCable.channel.getInitialMessages();
          },
          received: data => {
            if (data.type == "receive" || data.type == "receive_latest") {
              this.messages = [...this.messages, ...data.messages];
              this.$nextTick(() => {
                let messagesDiv = this.$el.querySelector("#message-panel");
                messagesDiv.scrollTop = messagesDiv.scrollHeight;
              });
            } else if (data.type == "receive_from_id") {
              this.messages = [...data.messages, ...this.messages];
            }
            this.messagesBehind = data.behind;
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
          }
        }
      );
    }
  }
};
</script>
