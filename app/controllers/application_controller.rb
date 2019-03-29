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
      unless @current_user
        render :unauthenticated, status: :forbidden
      end
    end

    def check_authorization
      unless @current_user && @user == @current_user
        render :unauthorized, status: :unauthorized
      end
    end
end
