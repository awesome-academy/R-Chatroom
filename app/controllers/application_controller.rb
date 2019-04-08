class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  private
  def find_authenticated_user
    authenticate_with_http_basic do |header_username, header_password|
      logining_user = User.find_by user_name: header_username
      if logining_user&.valid_token? header_password
        @current_user = logining_user
      end
    end
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
