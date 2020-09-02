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
    category = Category.find(category_params[:category_id])
    if recipe.save
      recipe.categories << category
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
    params.require(:recipe).permit(:name, :description, :cost, :images,
    ingredient_recipes_attributes: [:id, :ingredient_id, :amount, :cost_used])
  end

  def category_params
    params.permit(:category_id)
  end
end
