class PicturesController < ApplicationController
  before_action :set_resources, only: [:index]

  def index
    @upload_form = UploadForm.new
  end

  def destroy
    Cloudinary::Api.delete_resources([params[:public_id]])
    respond_to do |format|
      format.html { redirect_to pictures_url, notice: 'Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upload
    form = UploadForm.new(params[:upload_form])
    Cloudinary::Uploader.upload(form.file)
    set_resources
  end

  private

  def set_resources
    @resources = Cloudinary::Api::resources["resources"]
  end
end
