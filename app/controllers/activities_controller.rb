class ActivitiesController < ApplicationController
  before_action :set_activity, only: [:show, :update, :destroy]

  # GET /activities
  def index
    @activities = Activity.all

    render json: @activities
  end

  # GET /activities/1
  def show
    render json: @activity
  end

  # POST /activities
  def create
    @activity = Activity.new(activity_params)

    @activity.user = current_user
    #this line automatically makes the current logged in user as the owner (creator) of an activity
    #it's probably not necessary to add the owner of the activity on the body
    #it also helps prevent forgery, you can't upload an activity using somebody's else's identity
    
    if @activity.save
      render json: @activity, status: :created, location: @activity
    else
      render json: @activity.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /activities/1
  def update
    if @activity.update(activity_params)
      render json: @activity
    else
      render json: @activity.errors, status: :unprocessable_entity
    end
  end



  #POST /activity/:id/like
  def like
    @activity.liked_by(current_user)
  end
  #POST /activity/:id/unlike
  def unlike
    @activity.unliked_by(current_user)
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
      params.require(:activity).permit(:deadline, :description, :user_id, :category_id)
    end
end
