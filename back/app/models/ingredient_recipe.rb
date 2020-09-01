class IngredientRecipe < ApplicationRecord
    belongs_to :ingredient, autosave: true
    belongs_to :recipe, autosave: true

    def calculate_cost_used
        self.cost_used = ingredient.cost_used * amount
    end
end
