SimpleTokenAuthentication.configure do |config|
  config.header_names = {
    user: {
      authentication_token: "X-User-Token",
      user_name: "X-User-Name"
    }
  }
  config.identifiers = {user: "user_name"}
end
