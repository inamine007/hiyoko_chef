class AddColumnToRecipe < ActiveRecord::Migration[6.0]
  def up
    add_column :recipes, :status, :integer, default: 0, null: false
    add_reference :recipes, :group, foreign_key: true
  end

  def down
    remove_column :recipes, :status, :integer, default: 0, null: false
    remove_reference :recipes, :group, foreign_key: true
  end
end
