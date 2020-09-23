class ChangeReferenceToRecipeCategory < ActiveRecord::Migration[6.0]
  def up
    remove_reference :recipe_categories, :recipe, index: true, foreign_key: true
    remove_reference :recipe_categories, :category, index: true, foreign_key: true

    add_reference :recipe_categories, :recipe, foreign_key: { on_delete: :cascade }, index: true
    add_reference :recipe_categories, :category, foreign_key: { on_delete: :cascade }, index: true
  end

  def down
    remove_reference :recipe_categories, :recipe, foreign_key: { on_delete: :cascade }, index: true
    remove_reference :recipe_categories, :category, foreign_key: { on_delete: :cascade }, index: true

    add_reference :recipe_categories, :recipe, index: true, foreign_key: true
    add_reference :recipe_categories, :category, index: true, foreign_key: true
  end
end
