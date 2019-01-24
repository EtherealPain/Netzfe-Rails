class MessagesController < ApplicationController
  before_action :set_room, only: [:create]
  before_action :authenticate_user!

  # GET /messages
  def index
    @messages = Message.all

    render json: @messages
  end

  # GET /messages/1
  def show
    render json: @message
  end

  # POST /messages
  def create
    @message = @room.messages.new(message_params)
    @message.user = current_user

    if @message.save
      MessageRelayJob.perform_later(message)
    else
      header(:unprocessable_entity)
    end
  end

  # PATCH/PUT /messages/1
  def update
    if @message.update(message_params)
      render json: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # DELETE /messages/1
  def destroy
    @message.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id]) 
    end

    # Only allow a trusted parameter "white list" through.
    def message_params
      params.require(:message).permit(:body)
    end
end
