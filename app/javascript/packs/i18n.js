import Vue from "vue";
import VueI18n from "vue-i18n";
import en from "../vue_locales/en";

Vue.use(VueI18n);

const messages = {
  en: en
}

export default new VueI18n({
  locale: "en",
  messages, // set locale messages
});
