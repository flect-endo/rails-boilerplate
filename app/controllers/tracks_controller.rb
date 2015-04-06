class TracksController < ApplicationController
  before_action :set_track, except: [:index, :create, :export]

  def index
    @tracks = Track.all
  end

  def show
  end

  def create
    track = Track.new(track_params)
    track.save
    @tracks = Track.all
  end

  def load
    @track.line_color = params[:track][:line_color]
  end

  def export
    if params[:id].present?
      @track = Track.find(params[:id])
    else
      track_params = params.require(:track).permit(:trackpoints)
      @track = Track.new(trackpoints: JSON.parse(track_params[:trackpoints]))
    end
    respond_to do |format|
      format.csv
      format.gpx { send_data @track.to_gpx }
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
    params.require(:track).permit(
      :name,
      waypoints: ["name", "address", "latitude", "longitude"],
      trackpoints: ["lat", "lng"])
  end
end
