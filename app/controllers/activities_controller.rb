class ActivitiesController < ApplicationController
  prepend_before_action :set_activity_original, only: [:update, :like, :unlike, :voteup, :votedown, :join, :share, :archive, :complete]
  prepend_before_action :set_activity_shared, only: [:show,:destroy]
  prepend_before_action :authenticate_user!

  #prepend is used so the before_action is added  before the beginning of the chain 
  before_action :check_status, except: [:create, :index]
  before_action :vote_prelim, only: [:voteup, :votedown]
  before_action :is_mine, only: [:update, :destroy, :complete, :archive]
  before_action :private_chat_prelim, only: [:join, :leave]

  # GET /activities
  def index
    
    @activities = Activity.where('status' => ['open','finished'],
                                  'user_id' => current_user.following_by_type('User')
                                ).or(Activity.where(user_id: current_user, status: ['open','finished'])).order(created_at: :desc).page( params[:page])

    render json: @activities
  end

  # GET /activities/1
  def show
    render json: @activity, serializer: ActivityWithCommentsSerializer
  end

  # POST /activities
  def create
    @activity = current_user.activities.new(activity_params)
    #thiline automatically makes the current logged in user as the owner (creator) of an activity
    #it's probably not necessary to add the owner of the activity on the body
    #it also helps prevent forgery, you can't upload an activity using somebody's else's identity
    
    if @activity.save
      #create room for this activity
      @room = Room.new(name: @activity.description, activity: @activity)
      @room.users << @activity.user
      @room.save
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

  # POST /activities/:id/share
  #This is for share the activity, we need to clone or duplicate the activity but we need change user_id 
  def share
    
    @activity_clone = Activity.new
    @activity_clone = @activity.dup
    @activity_clone.activity_id = @activity.id
    @activity_clone.user_id = current_user.id
    @activity_clone.shared = true 
    

    if @activity_clone.save
      @activity.notifications(current_user,'share')
      render json: @activity_clone, status: :created, location: @activity_clone
    else
      render json: @activity_clone.errors, status: :unprocessable_entity
    end
  end

  #POST /activities/1/like
  def like

    if @activity.like_post(current_user)
      @activity.notifications(current_user,'like') #unless @activity.voted_on_by? current_user
      render json: @activity, status: :ok
    else
      render json: @activity.errors, status: :unprocessable_entity
    end
  
  end

  #POST /activities/1/unlike
  def unlike

    if @activity.unlike_post(current_user)
      render json: @activity
    else
      render json: @activity.errors, status: :unprocessable_entity
    end
  end

  def voteup
    if @activity.errors.empty?
      @votable_user.liked_by @activity, :vote_weight => params['vote_weight'].to_i

      if @votable_user.save
        render json: @votable_user
      else
        render json: @votable_user.errors, status: :unprocessable_entity
      end

    else
      render json: @activity.errors, status: :unprocessable_entity
    end
  end

  def votedown
    head :not_found
    #THIS METHOD HAS BEEN DISABLED


    if @activity.errors.empty?
      @votable_user.downvote_from @activity, :vote_weight => params['vote_weight'].to_i
      render json: @votable_user.serialized_json
    else
      render json: @activity.errors, status: :unprocessable_entity
    end
  end

  def join
    if @activity.add_participant current_user
      @activity.notifications(current_user,'join')
      render json: @activity
    else
      render json: @activity.errors, status: :unprocessable_entity
    end
  end

  def leave
    if @activity.remove_participant current_user
      render json: ActivitySerializer.new(@activity).serialized_json
    else
      render json: @activity.errors, status: :unprocessable_entity
    end
  end

  def complete
    @activity.complete
    if @activity.save
      @activity.notifications(current_user,'finish')
      render json: ActivitySerializer.new(@activity).serialized_json, status: :ok
    else
      render json: @activity.errors, status: :unprocessable_entity
    end
    
  end

  def archive
    if current_user.is_admin?
      @activity.archive
      if @activity.save
        @activity.notifications(current_user,'archive')
        head(:ok)
      else
        render json: @activity.errors, status: :unprocessable_entity
      end
    else
      head(:forbidden)
    end
  end

  # DELETE /activities/1
  def destroy
    if @activity.destroy
      head(:ok)
    else
      render json: @activity.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity_original
      @activity = Activity.where("id = ? AND status != ?", params[:id], "archived").first
      if @activity.nil?
        head(:not_found)
      elsif @activity.shared?
        @activity = @activity.original
      end
    end

    def set_activity_shared
      @activity = Activity.where("id = ? AND status != ?", params[:id], "archived").first
      if @activity.nil?
        head(:not_found)
      end
    end

    # Only allow a trusted parameter "white list" through.
    def activity_params
      params.permit(:deadline, :description, :category_id, :title, :page, :avatar)
    end

    def check_status
      @activity.check_status
    end

    def is_mine
      if not current_user == @activity.creator
        head(:forbidden)
      end
    end

    def private_chat_prelim
      #TODO
    end

    def vote_prelim

      @votable_user=User.find_by(id: params[:votable_user_id])
      if @votable_user.nil?
        @activity.errors.add(:base, "User not found")
      else #if it's not nil
        if @votable_user.following? @activity #is he part of the follower list?
          
          unless current_user == @activity.creator #is the current issuer the creator?
            @activity.errors.add(:base, "Cannot vote on users if you are not the creator")
          end
        else  #he is not a participant
          @activity.errors.add(:base, "Cannot vote on users who did not participate on the activity")
          #if you are not the creator you should NOT be voting on users
          #the user is not part of the selection
        end
      end
      
      #verify the vote weight
      a=params['vote_weight'].to_i
      if a<=0 or a>5
        @activity.errors.add(:base, "Vote weight should be a number between 1 and 5")
      end
      #verify if voting is available
      unless @activity.can_vote?
        @activity.errors.add(:base, "The activity has not ended, you cannot vote on users yet.")
      end   
    end
    #at the end of all this, he:
    #exists, belongs to the followers, and the current issuer is the creator of the activity
end
