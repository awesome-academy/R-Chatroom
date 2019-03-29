json.status :success
json.data do
  json.token @user.auth_token
end
