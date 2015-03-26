class TracksController < ApplicationController
  before_action :set_track, except: [:create]

  def create
    track = Track.new(track_params)
    track.save
    @tracks = Track.all
  end

  def load
  end

  def destroy
    @track.destroy
    @tracks = Track.all
  end

  private

  def set_track
    @track = Track.find(params[:id])
  end

  def track_params
    params.require(:track).permit(trackpoints: ["lat", "lng"])
  end
end
