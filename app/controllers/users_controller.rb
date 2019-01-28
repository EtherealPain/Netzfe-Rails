class UsersController < ApplicationController
  before_action :set_user, only: [:show, :archive, :follow, :block, :unfollow, :unblock, :activity]
  before_action :authenticate_user!

  # GET /users/1
  def show
    render json: UserSerializer.new(@user).serialized_json
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
    render json: UserSerializer.new(@user).serialized_json
  end

  #POST /users/:id/unfollow
  def unfollow
    current_user.stop_following(@user)
    render json: UserSerializer.new(@user).serialized_json
  end

  #POST /users/:id/block
  def block
    current_user.block(@user)
    render json: UserSerializer.new(@user).serialized_json
  end

  #POST /users/:id/unblock
  def unblock
    current_user.unblock(@user)
    render json: UserSerializer.new(@user).serialized_json
  end

  #GET users/:id/followers
  def followers
   head :not_found
  end

  #GET users/:id/following
  def following
    head :not_found
  end

  #GET users/:id/activity
  def activity
    @activities = @user.activities.where.not(status: 'archived').first
    if @activities.nil?
      head(:no_content)
    else
      render json: ActivitySerializer.new(@activities).serialized_json
    end
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
      params.require(:user).permit(:first_name, :last_name, :date_of_birth, :degree, :avatar, :phone)
    end
end
