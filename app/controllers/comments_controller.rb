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

    if @activity.append_comment(@comment)
      render json: ActivitySerializer.new(@activity).serialized_json, status: :created, location: @activity
    else
      render json: @activity.errors, status: :unprocessable_entity
    end

  end

  # PATCH/PUT /comments/1
  def update
  	if @activity.can_comment?
  		if @comment.update(comment_params)
	      render json: CommentSerializer.new(@comment).serialized_json
	    else
	      render json: @comment.errors, status: :unprocessable_entity
	   	end
  	else
  		@activity.errors.add(:base, "Could not update comment because the activity has been archived")
  		render json: @activity.errors, status: :unprocessable_entity
  	end
    
  end

  # DELETE /comments/1
  def destroy
  	if @activity.can_comment?
    	@comment.destroy
    else
  		@activity.errors.add(:base, "Could not delete comment because the activity has been archived")
  		render json: @activity.errors, status: :unprocessable_entity
  	end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity
      @activity = Activity.where("id = ? AND status != ?",params[:activity_id], "archived").first
    end

    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def comment_params
      params.require(:comments).permit(:activity_id, :body)
    end
end
