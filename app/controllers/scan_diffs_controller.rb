class ScanDiffsController < ApplicationController
  before_action :set_scan_diff, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /scan_diffs
  # GET /scan_diffs.json
  def index
    @scan_diffs = ScanDiff.all.order(id: :desc).paginate(:page => params[:page], per_page: 50)
  end

  # GET /scan_diffs/1
  # GET /scan_diffs/1.json
  def show
  end

  # GET /scan_diffs/new
  def new
    @scan_diff = ScanDiff.new
  end

  # GET /scan_diffs/1/edit
  def edit
  end

  # POST /scan_diffs
  # POST /scan_diffs.json
  def create
    @scan_diff = ScanDiff.new(scan_diff_params)

    respond_to do |format|
      if @scan_diff.save
        format.html { redirect_to @scan_diff, notice: 'Scan diff was successfully created.' }
        format.json { render :show, status: :created, location: @scan_diff }
      else
        format.html { render :new }
        format.json { render json: @scan_diff.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /scan_diffs/1
  # PATCH/PUT /scan_diffs/1.json
  def update
    respond_to do |format|
      if @scan_diff.update(scan_diff_params)
        format.html { redirect_to @scan_diff, notice: 'Scan diff was successfully updated.' }
        format.json { render :show, status: :ok, location: @scan_diff }
      else
        format.html { render :edit }
        format.json { render json: @scan_diff.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scan_diffs/1
  # DELETE /scan_diffs/1.json
  def destroy
    @scan_diff.destroy
    respond_to do |format|
      format.html { redirect_to scan_diffs_url, notice: 'Scan diff was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scan_diff
      @scan_diff = ScanDiff.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def scan_diff_params
      params.require(:scan_diff).permit(:scan_id, :device_id, :kind, :status, :extra)
    end
end
