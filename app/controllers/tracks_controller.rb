class TracksController < ApplicationController

  def load
    track = Track.find(params[:id])
    @trackpoints = JSON.parse(track.trackpoints)
  end

  def destroy
  end
end
