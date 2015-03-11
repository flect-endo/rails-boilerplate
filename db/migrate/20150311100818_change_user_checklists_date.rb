class ChangeUserChecklistsDate < ActiveRecord::Migration
  def change
    remove_column :user_checklists, :date
    add_column :user_checklists, :datetime, :datetime
  end
end
