module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user, :room

    def connect
      self.current_user = find_verified_user
      self.room = find_room
    end

    private
    def find_verified_user
      logining_user = User.find_by id: request.params[:id]
      reject_unauthorized_connection unless logining_user&.valid_token? request.params[:token]
      logining_user
    end

    def find_room
      room = Room.find_by id: request.params[:room_id]
      reject_unauthorized_connection unless room&.has_joined? current_user
      room
    end
  end
end
