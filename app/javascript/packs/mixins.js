import { mapState } from 'vuex'

var globalMixin = {
  computed: {
    ...mapState([
      "storedAuthToken",
      "storedUsername"
    ]),
    loginHeader() {
      return {
        "X-User-Name": this.storedUsername,
        "X-User-Token": this.storedAuthToken
      }
    }
  }
}

export default globalMixin;
