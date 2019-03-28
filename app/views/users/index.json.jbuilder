json.status :success
json.data do
  json.users do
    json.array! @users, partial: "users/user", as: :user
  end
end
