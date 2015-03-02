class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.references :user, index: true
      t.string :title
      t.text :body

      t.timestamps null: false
    end
    add_foreign_key :notes, :users
  end
end
