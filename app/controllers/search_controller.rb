class SearchController < ApplicationController
  before_action :authenticate_user!
  
  def search
    @category = Category.where('lower(description) = ?', params[:query].downcase).first
    if @category.nil?
      @objects = User.search_by_full_name(params[:query])
      render json: @objects, status: :ok
    else
      @activities = Activity.where('category_id = ?', @category.id)
      render json: @activities, status: :ok
    end 
  end
end
