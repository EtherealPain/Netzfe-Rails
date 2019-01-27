class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy, :archive, :follow, :block, :unfollow, :unblock]
  before_action :authenticate_user!
  before_action :is_me, only: [:edit, :destroy]
  before_action :is_archived, only: :show
  # GET /users
  def index
    @users = User.where(archived: false)

    render json: @users
  end

  # GET /users/1
  def show
    render json: UserSerializer.new(@user).serialized_json
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
      if @user.update(user_params)
        render json: UserSerializer.new(@user).serialized_json
      else
        render json: @user.errors, status: :unprocessable_entity
      end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  #POST /users/1/archive
  def archive
    if current_user.is_admin?
      @user.archive_user
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def is_me
      if current_user.id != @user.id
        head(:forbidden)
      end
    end

    def is_archived
      if @user.archived 
        head(:not_found)
      end
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :date_of_birth, :degree, :avatar, :phone)
    end
end
