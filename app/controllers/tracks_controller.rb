class TracksController < ApplicationController
  def destroy
  end

  def import
    track = Track.find(params[:id])
    @trackpoints = JSON.parse(track.trackpoints)
  end
end
