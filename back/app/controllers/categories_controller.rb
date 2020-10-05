class CategoriesController < ApplicationController
  def index
    categories = Category.all
    render json: { status: 'SUCCESS', data: categories }
  end

  def my_count
    chart_data = data(current_user)
    render json: { status: 'SUCCESS', data: chart_data }
  end

  def user_count
    user = User.find(params[:id])
    chart_data = data(user)
    render json: { status: 'SUCCESS', data: chart_data }
  end

  def search
    category = Category.find_by(name: params[:name])
    if category
      recipes = category.recipes.published
    else
      recipes = {}
    end
    render json: recipes, each_serializer: RecipeSerializer
  end

  private

  def data(user)
    categories = user.recipes.map do |recipe|
      recipe.categories.first
    end
    name = categories.map do |category|
      category.name
    end
    data = {}
    name.each do |n|
      data.merge!(n => name.count(n))
    end
    return data
  end
end
