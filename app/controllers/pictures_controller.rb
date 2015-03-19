class PicturesController < ApplicationController
  def index
    @upload_form = UploadForm.new
  end

  def upload
    form = UploadForm.new(params[:upload_form])
    @result = Cloudinary::Uploader.upload(form.file)
  end
end
