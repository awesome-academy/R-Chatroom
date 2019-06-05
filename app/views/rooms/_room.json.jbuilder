json.extract! room, :id, :room_name, :show_name, :description, :created_at, :updated_at
json.url room_url(room, format: :json)
json.joined room.has_joined? current_user
json.is_admin room.is_admin? current_user
