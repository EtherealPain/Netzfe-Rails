class SearchController < ApplicationController
  before_action :authenticate_user!
  
  def search_user
    @objects = User.search_by_full_name(params[:query])
    @users = []
    if @objects.first.nil?
      head(:not_found)
    else
      @objects.each do |c|
        if !c.archived
          @users << c
        end
      end
      if !@users.first.nil?
        render json: @users, serializer: UserFullSerializer
      else
        head(:not_found)
      end
    end
  end

  def search_category
    @category = Category.where('lower(description) = ? AND status = ?', params[:query].downcase, 1).first
    if @category.nil?
      head(:not_found)
    else
      @activities = Activity.where('category_id = ? AND status != ?', @category.id, 'archived')
      if @activities.first.nil?
        head(:not_found) 
      else
        render json: @activities, status: :ok
      end
    end
  end

end
