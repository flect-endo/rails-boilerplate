class CreateUserChecklists < ActiveRecord::Migration
  def change
    create_table :user_checklists do |t|
      t.integer :user_id, default: 0, null: false
      t.integer :checklist_id, default: 0, null: false
      t.date :date
      t.timestamps null: false
    end
  end
end
