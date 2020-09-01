class Recipe < ApplicationRecord
    belongs_to :user
    has_many :comments, dependent: :destroy
    has_many :favorites, dependent: :destroy
    has_many :ingredient_recipes
    has_many :ingredients, through: :ingredient_recipes
    has_many :recipe_categories
    has_many :categories, through: :recipe_categories
    accepts_nested_attributes_for :ingredient_recipes, allow_destroy: true, update_only: true
    validates :name, presence: true
    has_many_attached :images

    def calculate_recipe_cost
        ingredient_recipes.each(&:calculate_cost_used)
        self.cost = ingredient_recipes.map(&:cost_used).sum
    end

    private

    before_save do
        calculate_recipe_cost
    end
end
