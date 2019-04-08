<template>
  <div class="chat-message">
    <div class="chat-user">
      <a>{{ message.username }}</a>
      <span class="chat-time">{{ message.created_at }}</span>
    </div>
    <p class="chat-content">{{ message.content }}</p>
  </div>
</template>

<script>
export default {
  data() {
    return {};
  },
  props: ["message"]
};
</script>
