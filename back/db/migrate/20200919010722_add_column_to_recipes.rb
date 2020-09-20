class AddColumnToRecipes < ActiveRecord::Migration[6.0]
  def up
    add_column :recipes, :time, :integer
    add_column :recipes, :serve, :integer
  end

  def down
    remove_column :recipes, :time, :integer
    remove_column :recipes, :serve, :integer
  end
end
