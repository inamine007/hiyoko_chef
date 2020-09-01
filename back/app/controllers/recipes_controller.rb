class RecipesController < ApplicationController
    before_action :set_recipe, only: [:show, :update, :destroy]
    before_action :authenticate_user!

  def index
    recipes = current_user.recipes
    render json: { status: 'SUCCESS', message: 'loaded recipes', data: recipes }
  end

  def show
    recipe_ingredients = @recipe.ingredients.all
    render json: { status: 'SUCCESS', message: 'loaded recipes', data1: @recipe, data2: recipe_ingredients }
  end

  def create
    recipe = current_user.recipes.new(recipe_params)
    if recipe.save
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
    @recipe = current_user.recipes.find(params[:id])
  end

  def recipe_params
    params.require(:recipe).permit(:name, :description, :cost, :images, ingredient_recipes_attributes: [:id, :ingredient_id, :amount, :cost_used, :_destroy])
  end
end
