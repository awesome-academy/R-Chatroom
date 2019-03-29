module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private
    def find_verified_user
      logining_user = User.find_by id: request.params[:id]
      reject_unauthorized_connection unless logining_user&.valid_token? request.params[:token]
      logining_user
    end
  end
end
