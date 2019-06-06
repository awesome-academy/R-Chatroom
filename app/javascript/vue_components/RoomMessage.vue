<template>
  <div class="chat-message">
    <div class="showname"><a>{{ message.show_name }}</a></div>
    <div class="username">@{{ message.username }}</div>
    <div class="chat-time">{{ createdAt }}</div>
    <p class="chat-content content" v-html="messageContent"></p>
    <div v-if="message.attachment_filename" class="attachment">
      <div>
        {{ $t("attachment") }}:
        <a class="tag is-info is-small" :href="message.attachment_url" target="_blank">
          {{ message.attachment_filename }}
        </a>
      </div>
      <div>
        {{ $t("size") }}: {{ message.attachment_byte_size }} {{ $t("bytes") }}
      </div>
      <div class="attachment_preview" v-if="message.attachment_thumb">
        <img :src="message.attachment_thumb" :alt="message.attachment_filename" />
      </div>
    </div>
  </div>
</template>

<script>
import paragraphs from "lines-to-paragraphs";
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
    },
    messageContent() {
      if (this.message.content) {
        return paragraphs(this.message.content);
      } else {
        return null;
      }
    }
  }
};
</script>
