class CreateIngredients < ActiveRecord::Migration[6.0]
  def change
    create_table :ingredients do |t|
      t.string :name, null: false
      t.string :trader, null: false
      t.string :unit, null: false
      t.string :unit_used, null: false
      t.integer :cost, null: false
      t.decimal :budomari, precision: 3, scale: 2, null: false
      t.decimal :converted_number, precision: 5, scale: 4, null: false
      t.decimal :cost_used, precision: 5, scale: 1, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
