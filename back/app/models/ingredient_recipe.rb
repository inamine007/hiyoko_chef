class IngredientRecipe < ApplicationRecord
    belongs_to :ingredient
    belongs_to :recipe

    def calculate_cost_used
        self.cost_used = ingredient.cost_used * amount
    end
end
