class MessagesController < ApplicationController
  acts_as_token_authentication_handler_for User, fallback: :none
  load_and_authorize_resource :room
  load_and_authorize_resource :message, through: :room

  def create
    @message = Message.new message_params.merge(user_id: current_user.id,
      room_id: params[:room_id])
    if @message.save
      ActionCable.server.broadcast "chat_room_#{params[:room_id]}", {
        type: "receive",
        messages: [Message.format_message(@message)]
      }
      render :success, status: :created
    else
      render :error, status: :unprocessable_entity
    end
  end

  private
  def message_params
    params.require(:message).permit :content, :attachment
  end
end
