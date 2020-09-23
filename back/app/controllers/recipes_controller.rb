class RecipesController < ApplicationController
    before_action :set_recipe, only: [:show, :update, :destroy]
    before_action :authenticate_user!

  def index
    recipes = current_user.recipes
    render json: { status: 'SUCCESS', message: 'loaded recipes', data: recipes }
  end

  def show
    recipe = @recipe.as_json
    recipe['ingredients'] = @recipe.ingredients.all
    recipe['detail'] = @recipe.ingredient_recipes
    # recipe_categories = @recipe.categories.all
    img = @recipe.image
    if img.present?
      # recipe['image'] = url_for(img)
      recipe['encode_image'] = encode_base64(img)
    end
    render json: { status: 'SUCCESS', message: 'loaded recipes', data: recipe }
  end

  def create
    recipe = current_user.recipes.new(recipe_params)

    # category = Category.find(category_params[:category_id])
    if recipe.save
      # recipe.categories << category
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
    @recipe = current_user.recipes.find(params[:id])
  end

  def recipe_params
    params.permit(:name, :description, :cost, :time, :serve, :image,
    ingredient_recipes_attributes: [:id, :ingredient_id, :amount, :cost_used])
  end

  def category_params
    params.permit(:category_id)
  end

  def encode_base64(image_file)
    image = Base64.encode64(image_file.download)
    blob = ActiveStorage::Blob.find(image_file[:id])
    "data:#{blob[:content_type]};base64,#{image}"
  end
end
