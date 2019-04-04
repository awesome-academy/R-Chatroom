json.status :success
json.data do
  json.room do
    json.partial! "rooms/room", room: @room
  end
end
