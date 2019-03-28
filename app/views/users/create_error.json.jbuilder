json.status :failed
json.data do
   json.array! @user.errors
end
