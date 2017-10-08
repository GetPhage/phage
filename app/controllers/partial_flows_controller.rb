class PartialFlowsController < ApplicationController
  before_action :set_partial_flow, only: [:show, :edit, :update, :destroy]

  # GET /partial_flows
  # GET /partial_flows.json
  def index
    @partial_flows = PartialFlow.all.order(timestamp: :asc).paginate(:page => params[:page], per_page: 20)
    if params[:flow_id]
      @flow = Flow.find params[:flow_id]
      @partial_flows = @partial_flows.where(flow: @flow)
      @similar = PartialFlow.where(src_ip: @flow.src_ip, dst_ip: @flow.dst_ip, src_port: @flow.src_port, dst_port: @flow.dst_port).or(PartialFlow.where(src_ip: @flow.dst_ip, dst_ip: @flow.src_ip, src_port: @flow.dst_port, dst_port: @flow.src_port)).order(timestamp: :asc)
    end
  end

  # GET /partial_flows/1
  # GET /partial_flows/1.json
  def show
  end

  # GET /partial_flows/new
  def new
    @flow = Flow.new
  end

  # GET /partial_flows/1/edit
  def edit
  end

  # POST /partial_flows
  # POST /partial_flows.json
  def create
    @flow = Flow.new(partial_flow_params)

    respond_to do |format|
      if @flow.save
        format.html { redirect_to @flow, notice: 'Flow was successfully created.' }
        format.json { render :show, status: :created, location: @flow }
      else
        format.html { render :new }
        format.json { render json: @flow.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /partial_flows/1
  # PATCH/PUT /partial_flows/1.json
  def update
    respond_to do |format|
      if @flow.update(partial_flow_params)
        format.html { redirect_to @flow, notice: 'Flow was successfully updated.' }
        format.json { render :show, status: :ok, location: @flow }
      else
        format.html { render :edit }
        format.json { render json: @flow.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /partial_flows/1
  # DELETE /partial_flows/1.json
  def destroy
    @flow.destroy
    respond_to do |format|
      format.html { redirect_to partial_flows_url, notice: 'Flow was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_partial_flow
      @flow = Flow.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def partial_flow_params
      params.require(:flow).permit(:name, :seq, :status, :desc, :refs, :comments)
    end
end
