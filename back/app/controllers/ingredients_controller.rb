class IngredientsController < ApplicationController
    before_action :set_ingredient, only: [:show, :update, :destroy]
    before_action :authenticate_user!

  def index
    ingredients = current_user.ingredients
    render json: { status: 'SUCCESS', message: 'loaded ingredients', data: ingredients }
  end

  def show
    render json: { status: 'SUCCESS', message: 'loaded ingredients', data: @ingredients }
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
    @ingredients.destroy
    render json: { status: 'SUCCESS', message: 'Deleted the ingredient', data: @ingredients }
  end

  def update
    recipes = @ingredients.recipes.all
    if @ingredients.update(ingredient_params)
      recipes.update(cost: recipe_params[:cost]) if recipes.present?
      render json: { status: 'SUCCESS', message: 'Updated the ingredient', data: @ingredients }
    else
      render json: { status: 'ERROR', message: 'Not updated', data: @ingredients.errors }
    end
  end

  private

  def set_ingredient
    @ingredients = current_user.ingredients.find(params[:id])
  end

  def ingredient_params
    params.require(:ingredient).permit(:name, :trader, :cost, :unit, :unit_used, :budomari, :converted_number, :cost_used)
  end

  def recipe_params
    params.permit(:cost)
  end
end