json.status :success
json.message t(".left_successfully")
json.data do
  json.room do
    json.partial! "rooms/room", room: @room
  end
end
