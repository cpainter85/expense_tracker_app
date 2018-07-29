class CategoriesController < ApplicationController
  def index 
    @categories = Category.order(:name) 
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to categories_path, notice: "#{@category.name} was successfully created"
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      redirect_to categories_path, notice: "#{@category.name} was successfully updated"
    end
  end

  def destroy
    @category = Category.find(params[:id])
    if @category.destroy
      redirect_to categories_path, notice: "#{@category.name} was successfully destroyed"
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end