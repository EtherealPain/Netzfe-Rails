class ActivitiesController < ApplicationController
  before_action :set_activity, only: [:show, :update, :destroy, :like, :unlike, :voteup, :votedown, :join]
  before_action :authenticate_user!
  before_action :check_status, except: :create
  before_action :vote_prelim, only: [:voteup, :votedown]


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

  def voteup
    if @activity.errors.empty?
      @votable_user.liked_by @activity, :vote_weight => params['vote_weight'].to_i
      render json: UserSerializer.new(@votable_user).serialized_json
    else
      render json: @activity.errors, status: :unprocessable_entity
    end

  end

  def votedown
    if @activity.errors.empty?
      @votable_user.downvote_from @activity, :vote_weight => params['vote_weight'].to_i
      render json: UserSerializer.new(@votable_user).serialized_json
    else
      render json: @activity.errors, status: :unprocessable_entity
    end
  end


  def join
    if @activity.add_participant current_user
      render json: ActivitySerializer.new(@activity).serialized_json, status: :created, location: @activity
    else
      render json: @activity.errors, status: :unprocessable_entity
    end
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
      params.require(:activity).permit(:deadline, :description, :category_id, :image)
    end

    def check_status
      @activity.check_status
    end

    def vote_prelim
      @votable_user=User.find_by(id: params[:votable_user_id])
      if @votable_user.nil?
        @activity.errors.add(:base, "User not found")
        #TODO implement an actual response on why it returned a 404
      else #if it's not nil
        if @votable_user.following? @activity #is he part of the follower list?
            
          unless current_user == @activity.creator #is the current issuer the creator?
            @activity.errors.add(:base, "Cannot vote on users if you are not the creator") 
        else  #he is not a participant
          @activity.errors.add(:base, "Cannot vote on users who did not participate on the activity")
          #if you are not the creator you should NOT be voting on users
          end
          #the user is not part of the selection
        end
      end
      a=params['vote_weight'].to_i
      if a<=0 or a>5
        @activity.errors.add(:base, "Vote weight should be between 1 and 5")
      end
    end
    #at the end of all this, he:
    #exists, belongs to the followers, and the current 

end
