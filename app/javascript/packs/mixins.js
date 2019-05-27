import { mapState } from 'vuex'

var globalMixin = {
  computed: {
    ...mapState([
      "storedAuthToken",
      "storedUsername"
    ]),
    axiosOptionObject() {
      return {
        headers: {
          "X-User-Name": this.storedUsername,
          "X-User-Token": this.storedAuthToken
        }
      }
    }
  }
}

export default globalMixin;
