# coding: utf-8
require 'kconv'

class MapController < ApplicationController

  def index
    @csv_form = CsvForm.new
  end

  def upload_list
    csv_form = CsvForm.new(params[:csv_form])

    @name = csv_form.filename
    @data = []
    csv_form.read do |row|
      @data << row
    end
  end

  def places
    @places = params[:places].map {|place_params| Place.new(place_params[1].permit(:address, :latitude, :longitude)) }
  end
end
