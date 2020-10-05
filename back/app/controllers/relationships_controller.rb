class RelationshipsController < ApplicationController
    before_action :set_user, only: [:create, :destroy]

  def index
    followings = current_user.followings
    followers = current_user.followers
    render json: { status: 'SUCCESS', data_followings: followings, data_followers: followers }
  end

  def recipes
    ids = current_user.followings.ids
    recipes = Recipe.published.where(user_id: ids)
    render json: recipes, each_serializer: RecipeSerializer
  end
  
  def create
    following = current_user.follow(@user) unless current_user == @user.id
    if following.save
        @user.create_notification_follow!(current_user)
        render json: { status: 'SUCCESS', data: following }
    else
        render json: { status: 'ERROR', data: following.errors.full_messages }
    end
  end

  def destroy
    following = current_user.unfollow(@user)
    if following.destroy
        render json: { status: 'SUCCESS', data: following }
    else
        render json: { status: 'ERROR', data: following.errors.full_messages }
    end
  end

  private

  def set_user
      @user = User.find(params[:user_id])
  end
end
