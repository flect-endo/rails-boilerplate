class TracksController < ApplicationController
  before_action :set_track

  def load
    @trackpoints = JSON.parse(@track.trackpoints)
  end

  def destroy
    @track.destroy
    @tracks = Track.all
  end

  private

  def set_track
    @track = Track.find(params[:id])
  end
end
