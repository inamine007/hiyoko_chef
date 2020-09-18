class ChangeReferenceToGroupUsers < ActiveRecord::Migration[6.0]
  def up
    remove_reference :group_users, :user, index: true, foreign_key: true
    remove_reference :group_users, :group, index: true, foreign_key: true

    add_reference :group_users, :user, foreign_key: { on_delete: :cascade }, index: true
    add_reference :group_users, :group, foreign_key: { on_delete: :cascade }, index: true
  end

  def down
    remove_reference :group_users, :user, foreign_key: { on_delete: :cascade }, index: true
    remove_reference :group_users, :group, foreign_key: { on_delete: :cascade }, index: true

    add_reference :group_users, :user, index: true, foreign_key: true
    add_reference :group_users, :group, index: true, foreign_key: true
  end
end
