class MessagesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "user_#{current_user.id}"
    stream_from "chat_room_#{room.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive_latest data
    messages = Message.find_by_room(room.id).last data["total_messages"]
    formatted_messages = Message.format_messages messages
    ActionCable.server.broadcast "user_#{current_user.id}", {
      type: "receive_latest",
      behind: messages.first ? messages.first.total_messages_behind : 0,
      messages: formatted_messages
    }
  end

  def receive_from_id data
    messages = Message.find_by_room(room.id)
      .find_less_than_id(data["less_than_id"])
      .last data["total_messages"]
    formatted_messages = Message.format_messages messages
    ActionCable.server.broadcast "user_#{current_user.id}", {
      type: "receive_from_id",
      behind: messages.first ? messages.first.total_messages_behind : 0,
      messages: formatted_messages
    }
  end

  def receive_after_id data
    messages = Message.find_by_room(room.id)
      .find_more_than_id(data["more_than_id"])
    formatted_messages = Message.format_messages messages
    ActionCable.server.broadcast "user_#{current_user.id}", {
      type: "receive_from_id",
      messages: formatted_messages
    }
  end

  def receive_from_range data
    messages = Message.find_by_room(room.id)
      .find_by_range_id(data["less_than_id"], data["more_than_id"])
    formatted_messages = Message.format_messages messages
    ActionCable.server.broadcast "user_#{current_user.id}", {
      type: "receive_from_range",
      messages: formatted_messages
    }
  end
end
