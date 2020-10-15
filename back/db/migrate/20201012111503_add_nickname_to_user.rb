class AddNicknameToUser < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :nickname, :string
  end

  def down
    remove_column :users, :nickname, :string
  end
end
