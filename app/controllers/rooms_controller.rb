class RoomsController < ApplicationController
  before_action :find_authenticated_user, only: [:index, :join, :leave, :show, :create]
  before_action :set_room, only: [:show, :join, :leave]
  before_action :check_authenticated, only: [:index, :join, :leave, :show, :create]

  def index
    if params[:user_id]
      user = User.find_by id: params[:user_id]
      if user
        if params[:search_string].present?
          @rooms = user.rooms.find_by_name(params[:search_string]).paginate page: params[:page], per_page: Settings.rooms_per_page
        else
          @rooms = user.rooms.order_by_name.paginate page: params[:page]
        end
      else
        render status: :unprocessable_entity
      end
    else
      if params[:search_string].present?
        @rooms = Room.find_by_name(params[:search_string]).paginate page: params[:page], per_page: Settings.rooms_per_page
      else
        @rooms = Room.order_by_name.paginate page: params[:page], per_page: Settings.rooms_per_page
      end
    end
  end

  def join
    if @current_user.join_room @room
      render :join, status: :created, location: @room
    else
      @error_message = I18n.t "rooms.join_error.already_joined"
      render :join_error, status: :unprocessable_entity
    end
  end

  def leave
    if @current_user.leave_room @room
      render :leave, status: :created, location: @room
    else
      @error_message = I18n.t "rooms.leave_error.not_joined"
      render :leave_error, status: :unprocessable_entity
    end
  end

  def show
  end

  def create
    @room = Room.new room_params
    @room.user_created_id = @current_user.id
    if @room.save
      render :show, status: :created, location: @room
    else
      render :create_error, status: :unprocessable_entity
    end
  end

  private
  def set_room
    @room = Room.find_by id: params[:id]
    render :show_error, status: :unprocessable_entity unless @room
  end

  def room_params
    params.require(:room).permit :room_name, :show_name, :description
  end
end
