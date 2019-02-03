class CommentsController < ApplicationController
  before_action :set_activity, only: [:index, :create, :show, :update, :destroy]
  before_action :set_comment, only: [:show, :update, :destroy]
  before_action :authenticate_user!

  # GET /activities/:id/comments
  def index
    @comments = @activity.root_comments

    render json: ActivitySerializer.new(@activity).serialized_json
  end

  # GET /comments/1
  def show
    render json: CommentSerializer.new(@comment).serialized_json
  end

  # POST /activities/:id/comments
  def create
    @comment = Comment.build_from(@activity, current_user.id, params[:comments][:body])
    
    if @activity.append_comment(@comment)
      render json: ActivitySerializer.new(@activity).serialized_json, status: :created, location: @activity
    else
      render json: @comment.errors, status: :unprocessable_entity
    end

  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      render json: ActivitySerializer.new(@activity).serialized_json
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
      @activity = Activity.where("id = ? AND status != ?",params[:activity_id], "archived").first
      if @activity.nil?
        head(:not_found)
      end
    end

    def set_comment
      @comment = @activity.root_comments.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def comment_params
      params.require(:comments).permit(:activity_id, :body)
    end
end
