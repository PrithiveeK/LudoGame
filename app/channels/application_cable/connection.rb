module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      # current_user.online
      logger.info "User: #{self.current_user.id}"
    end

    private

    def find_verified_user
      token = request.params[:token]
      decoder = Warden::JWTAuth::UserDecoder.new
      begin
        decoder.call(token, :user, nil)
      rescue => exception
        reject_unauthorized_connection
      end
    end

    def disconnect
      # current_user.offline
    end

  end
end
