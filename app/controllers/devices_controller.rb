class DevicesController < ApplicationController
  before_action :set_device, only: [:show, :edit, :update, :destroy]
#  before_action :authenticate_user!
  
  # GET /devices
  # GET /devices.json
  def index
    @devices = Device.per_user(current_user).order(updated_at: :desc).paginate(:page => params[:page], per_page: 100)
  end

  # GET /devices/1
  # GET /devices/1.json
  def show
    @flows = Flow.where(device: @device).limit(10).order(id: :desc)

#  (bins, freq) = Flow.where(device: @device).pluck(:bytes_sent).histogram([0, 10, 100, 1000, 10000, 100000, 1000000]) 
    bytes_sent = Flow.where(device: @device).pluck(:bytes_sent)
    bytes_received = Flow.where(device: @device).pluck(:bytes_received)
    (bins, sent_freq) = bytes_sent.histogram(20, other_sets: [ bytes_received ])
    (bins, rcvd_freq) = bytes_received.histogram(20, other_sets: [ bytes_sent ])

#    str_bins = bins.map do |bin| number_with_precision(bin, :precision => 0, :delimiter => ',') end
    str_bins = bins
    require 'pp'

    @size_data_sent = Hash[str_bins.zip(sent_freq)]
    puts 'sent'
    pp @size_data_sent
    
    @size_data_received = Hash[str_bins.zip(rcvd_freq)]
    pp @size_data_received

    most_recent = Flow.where(device: @device).last
    samples = Flow.where(device: @device).where("timestamp < ?", most_recent.timestamp - 1.day)
    sent = samples.pluck(:bytes_sent)
    received = samples.pluck(:bytes_received)
    timestamps = samples.pluck(:timestamp)
    @time_data_sent = Hash[timestamps.zip(sent)]
    @time_data_received = Hash[timestamps.zip(received)]
  end

  # GET /devices/new
  def new
    @device = Device.new
  end

  # GET /devices/1/edit
  def edit
  end

  # POST /devices
  # POST /devices.json
  def create
    @device = Device.new(device_params)

    respond_to do |format|
      if @device.save
        format.html { redirect_to @device, notice: 'Device was successfully created.' }
        format.json { render :show, status: :created, location: @device }
      else
        format.html { render :new }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /devices/1
  # PATCH/PUT /devices/1.json
  def update
    respond_to do |format|
      if @device.update(device_params)
        format.html { redirect_to @device, notice: 'Device was successfully updated.' }
        format.json { render :show, status: :ok, location: @device }
      else
        format.html { render :edit }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /devices/1
  # DELETE /devices/1.json
  def destroy
    @device.destroy
    respond_to do |format|
      format.html { redirect_to devices_url, notice: 'Device was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device
      @device = Device.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def device_params
      params.require(:device).permit(:mac_address, :ipv4, :ipv6, :kind, :last_seen, :extra)
    end
end
