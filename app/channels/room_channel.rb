class RoomChannel < ApplicationCable::Channel
  def subscribed
    if params[:id].present?
      # creates a private chat room with a unique name
      stream_from "Room-#{(params[:id])}"
    end
  end

  def unsubscribed
    stop_all_streams
  end

  def send_message(data)
    @chatroom = Room.find(data["room_id"])
    message   = @room.messages.create(body: data["body"], user: current_user)
    MessageRelayJob.perform_later(message)
  end

end
