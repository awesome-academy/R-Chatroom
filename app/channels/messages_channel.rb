class MessagesChannel < ApplicationCable::Channel
  def subscribed
    @room = Room.find_by id: params["room_id"]
    if @room
      if @room.has_joined? current_user
        stream_from "user_#{current_user.id}"
        stream_from "chat_room_#{@room.id}"
      else
        reject_subscription
      end
    else
      reject_subscription
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive_latest data
    messages = Message.find_by_room(@room.id).last data["total_messages"]
    formatted_messages = format_messages messages
    ActionCable.server.broadcast "user_#{current_user.id}", {
      type: "receive_latest",
      behind: messages.first ? messages.first.total_messages_behind : 0,
      messages: formatted_messages
    }
  end

  def receive_from_id data
    messages = Message.find_by_room(@room.id)
      .find_less_than_id(data["less_than_id"])
      .last data["total_messages"]
    formatted_messages = format_messages messages
    ActionCable.server.broadcast "user_#{current_user.id}", {
      type: "receive_from_id",
      behind: messages.first ? messages.first.total_messages_behind : 0,
      messages: formatted_messages
    }
  end

  def receive_after_id data
    messages = Message.find_by_room(@room.id)
      .find_more_than_id(data["more_than_id"])
    formatted_messages = format_messages messages
    ActionCable.server.broadcast "user_#{current_user.id}", {
      type: "receive_from_id",
      messages: formatted_messages
    }
  end

  def receive_from_range data
    messages = Message.find_by_room(@room.id).find_by_range_id(data["less_than_id"], data["more_than_id"])
    formatted_messages = format_messages messages
    ActionCable.server.broadcast "user_#{current_user.id}", {
      type: "receive_from_range",
      messages: formatted_messages
    }
  end

  def receive data
    message = Message.new user_id: current_user.id, room_id: params["room_id"], content: data["content"]
    if message.save
      ActionCable.server.broadcast "chat_room_#{params[:room_id]}", {
        type: "receive",
        messages: [format_message(message)]
      }
    else
      ActionCable.server.broadcast "user_#{current_user.id}", {
        type: "error",
        message: I18n.t("something_wrong")
      }
    end
  end

  private
  def format_message message
    formatted_message = {
      id: message.id,
      user_id: message.user_id,
      room_id: message.room_id,
      show_name: message.user.show_name,
      username: message.user.user_name,
      content: message.content,
      created_at: message.created_at,
      updated_at: message.updated_at
    }
  end

  def format_messages messages
    formatted_messages = messages.map do |message|
      format_message message
    end
  end
end
