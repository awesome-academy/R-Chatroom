json.status :success
json.data do
  json.page do
    json.current_page @pagy.page
    json.per_page @pagy.vars[:items]
    json.total_entries @pagy.count
  end
  json.users do
    json.array! @users, partial: "users/user", as: :user
  end
end
