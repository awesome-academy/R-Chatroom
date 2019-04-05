<template>
  <div class="chat-message">
    <div class="chat-user">
      <a>{{ message.username }}</a>
      <span class="chat-time">{{ createdAt }}</span>
    </div>
    <p class="chat-content">{{ message.content }}</p>
  </div>
</template>

<script>
import dayjs from "dayjs";
import relativeTime from "dayjs/plugin/relativeTime";
dayjs.extend(relativeTime);

export default {
  data() {
    return {};
  },
  props: ["message"],
  computed: {
    createdAt() {
      return dayjs(this.message.created_at).fromNow();
    }
  }
};
</script>
