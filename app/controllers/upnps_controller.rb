class UpnpsController < ApplicationController
  before_action :set_upnp, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /upnps
  # GET /upnps.json
  def index
    @upnps = Upnp.all.order(updated_at: :asc).paginate(:page => params[:page], per_page: 100)
  end

  # GET /upnps/1
  # GET /upnps/1.json
  def show
  end

  # GET /upnps/new
  def new
    @upnp = Upnp.new
  end

  # GET /upnps/1/edit
  def edit
  end

  # POST /upnps
  # POST /upnps.json
  def create
    @upnp = Upnp.new(upnp_params)

    respond_to do |format|
      if @upnp.save
        format.html { redirect_to @upnp, notice: 'Upnp was successfully created.' }
        format.json { render :show, status: :created, location: @upnp }
      else
        format.html { render :new }
        format.json { render json: @upnp.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /upnps/1
  # PATCH/PUT /upnps/1.json
  def update
    respond_to do |format|
      if @upnp.update(upnp_params)
        format.html { redirect_to @upnp, notice: 'Upnp was successfully updated.' }
        format.json { render :show, status: :ok, location: @upnp }
      else
        format.html { render :edit }
        format.json { render json: @upnp.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /upnps/1
  # DELETE /upnps/1.json
  def destroy
    @upnp.destroy
    respond_to do |format|
      format.html { redirect_to upnps_url, notice: 'Upnp was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_upnp
      @upnp = Upnp.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def upnp_params
      params.require(:upnp).permit(:device_id, :st, :usn, :location, :cache_control, :server, :ext)
    end
end
