class GeoIpsController < ApplicationController
  before_action :set_geo_ip, only: [:show, :edit, :update, :destroy]

  # GET /geo_ips
  # GET /geo_ips.json
  def index
    @geo_ips = GeoIp.all
  end

  # GET /geo_ips/1
  # GET /geo_ips/1.json
  def show
  end

  # GET /geo_ips/new
  def new
    @geo_ip = GeoIp.new
  end

  # GET /geo_ips/1/edit
  def edit
  end

  # POST /geo_ips
  # POST /geo_ips.json
  def create
    @geo_ip = GeoIp.new(geo_ip_params)

    respond_to do |format|
      if @geo_ip.save
        format.html { redirect_to @geo_ip, notice: 'Geo ip was successfully created.' }
        format.json { render :show, status: :created, location: @geo_ip }
      else
        format.html { render :new }
        format.json { render json: @geo_ip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /geo_ips/1
  # PATCH/PUT /geo_ips/1.json
  def update
    respond_to do |format|
      if @geo_ip.update(geo_ip_params)
        format.html { redirect_to @geo_ip, notice: 'Geo ip was successfully updated.' }
        format.json { render :show, status: :ok, location: @geo_ip }
      else
        format.html { render :edit }
        format.json { render json: @geo_ip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /geo_ips/1
  # DELETE /geo_ips/1.json
  def destroy
    @geo_ip.destroy
    respond_to do |format|
      format.html { redirect_to geo_ips_url, notice: 'Geo ip was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_geo_ip
      @geo_ip = GeoIp.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def geo_ip_params
      params.require(:geo_ip).permit(:ipaddr, :geo_location_id)
    end
end
