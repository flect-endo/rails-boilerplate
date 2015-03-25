class TracksController < ApplicationController
  before_action :set_track, except: [:create]

  def create
    Track.create!(trackpoints: params[:map][:tracks])
    @tracks = Track.all
  end

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
