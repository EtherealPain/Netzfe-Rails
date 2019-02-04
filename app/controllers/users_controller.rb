class UsersController < ApplicationController
  before_action :set_user, only: [:activities,:show, :archive, :follow, :block, :unfollow, :unblock, :activity, :following, :followers]
  before_action :authenticate_user!

  # GET /users/1
  def show
    render json: @user, serializer: UserFullSerializer
  end

  #PATCH /users/:id/archive
  def archive
    if current_user.is_admin?
      @user.archive_user
      if @user.save
        head(:ok)
      else
        head(:unprocessable_entity)
      end
    else
      head(:forbidden)
    end
  end

  #POST /users/:id/follow
  def follow
    current_user.follow(@user)
    Notification.create(notify_type: 'follow', actor: current_user, user: @user)
    render json: @user
  end

  #POST /users/:id/unfollow
  def unfollow
    current_user.stop_following(@user)
    render json: @user
  end

  #POST /users/:id/block
  def block
    current_user.block(@user)
    render json: @user
  end

  #POST /users/:id/unblock
  def unblock
    current_user.unblock(@user)
    render json: @user
  end

  #GET users/:id/followers
  def followers
   @followers = @user.followers_by_type("User")
   render json: @followers
  end

  #GET users/:id/following
  def following
   @following = @user.following_by_type("User")
   render json: @following
  end

  #GET users/:id/activities
  def activities
    @activities = Activity.where(user_id: @user, status: ['open','finished','expired']).page( params[:page])
    render json: @activities
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.where(id: params[:id], archived: false).first
      if @user.nil?
        head(:not_found)
      end
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.permit(:first_name, :last_name, :date_of_birth, :degree, :avatar, :phone, :page)
    end
end
