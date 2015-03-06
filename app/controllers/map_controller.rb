# coding: utf-8
require 'kconv'

class MapController < ApplicationController

  def index
    @map = Map.new
    @notes = Note.all
  end

  def upload_list
    @name = ""
    @data = []

    if (params[:map][:file])
      @name = params[:map][:file].original_filename
      filedata = params[:map][:file].read
      filedata.force_encoding("utf-8")
      CSV.parse(filedata) do |row|
        @data << row
      end
    end
  end

  def places
    @places = []
    params[:places].each do |place_attrs|
      @places.push(Place.new(place_attrs[1].permit(:address, :latitude, :longitude)))
    end
  end
end
