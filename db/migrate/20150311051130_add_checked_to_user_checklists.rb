class AddCheckedToUserChecklists < ActiveRecord::Migration
  def change
    add_column :user_checklists, :checked, :boolean, null: false, default: false
  end
end
