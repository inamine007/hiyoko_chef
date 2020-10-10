class IngredientsController < ApplicationController
    before_action :set_ingredient, only: [:show, :update, :destroy]
    before_action :authenticate_user!

  def index
    ingredients = current_user.ingredients
    render json: { status: 'SUCCESS', message: 'loaded ingredients', data: ingredients }
  end

  def show
    ingredient = @ingredient.as_json
    ingredient['created'] = @ingredient.created_at.strftime("%Y-%m-%d %H:%M")
    ingredient['updated'] = @ingredient.updated_at.strftime("%Y-%m-%d %H:%M")
    render json: { status: 'SUCCESS', message: 'loaded ingredients', data: ingredient }
  end

  def create
    ingredient = current_user.ingredients.new(ingredient_params)
    if ingredient.save
      render json: { status: 'SUCCESS', data: ingredient }
    else
      render json: { status: 'ERROR', data: ingredient.errors.full_messages }
    end
  end

  def destroy
    @ingredient.destroy
    render json: { status: 'SUCCESS', message: 'Deleted the ingredient', data: @ingredient }
  end

  def update
    recipes = @ingredient.recipes
    if @ingredient.update(ingredient_params)
      recipes.update(cost: recipe_params[:cost]) if recipes.present?
      render json: { status: 'SUCCESS', message: 'Updated the ingredient', data: @ingredient }
    else
      render json: { status: 'ERROR', message: 'Not updated', data: @ingredient.errors }
    end
  end

  private

  def set_ingredient
    @ingredient = current_user.ingredients.find(params[:id])
  end

  def ingredient_params
    params.require(:ingredient).permit(:name, :trader, :cost, :unit, :unit_used, :budomari, :converted_number, :cost_used)
  end

  def recipe_params
    params.permit(:cost)
  end
end