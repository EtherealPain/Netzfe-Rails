module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
    #this is for authenticate user to the websocket connection
    def connect
      self.current_user = find_verified_user
      logger.add_tags "ActionCable", "User #{current_user.id}"
    end
 
    private

      def find_verified_user
        access_token = request.params[:'access-token']
        client_email = request.params[:client]
        verified_user = User.find_by(email: client_email)
        
        if verified_user && verified_user.valid_token?(access_token, client_email)
          verified_user
        else
          reject_unauthorized_connection
        end
      end
  end
end
