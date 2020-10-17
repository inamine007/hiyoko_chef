class RecipesController < ApplicationController
    before_action :set_recipe, only: [:show, :comments, :ingredients, :update, :destroy]
    before_action :authenticate_user!

  def index
    recipes = current_user.recipes.published
    render json: recipes, each_serializer: RecipeSerializer
  end

  def user
    user = User.find(params[:id])
    recipes = user.recipes.published
    render json: recipes, each_serializer: RecipeSerializer
  end

  def search
    recipes = Recipe.published.search(recipe_params[:name])
    render json: recipes, each_serializer: RecipeSerializer
  end

  def comments
    comments = @recipe.comments
    render json: comments, each_serializer: CommentSerializer
  end

  def confirm
    recipes = current_user.recipes
    render json: { status: 'SUCCESS', message: 'loaded recipes', data: recipes }
  end

  def show
    render json: @recipe, serializer: RecipeSerializer
  end

  def ingredients
    ingredients = @recipe.ingredient_recipes
    render json: ingredients, each_serializer: IngredientRecipeSerializer
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
      @recipe.ingredients.destroy_all
      @recipe.update(recipe_params)
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
    params.permit(:name, :description, :cost, :time, :serve, :image, :status, :group_id,
    ingredient_recipes_attributes: [:id, :ingredient_id, :amount, :cost_used])
  end

  def category_params
    params.permit(:category_id)
  end
end
