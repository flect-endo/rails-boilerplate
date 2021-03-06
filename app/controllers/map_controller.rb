# coding: utf-8
require 'kconv'

class MapController < ApplicationController

  def index
    @upload_form = UploadForm.new
    @tracks = Track.all
  end

  # 地名の書かれたCSVファイルをアップロード
  def upload_list
    form = UploadForm.new(params[:upload_form])

    @name = form.filename
    @data = []
    form.read_csv do |row|
      @data << row
    end
  end

  # 紹介した地名情報を一覧表示
  def places
    @places = params[:places].map do |place_params|
      Place.new(place_params[1].permit(:name, :address, :latitude, :longitude))
    end

    @track = Track.new(
      name: "#{@places.first.name}〜#{@places.last.name}",
      waypoints: @places.to_json(only: [:name, :address, :latitude, :longitude]))
  end
end
