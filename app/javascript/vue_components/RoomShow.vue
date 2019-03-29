<template>
  <main id="main">
    <div id="message-panel">
      <RoomMessage v-for="message in messages" :key="`${RoomId}-${message.id}`" :message="message"/>
    </div>
    <form id="write-panel" v-on:submit="doSend">
      <textarea
        rows="6"
        id="input-message"
        class="textarea has-fixed-size"
        v-model="inputMessage"
        autofocus="true"
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
      inputMessage: null
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
      "storedUsername"
    ])
  },
  props: ["RoomId"],
  mounted() {
    this.startListening();
  },
  watch: {
    RoomId() {
      messagesCable.channel.unsubscribe();
      this.messages = [];
      this.startListening();
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
    startListening() {
      messagesCable.cable = ActionCable.createConsumer(
        `${this.storedWsUrl}/cable?id=${this.storedUserId}&token=${
          this.storedAuthToken
        }`
      );

      messagesCable.channel = messagesCable.cable.subscriptions.create(
        {
          channel: "MessagesChannel",
          room_id: this.RoomId
        },
        {
          received: data => {
            data.forEach(message => {
              this.messages.push(message);
            });
            this.$nextTick(() => {
              let messagesDiv = this.$el.querySelector("#message-panel");
              messagesDiv.scrollTop = messagesDiv.scrollHeight;
            });
          },
          sendMessage: function(data) {
            return this.perform("receive", data);
          }
        }
      );
    }
  }
};
</script>
