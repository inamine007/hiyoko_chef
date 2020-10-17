class IngredientRecipeSerializer < ActiveModel::Serializer
  attributes :id, :amount, :ingredient

  def ingredient
    Ingredient.find(object.ingredient_id)
  end

end
