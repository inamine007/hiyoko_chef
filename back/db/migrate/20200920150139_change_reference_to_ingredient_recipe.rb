class ChangeReferenceToIngredientRecipe < ActiveRecord::Migration[6.0]
  def up
    remove_reference :ingredient_recipes, :recipe, index: true, foreign_key: true
    remove_reference :ingredient_recipes, :ingredient, index: true, foreign_key: true

    add_reference :ingredient_recipes, :recipe, foreign_key: { on_delete: :cascade }, index: true
    add_reference :ingredient_recipes, :ingredient, foreign_key: { on_delete: :cascade }, index: true
  end

  def down
    remove_reference :ingredient_recipes, :recipe, foreign_key: { on_delete: :cascade }, index: true
    remove_reference :ingredient_recipes, :ingredient, foreign_key: { on_delete: :cascade }, index: true

    add_reference :ingredient_recipes, :recipe, index: true, foreign_key: true
    add_reference :ingredient_recipes, :ingredient, index: true, foreign_key: true
  end
end
