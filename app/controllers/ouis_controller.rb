class OuisController < ApplicationController
  before_action :set_oui, only: [:show, :edit, :update, :destroy]
#  before_action :authenticate_user!

  # GET /ouis
  # GET /ouis.json
  def index
    @ouis = Oui.all.order(updated_at: :asc)
  end

  # GET /ouis/1
  # GET /ouis/1.json
  def show
  end

  # GET /ouis/new
  def new
    @oui = Oui.new
  end

  # GET /ouis/1/edit
  def edit
  end

  # POST /ouis
  # POST /ouis.json
  def create
    @oui = Oui.new(oui_params)

    respond_to do |format|
      if @oui.save
        format.html { redirect_to @oui, notice: 'Oui was successfully created.' }
        format.json { render :show, status: :created, location: @oui }
      else
        format.html { render :new }
        format.json { render json: @oui.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ouis/1
  # PATCH/PUT /ouis/1.json
  def update
    respond_to do |format|
      if @oui.update(oui_params)
        format.html { redirect_to @oui, notice: 'Oui was successfully updated.' }
        format.json { render :show, status: :ok, location: @oui }
      else
        format.html { render :edit }
        format.json { render json: @oui.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ouis/1
  # DELETE /ouis/1.json
  def destroy
    @oui.destroy
    respond_to do |format|
      format.html { redirect_to ouis_url, notice: 'Oui was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_oui
      @oui = Oui.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def oui_params
      params.require(:oui).permit(:prefix, :manufacturer)
    end
end
