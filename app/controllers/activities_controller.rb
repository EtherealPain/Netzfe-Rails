class ActivitiesController < ApplicationController
  before_action :set_activity, only: [:show, :update, :destroy, :like, :unlike, :share]
  before_action :authenticate_user!


  # GET /activities
  def index
    @activities = Activity.all

    render json: @activities
  end

  # GET /activities/1
  def show
    render json: ActivitySerializer.new(@activity).serialized_json
  end

  # POST /activities
  def create
    @activity = current_user.activities.new(activity_params)
    #this line automatically makes the current logged in user as the owner (creator) of an activity
    #it's probably not necessary to add the owner of the activity on the body
    #it also helps prevent forgery, you can't upload an activity using somebody's else's identity
    
    if @activity.save
      #create room for this activity
      @room = Room.new(name: @activity.description, activity: @activity)
      @room.users << @activity.user
      @room.save
      render json: ActivitySerializer.new(@activity).serialized_json, status: :created, location: @activity
    else
      render json: @activity.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /activities/1
  def update
    if @activity.update(activity_params)
      render json: ActivitySerializer.new(@activity).serialized_json
    else
      render json: @activity.errors, status: :unprocessable_entity
    end
  end

  # POST /activities/:id/share
  #This is for share the activity, we need to clone or duplicate the activity but we need change user_id 
  def share
    @activity_clone = Activity.new 
    @activity_clone = @activity.dup
    @activity_clone.user_id = current_user.id
    @activity_clone.shared = true 
    @activity_clone.activity_id = @activity.id

    if @activity_clone.save
      render json: ActivitySerializer.new(@activity_clone).serialized_json, status: :created, location: @activity_clone
    else
      render json: @activity_clone.errors, status: :unprocessable_entity
    end
  end



  #POST /activities/1/like
  def like
    @activity.liked_by(current_user)
    # puts(current_user.uid) used for testing purposes, it's not needed anymore, but will be kept in case another test must be done
    render json: ActivitySerializer.new(@activity).serialized_json
  end
  #POST /activities/1/unlike
  def unlike
    @activity.unliked_by(current_user)
    render json: @activity
  end
  # DELETE /activities/1
  def destroy
    @activity.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity
      @activity = Activity.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def activity_params
      params.require(:activity).permit(:deadline, :description, :user_id, :category_id, :image)
    end
end
