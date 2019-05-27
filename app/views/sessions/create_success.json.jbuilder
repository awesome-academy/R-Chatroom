json.status :success
json.data do
  json.token @user.authentication_token
  json.user do
    json.partial! "users/user", user: @user
  end
end
