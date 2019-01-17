class CommentsController < ApplicationController
  before_action :set_activity, only: [:index, :create]
  before_action :set_comment, only: [:show, :update, :delete]
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
	@comment = Comment.build_from( @activity, current_user.id, params[:body] )
    
    if @comment.save
      render json: ActivitySerializer.new(@activity).serialized_json, status: :created, location: @activity
    else
      render json: @activity.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      render json: CommentSerializer.new(@comment).serialized_json
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity
      @activity = Activity.find(params[:activity_id])
    end

    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def comment_params
      params.require(:comments).permit(:activity_id, :body)
    end
end

