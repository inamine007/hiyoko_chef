class FavoritesController < ApplicationController
    before_action :set_favorite

    def index
        user_ids = @recipe.favorites.pluck(:user_id)
        render json: { status: 'SUCCESS', data: user_ids }
    end

    def create
        favorite = current_user.favorites.create(recipe_id: params[:recipe_id])
        render json: { status: 'SUCCESS', data: favorite }
    end

    def destroy
        @favorite.destroy
        render json: { status: 'SUCCESS', message: 'Deleted the comment', data: @favorite }
    end

    private

    def set_favorite
        @recipe = Recipe.find(params[:recipe_id])
        @favorite = current_user.favorites.find_by(recipe_id: @recipe.id)
    end
end
