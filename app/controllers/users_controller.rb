class UsersController < ApplicationController
  acts_as_token_authentication_handler_for User
  before_action :find_authenticated_user, only: [:show, :destroy]
  before_action :set_user, only: [:show, :destroy]
  before_action :set_room, only: [:destroy]
  before_action :check_room_authorization, only: [:destroy]

  def index
    if params[:room_id]
      @room = Room.find_by id: params[:room_id]
      if @room
        if params[:search_string].present?
          @users = @room.users.find_by_name(params[:search_string])
            .paginate page: params[:page], per_page: Settings.rooms_per_page
        else
          @users = @room.users.order_by_name.paginate page: params[:page]
        end
      else
        render :error, status: :unprocessable_entity
      end
    else
      if params[:search_string].present?
        @users = User.find_by_name params[:search_string]
          .paginate page: params[:page], per_page: Settings.rooms_per_page
      else
        @users = User.order_by_name.paginate page: params[:page]
      end
    end
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
