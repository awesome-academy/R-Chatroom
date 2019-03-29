json.status :success
json.data do
  json.page do
    json.current_page @rooms.current_page
    json.per_page @rooms.per_page
    json.total_entries @rooms.total_entries
  end
  json.rooms do
    json.array! @rooms, partial: 'rooms/room', as: :room
  end
end
