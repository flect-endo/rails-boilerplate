class ChecklistsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_checklist, only: [:show, :edit, :update, :destroy]

  # GET /checklists
  # GET /checklists.json
  def index
    @checklists = Checklist.all
    @upload_form = UploadForm.new
  end

  # GET /checklists/1
  # GET /checklists/1.json
  def show
  end

  # GET /checklists/new
  def new
    @checklist = Checklist.new
  end

  # GET /checklists/1/edit
  def edit
  end

  # POST /checklists
  # POST /checklists.json
  def create
    @checklist = Checklist.new(checklist_params)

    respond_to do |format|
      if @checklist.save
        format.html { redirect_to @checklist, notice: 'Checklist was successfully created.' }
        format.json { render :show, status: :created, location: @checklist }
      else
        format.html { render :new }
        format.json { render json: @checklist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /checklists/1
  # PATCH/PUT /checklists/1.json
  def update
    respond_to do |format|
      if @checklist.update(checklist_params)
        format.html { redirect_to @checklist, notice: 'Checklist was successfully updated.' }
        format.json { render :show, status: :ok, location: @checklist }
      else
        format.html { render :edit }
        format.json { render json: @checklist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /checklists/1
  # DELETE /checklists/1.json
  def destroy
    @checklist.destroy
    respond_to do |format|
      format.html { redirect_to checklists_url, notice: 'Checklist was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # DELETE /checklists
  # DELETE /checklists.json
  def destroy_all
    Checklist.delete_all
    respond_to do |format|
      format.html { redirect_to checklists_url, notice: 'All checklists were successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upload
    form = UploadForm.new(params[:upload_form])
    @checklists = []

    Checklist.transaction do
      Checklist.delete_all
      form.read_csv do |row|
        @checklists << Checklist.create!(title: row[0])
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_checklist
      @checklist = Checklist.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def checklist_params
      params.require(:checklist).permit(:title)
    end
end
