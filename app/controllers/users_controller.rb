class UsersController < ApplicationController
  acts_as_token_authentication_handler_for User, fallback: :none
  load_and_authorize_resource only: [:index, :show]
  load_and_authorize_resource :room, only: [:kick]
  load_and_authorize_resource :user, through: :room, only: [:kick]

  def index
    if params[:room_id]
      @room = Room.find_by id: params[:room_id]
      render status: :unprocessable_entity unless @room
      q = @room.users.ransack params[:q]
    else
      q = User.ransack params[:q]
    end
    render status: :unprocessable_entity unless q
    @pagy, @users = pagy q.result(distinct: true), items: Settings.rooms_per_page
  end

  def kick
    if @room.kick @user
      render :success, status: :accepted
    else
      render :error, status: :unprocessable_entity
    end
  end

  def show
  end

  private
  def user_params
    params.require(:user).permit :user_name, :show_name, :password,
      :password_confirmation, :email
  end
end
