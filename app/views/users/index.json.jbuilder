json.status :success
json.data do
  json.page do
    json.current_page @users.current_page
    json.per_page @users.per_page
    json.total_entries @users.total_entries
  end
  json.users do
    json.array! @users, partial: "users/user", as: :user
  end
end
