class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.date :date, null: false
      t.references :user, null: false
      t.datetime :started_at
      t.datetime :ended_at
    end
    add_index :attendances, ["date", "user_id"], unique: true
    # add_foreign_key :attendances, :user_ids
  end
end
