class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :only_admin, only: [:update, :destroy, :create]
  before_action :set_category, only: [:show, :update, :destroy]
  
  # GET /categories
  def index
    @categories = Category.where(status: 1)

    render json: @categories
  end

  # GET /categories/1
  def show
    render json: @category
  end

  # POST /categories
  def create
    @category = Category.new(category_params)

    if @category.save
      render json: @category, status: :created, location: @category
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /categories/1
  def update
    if @category.update(category_params)
      render json: @category
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  # DELETE /categories/1
  def destroy
    if @category.update(status: 0)
      head(:ok)
    else
      head(:unprocessable_entity)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.where(status: 1, id: params[:id]).first
      if @category.nil?
        head(:not_found)
      end
    end

    def only_admin
      if not current_user.is_admin?
        head(:forbidden)
      end
    end

    # Only allow a trusted parameter "white list" through.
    def category_params
      params.require(:category).permit(:description, :status)
    end
end
