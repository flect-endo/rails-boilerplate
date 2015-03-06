# coding: utf-8
require 'kconv'

class MapController < ApplicationController

  def index
    @map = Map.new
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
    @places = params[:places].map {|place_params| Place.new(place_params[1].permit(:address, :latitude, :longitude)) }
  end
end
