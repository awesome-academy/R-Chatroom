class MessagesChannel < ApplicationCable::Channel
  def subscribed
    @room = Room.find_by id: params["room_id"]
    if @room
      stream_from "user_#{current_user.id}"
      stream_from "chat_room_#{@room.id}"
      messages = Message.find_by_room @room.id
      formatted_messages = messages.map do |message|
        format_message message
      end
      ActionCable.server.broadcast "user_#{current_user.id}", formatted_messages
    else
      reject_subscription
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive data
    message = Message.create user_id: current_user.id, room_id: params["room_id"], content: data["content"]
    ActionCable.server.broadcast "chat_room_#{params[:room_id]}", [format_message(message)]
  end

  private
  def format_message message
    formatted_message = {
      id: message.id,
      user_id: message.user_id,
      room_id: message.room_id,
      username: message.user.user_name,
      content: message.content,
      created_at: message.created_at,
      updated_at: message.updated_at
    }
  end
end
