class UsersController < ApplicationController
  acts_as_token_authentication_handler_for User
  before_action :find_authenticated_user, only: [:show, :destroy]
  before_action :set_user, only: [:show, :destroy]
  before_action :set_room, only: [:destroy]
  before_action :check_room_authorization, only: [:destroy]

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

  def destroy
    if @room.kick @user
      render :success, status: :accepted
    else
      render :error, status: :unprocessable_entity
    end
  end

  def show
  end

  private
  def set_user
    @user = User.find_by id: params[:id]
    render :show_error, status: :unprocessable_entity unless @user
  end

  def set_room
    @room = Room.find_by id: params[:room_id]
    render :show_error, status: :unprocessable_entity unless @room
  end

  def user_params
    params.require(:user).permit :user_name, :show_name, :password,
      :password_confirmation, :email
  end
end
