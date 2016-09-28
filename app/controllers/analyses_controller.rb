class AnalysesController < ApplicationController
  before_action :set_analysis, only: [:show]

  def new
    @geo_locations = GeoLocation.select(:country).
      distinct.order(:country)
    @analysis = Analysis.new
    @analysis.fertilizers.build
    @analysis.manures.build
    @analysis.nutrient_managements.build
    @analysis.transportation_fuels.build
    @analysis.irrigation_fuels.build
    @analysis.fuels.build
  end

  def create
    @analysis = Analysis.new(analysis_params)
    @analysis.save
    redirect_to @analysis
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
        :yield_unit, :is_shaded, :crop, :tillage, :agrochemical_amount,
        :rice_type, :irrigation_regime, :flooding, :cultivation_time,
        :lime_amount, :dolomite_amount, :annual_cultivation_cycles,
        fertilizers_attributes: [ :id, :amount, :category, :addition_type, :area ],
        manures_attributes: [ :id, :amount, :category, :addition_type, :area ],
        fuels_attributes: [ :id, :amount, :category, :addition_type, :area, :unit ],
        nutrient_managements_attributes: [ :id, :amount, :category, :addition_type, :area ],
        transportation_fuels_attributes: [ :id, :amount, :category, :addition_type, :area ],
        irrigation_fuels_attributes: [ :id, :amount, :category, :addition_type, :area ],
        crop_management_practices: [])
    end
end
