class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.text :trackpoints, default: "", null: false
    end
  end
end
