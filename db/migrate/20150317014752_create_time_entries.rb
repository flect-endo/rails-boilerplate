class CreateTimeEntries < ActiveRecord::Migration
  def change
    create_table :time_entries do |t|
      t.references :attendance, null: false
      t.datetime :started_at
      t.datetime :ended_at
    end
  end
end
