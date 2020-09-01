class CreateIngredientRecipes < ActiveRecord::Migration[6.0]
  def change
    create_table :ingredient_recipes do |t|
      t.decimal :amount, precision: 5, scale: 1, null: false
      t.decimal :cost_used, precision: 5, scale: 1, null: false
      t.references :ingredient, foreign_key: true
      t.references :recipe, foreign_key: true
      
      t.timestamps
    end
  end
end
