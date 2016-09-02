class AnalysesController < ApplicationController
  before_action :set_analysis, only: [:show, :edit, :update, :destroy]

  # GET /analyses/new
  def new
    @geo_locations = GeoLocation.select(:country).distinct.order(:country)
    @analysis = Analysis.new
    @analysis.fertilizers.build
    @analysis.manures.build
    @analysis.fuels.build
    @analysis.nutrient_managements.build
    @analysis.transportation_fuels.build
    @analysis.irrigation_fuels.build
    @analysis.other_fuels.build
  end

  # GET /analyses/1/edit
  def edit
  end

  # POST /analyses
  # POST /analyses.json
  def create
    @analysis = Analysis.new(analysis_params)

    respond_to do |format|
      if @analysis.save
        format.html { redirect_to @analysis, notice: 'Analysis was successfully created.' }
        format.json { render :show, status: :created, location: @analysis }
      else
        format.html { render :new }
        format.json { render json: @analysis.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /analyses/1
  # PATCH/PUT /analyses/1.json
  def update
    respond_to do |format|
      if @analysis.update(analysis_params)
        format.html { redirect_to @analysis, notice: 'Analysis was successfully updated.' }
        format.json { render :show, status: :ok, location: @analysis }
      else
        format.html { render :edit }
        format.json { render json: @analysis.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /analyses/1
  # DELETE /analyses/1.json
  def destroy
    @analysis.destroy
    respond_to do |format|
      format.html { redirect_to analyses_url, notice: 'Analysis was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /analyses/1
  # GET /analyses/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_analysis
      @analysis = Analysis.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def analysis_params
      params.require(:analysis).permit(:geo_location_id, :area, :yield,
                                       :is_shaded, :crop, :tillage,
                                       :agrochemical_amount, :rice_type,
                                       :irrigation_regime, :flooding,
                                       :cultivation_time, {
                                         fertilizers_attributes: [
                                           :amount, :category, :addition_type,
                                           :area
                                         ],
                                       manures_attributes: [
                                         :amount, :category, :addition_type,
                                         :area
                                         ],
                                       fuels_attributes: [
                                         :amount, :category, :addition_type,
                                         :area, :unit
                                         ],
                                       nutrient_managements_attributes: [
                                         :amount, :category, :addition_type,
                                         :area
                                         ],
                                       transportation_fuels_attributes: [
                                         :amount, :category, :addition_type,
                                         :area
                                         ],
                                       irrigation_fuels_attributes: [
                                         :amount, :category, :addition_type,
                                         :area
                                         ],
                                       other_fuels_attributes: [
                                         :amount, :category, :addition_type,
                                         :area
                                         ]})
    end
end
