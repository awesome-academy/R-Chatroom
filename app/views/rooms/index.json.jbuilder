json.status :success
json.data do
  json.pagy @pagy
  json.page do
    json.current_page @pagy.page
    json.per_page @pagy.vars[:items]
    json.total_entries @pagy.count
  end
  json.rooms do
    json.array! @rooms, partial: 'rooms/room', as: :room
  end
end
