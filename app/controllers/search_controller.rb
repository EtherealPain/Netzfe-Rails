class SearchController < ApplicationController
  before_action :authenticate_user!
  
  def search
    @category = Category.where('lower(description) = ?', params[:query].downcase).first
    if @category.nil?
      @objects = User.search_by_full_name(params[:query])
        if !@objects.archived
          render json: @objects, status: :ok
        else
          head(:not_found)
        end
    else
      @activities = Activity.where('category_id = ? AND status != ?', @category.id, 'archived').first
      if @activities.nil?
        head(:not_found) 
      else
        render json: @activities, status: :ok
      end
    end 
  end
end
