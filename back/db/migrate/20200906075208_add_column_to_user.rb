class AddColumnToUser < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :introduction, :text
    remove_column :users, :image, :string
  end

  def down
    remove_column :users, :introduction, :text
    add_column :users, :image, :string
  end
end
