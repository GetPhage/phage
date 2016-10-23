class MdnsController < ApplicationController
  before_action :set_mdn, only: [:show, :edit, :update, :destroy]

  # GET /mdns
  # GET /mdns.json
  def index
    @mdns = Mdn.all.order(updated_at: :desc)
  end

  # GET /mdns/1
  # GET /mdns/1.json
  def show
  end

  # GET /mdns/new
  def new
    @mdn = Mdn.new
  end

  # GET /mdns/1/edit
  def edit
  end

  # POST /mdns
  # POST /mdns.json
  def create
    @mdn = Mdn.new(mdn_params)

    respond_to do |format|
      if @mdn.save
        format.html { redirect_to @mdn, notice: 'Mdn was successfully created.' }
        format.json { render :show, status: :created, location: @mdn }
      else
        format.html { render :new }
        format.json { render json: @mdn.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mdns/1
  # PATCH/PUT /mdns/1.json
  def update
    respond_to do |format|
      if @mdn.update(mdn_params)
        format.html { redirect_to @mdn, notice: 'Mdn was successfully updated.' }
        format.json { render :show, status: :ok, location: @mdn }
      else
        format.html { render :edit }
        format.json { render json: @mdn.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mdns/1
  # DELETE /mdns/1.json
  def destroy
    @mdn.destroy
    respond_to do |format|
      format.html { redirect_to mdns_url, notice: 'Mdn was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mdn
      @mdn = Mdn.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mdn_params
      params.require(:mdn).permit(:name, :service, :protocol, :device_id)
    end
end
