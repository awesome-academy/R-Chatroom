json.extract! user, :id, :user_name, :show_name, :email, :created_at, :updated_at
json.url user_url user, format: :json
json.is_admin @room.is_admin? user if @room
