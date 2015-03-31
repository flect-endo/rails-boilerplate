class AddNameAndWaypointsToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :name, :string
    add_column :tracks, :waypoints, :string
  end
end
