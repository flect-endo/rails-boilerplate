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
    @places = params[:places].map {|place_params| Place.new(place_params[1].permit(:address, :latitude, :longitude)) }
    @map = Map.new
  end

  # ルート情報をエクスポートする
  def export
    @tracks = JSON.parse(params[:map][:tracks])
    respond_to do |format|
      format.gpx
    end
  end
end
