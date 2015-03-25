# coding: utf-8
require 'kconv'

class MapController < ApplicationController

  def index
    @upload_form = UploadForm.new
  end

  def upload_list
    form = UploadForm.new(params[:upload_form])

    @name = form.filename
    @data = []
    form.read_csv do |row|
      @data << row
    end
  end

  def places
    @places = params[:places].map {|place_params| Place.new(place_params[1].permit(:address, :latitude, :longitude)) }
    @map = Map.new
  end

  def export
    @tracks = JSON.parse(params[:map][:tracks])
    respond_to do |format|
      format.gpx
    end
  end
end
