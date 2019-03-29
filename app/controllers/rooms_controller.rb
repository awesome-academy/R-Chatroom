class RoomsController < ApplicationController
  before_action :find_authenticated_user, only: [:index, :join, :show, :create]
  before_action :set_room, only: [:show, :join]
  before_action :check_authenticated, only: [:index, :join, :show, :create]

  def index
    if params[:user_id]
      user = User.find_by id: params[:user_id]
      @rooms = user.rooms.order_by_name.paginate(page: params[:page]) if user
    else
      @rooms = Room.order_by_name.paginate page: params[:page]
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
      if !@room
        render :show_error, status: :unprocessable_entity
      end
    end

    def room_params
      params.require(:room).permit :room_name, :show_name, :description
    end
end
