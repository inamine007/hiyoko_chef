class RecipeSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :name, :description, :cost, :time, :serve, :status, :group_id, :image

  belongs_to :user
  belongs_to :group, optional: true
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :ingredient_recipes
  has_many :ingredients, through: :ingredient_recipes
  has_many :recipe_categories
  has_many :categories, through: :recipe_categories
  # accepts_nested_attributes_for :ingredient_recipes, allow_destroy: true, update_only: true
  def image
    url_for(object.image) if object.image.attached?
  end
end
