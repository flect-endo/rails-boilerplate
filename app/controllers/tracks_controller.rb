class TracksController < ApplicationController
  before_action :set_track, except: [:create, :export]

  def create
    track = Track.new(track_params)
    track.save
    @tracks = Track.all
  end

  def load
  end

  def export
    if params[:id].present?
      @track = Track.find(params[:id])
    else
      track_params = params.require(:track).permit(:trackpoints)
      @track = Track.new(trackpoints: JSON.parse(track_params[:trackpoints]))
    end
    respond_to do |format|
      format.gpx
    end
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
