class AnalysesController < ApplicationController
  before_action :set_analysis, only: [:show]
  before_action :build_nested, only: [:new, :show]

  def new
    @geo_locations = GeoLocation.select(:country).
      distinct.order(:country)
    @analysis = Analysis.new
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
        :yield_unit, :agroforestry_practices, :crop, :tillage, :agrochemical_amount,
        :rice_type, :irrigation_regime, :flooding, :cultivation_time,
        :lime_amount, :dolomite_amount, :annual_cultivation_cycles,
        fertilizers_attributes: [ :id, :amount, :category, :addition_type, :area ],
        manures_attributes: [ :id, :amount, :category, :addition_type, :area ],
        fuels_attributes: [ :id, :amount, :category, :addition_type, :area, :unit ],
        transportation_fuels_attributes: [ :id, :amount, :category, :addition_type, :area, :unit ],
        irrigation_fuels_attributes: [ :id, :amount, :category, :addition_type, :area, :unit ],
        nutrient_managements_attributes: [ :id, :amount, :category, :addition_type, :area ],
        crop_management_practices: [])
    end

    def build_nested
      unless @analysis.nutrient_managements.any?
        @analysis.nutrient_managements.build
      end
      Analysis::FUEL_TYPES.each do |fuel|
        unless @analysis.has_fuel?(fuel[:slug], :transportation)
          @analysis.transportation_fuels.build(addition_type: fuel[:slug])
        end
        unless @analysis.has_fuel?(fuel[:slug], :irrigation)
          @analysis.irrigation_fuels.build(addition_type: fuel[:slug])
        end
        unless @analysis.has_fuel?(fuel[:slug])
          @analysis.fuels.build(addition_type: fuel[:slug])
        end
      end
    end
end
