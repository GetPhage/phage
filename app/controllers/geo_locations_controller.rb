class GeoLocationsController < ApplicationController
  before_action :set_geo_location, only: [:show, :edit, :update, :destroy]

  # GET /geo_locations
  # GET /geo_locations.json
  def index
    @geo_locations = GeoLocation.all
  end

  # GET /geo_locations/1
  # GET /geo_locations/1.json
  def show
  end

  # GET /geo_locations/new
  def new
    @geo_location = GeoLocation.new
  end

  # GET /geo_locations/1/edit
  def edit
  end

  # POST /geo_locations
  # POST /geo_locations.json
  def create
    @geo_location = GeoLocation.new(geo_location_params)

    respond_to do |format|
      if @geo_location.save
        format.html { redirect_to @geo_location, notice: 'Geo location was successfully created.' }
        format.json { render :show, status: :created, location: @geo_location }
      else
        format.html { render :new }
        format.json { render json: @geo_location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /geo_locations/1
  # PATCH/PUT /geo_locations/1.json
  def update
    respond_to do |format|
      if @geo_location.update(geo_location_params)
        format.html { redirect_to @geo_location, notice: 'Geo location was successfully updated.' }
        format.json { render :show, status: :ok, location: @geo_location }
      else
        format.html { render :edit }
        format.json { render json: @geo_location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /geo_locations/1
  # DELETE /geo_locations/1.json
  def destroy
    @geo_location.destroy
    respond_to do |format|
      format.html { redirect_to geo_locations_url, notice: 'Geo location was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_geo_location
      @geo_location = GeoLocation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def geo_location_params
      params.require(:geo_location).permit(:geoname_id, :continent, :country)
    end
end
