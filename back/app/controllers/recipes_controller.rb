class RecipesController < ApplicationController
    before_action :set_recipe, only: [:show, :update, :destroy]
    before_action :authenticate_user!

  def index
    recipes = current_user.recipes
    render json: { status: 'SUCCESS', message: 'loaded recipes', data: recipes }
  end

  def show
    recipe_ingredients = @recipe.ingredients.all
    recipe_categories = @recipe.categories.all
    render json: { status: 'SUCCESS', message: 'loaded recipes', data: @recipe, data_ingredients: recipe_ingredients, data_categories: recipe_categories }
  end

  def create
    recipe = current_user.recipes.new(recipe_params)
    # category = Category.find(category_params[:category_id])
    if recipe.save
      # recipe.categories << category
      # recipe.images.attach(recipe_params[images:[]])
      render json: { status: 'SUCCESS', data: recipe }
    else
      render json: { status: 'ERROR', data: recipe.errors.full_messages }
    end
  end

  def destroy
    @recipe.destroy
    render json: { status: 'SUCCESS', message: 'Deleted the recipe', data: @recipe }
  end

  def update
    if @recipe.update(recipe_params)
      render json: { status: 'SUCCESS', message: 'Updated the recipe', data: @recipe }
    else
      render json: { status: 'ERROR', message: 'Not updated', data: @recipe.errors }
    end
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def recipe_params
    params.permit(:name, :description, :cost, :time, :serve, images: [],
    ingredient_recipes_attributes: [:id, :ingredient_id, :amount, :cost_used])
  end

  # def form_params
  #   {
  #     name: recipe_params[:name],
  #     description: recipe_params[:description],
  #     cost: recipe_params[:cost],
  #     time: recipe_params[:time],
  #     serve: recipe_params[:serve],
  #     ingredient_recipes_attributes: [
  #       # id: recipe_params[:id],
  #       ingredient_id: recipe_params[:ingredient_id],
  #       amount: recipe_params[:amount],
  #       # cost_used: recipe_params[:cost_used]
  #     ]
  #   }
  # end

  def category_params
    params.permit(:category_id)
  end
end
