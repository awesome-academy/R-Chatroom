class ApplicationController < ActionController::API
  include Pagy::Backend

  private
  def find_authenticated_user
    @current_user ||= current_user
  end

  def check_authenticated
    render :unauthenticated, status: :forbidden unless @current_user
  end

  def check_authorization
    unless @current_user && @user == @current_user
      render :unauthorized, status: :unauthorized
    end
  end

  def check_room_authorization
    render :unauthorized, status: :unauthorized unless @room.admins.include? @current_user
  end
end
