class CvesController < ApplicationController
  before_action :set_cfe, only: [:show, :edit, :update, :destroy]

  # GET /cves
  # GET /cves.json
  def index
    @cves = Cve.all
  end

  # GET /cves/1
  # GET /cves/1.json
  def show
  end

  # GET /cves/new
  def new
    @cfe = Cve.new
  end

  # GET /cves/1/edit
  def edit
  end

  # POST /cves
  # POST /cves.json
  def create
    @cfe = Cve.new(cfe_params)

    respond_to do |format|
      if @cfe.save
        format.html { redirect_to @cfe, notice: 'Cve was successfully created.' }
        format.json { render :show, status: :created, location: @cfe }
      else
        format.html { render :new }
        format.json { render json: @cfe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cves/1
  # PATCH/PUT /cves/1.json
  def update
    respond_to do |format|
      if @cfe.update(cfe_params)
        format.html { redirect_to @cfe, notice: 'Cve was successfully updated.' }
        format.json { render :show, status: :ok, location: @cfe }
      else
        format.html { render :edit }
        format.json { render json: @cfe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cves/1
  # DELETE /cves/1.json
  def destroy
    @cfe.destroy
    respond_to do |format|
      format.html { redirect_to cves_url, notice: 'Cve was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cfe
      @cfe = Cve.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cfe_params
      params.require(:cfe).permit(:name, :seq, :status, :desc, :refs, :comments)
    end
end
