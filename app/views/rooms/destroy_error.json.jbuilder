json.status :failed
json.data do
   json.array! @room.errors
end
