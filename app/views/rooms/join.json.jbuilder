json.status :success
json.message t(".joined_successfully")
json.data do
  json.room do
    json.partial! "rooms/room", room: @room
  end
end
