class SoftwareBlacklistsController < ApplicationController
  before_action :set_software_blacklist, only: [:show, :edit, :update, :destroy]

  # GET /software_blacklists
  # GET /software_blacklists.json
  def index
    @software_blacklists = SoftwareBlacklist.all
  end

  # GET /software_blacklists/1
  # GET /software_blacklists/1.json
  def show
  end

  # GET /software_blacklists/new
  def new
    @software_blacklist = SoftwareBlacklist.new
  end

  # GET /software_blacklists/1/edit
  def edit
  end

  # POST /software_blacklists
  # POST /software_blacklists.json
  def create
    @software_blacklist = SoftwareBlacklist.new(software_blacklist_params)

    respond_to do |format|
      if @software_blacklist.save
        format.html { redirect_to @software_blacklist, notice: 'Software blacklist was successfully created.' }
        format.json { render :show, status: :created, location: @software_blacklist }
      else
        format.html { render :new }
        format.json { render json: @software_blacklist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /software_blacklists/1
  # PATCH/PUT /software_blacklists/1.json
  def update
    respond_to do |format|
      if @software_blacklist.update(software_blacklist_params)
        format.html { redirect_to @software_blacklist, notice: 'Software blacklist was successfully updated.' }
        format.json { render :show, status: :ok, location: @software_blacklist }
      else
        format.html { render :edit }
        format.json { render json: @software_blacklist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /software_blacklists/1
  # DELETE /software_blacklists/1.json
  def destroy
    @software_blacklist.destroy
    respond_to do |format|
      format.html { redirect_to software_blacklists_url, notice: 'Software blacklist was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_software_blacklist
      @software_blacklist = SoftwareBlacklist.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def software_blacklist_params
      params.require(:software_blacklist).permit(:name, :version, :reason)
    end
end
