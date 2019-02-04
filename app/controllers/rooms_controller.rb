class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :update, :destroy, :join, :my_room, :leave]
  before_action :authenticate_user!
  before_action :my_room, only: [:update, :destroy]

  # GET /rooms
  def index
    @rooms = Room.all

    render json: @rooms
  end

  # GET /rooms/1
  def show
    render json: @room
  end

  #Join another user to the room
  def join
    @room.users << current_user
    render json: @room, status: :ok
  end

  #For users leave the room
  def leave
    if @room.users.include?(current_user)
      @room.users.delete(current_user)
      head(:ok)
    else
      head(:unprocessable_entity)
    end
  end


  # POST /rooms
  #create action is call from activity controller
  # def create
  #   @room = Room.new(room_params)
  #   @room.users << current_user
  #   if @room.save
  #     render json: @room, status: :created, location: @room
  #   else
  #     render json: @room.errors, status: :unprocessable_entity
  #   end
  # end

  # PATCH/PUT /rooms/1
  def update
    if @room.update(room_params)
      render json: @room
    else
      render json: @room.errors, status: :unprocessable_entity
    end
  end

  # DELETE /rooms/1
  def destroy
    if @room.destroy
      head(:ok)
    else
      head(:unprocessable_entity)
    end
  end

  private
    #this is to validate that only owner can destroy and edit room
    def my_room 
      if current_user != @room.activity.user
        head(:unauthorized)
      end
    end


    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def room_params
      params.require(:room).permit(:name)
    end
end
