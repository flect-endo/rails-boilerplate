class TracksController < ApplicationController
  before_action :set_track, except: [:create]

  def create
    Track.create!(trackpoints: JSON.parse(params[:track][:trackpoints]))
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
end
