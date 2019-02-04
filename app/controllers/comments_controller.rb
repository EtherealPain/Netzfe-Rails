class CommentsController < ApplicationController
  before_action :set_activity, only: [:index, :create, :update, :destroy]
  #I decided to call this before action on update and destroy, 
  #just to check the status of the activity, in case it is disabled the 
  #comments should not be allowed to be edited or deleted
  
  prepend_before_action :set_comment, only: [:show, :update, :destroy]
  before_action :authenticate_user!
  before_action :is_mine, only: [:destroy, :update]

  # GET /activities/:id/comments
  def index
    @comments = @activity.root_comments

    render json: @comments
  end

  # GET /comments/1
  def show
    render json: @comment
  end

  # POST /activities/:id/comments
  def create
    @comment = Comment.build_from(@activity, current_user.id, params[:body])
    
    if @activity.append_comment(@comment)
      render json: @activity.root_comments
    else
      render json: @comment.errors, status: :unprocessable_entity
    end

  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  def destroy
    if @comment.destroy
      head(:ok)
    else
      head(:unprocessable_entity)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity
      if params[:id].nil?
        @activity = Activity.where("id = ? AND status != ?",params[:activity_id], "archived").first
      else 
        @activity = Activity.where("id = ? AND status != ?", @comment.commentable_id, "archived").first
      end

      if @activity.nil?
        head(:not_found)
      end
    end

    def set_comment
      @comment = Comment.find(params[:id])
      if @comment.nil?
        head(:not_found)
      end
    end

    def is_mine
      if not current_user == @comment.user
        head(:forbidden)
      end
    end

    # Only allow a trusted parameter "white list" through.
    def comment_params
      params.permit(:id, :activity_id, :body)
    end
end
