class AnalysisStepsController < ApplicationController
  include Wicked::Wizard
  steps :basic, :rice, :crops

  def show
    case step
    when :basic
      @geo_locations = GeoLocation.select(:country).
        distinct.order(:country)
      @analysis = Analysis.new
      session[:analysis] = nil
    when :rice
      @analysis = Analysis.new(session[:analysis])
      @analysis.fertilizers.build
      @analysis.manures.build
      @analysis.nutrient_managements.build
      @analysis.transportation_fuels.build
      @analysis.irrigation_fuels.build
      @analysis.fuels.build
    when :crops
      @analysis = Analysis.new(session[:analysis])
      @analysis.fertilizers.build
      @analysis.manures.build
      @analysis.fuels.build
    end
    render_wizard
  end

  def update
    case step
    when :basic
      @analysis = Analysis.new(analysis_params)
      session[:analysis] = @analysis.attributes
      if @analysis.crop == "rice"
        redirect_to wizard_path(:rice)
      else
        redirect_to wizard_path(:crops)
      end
    when :rice, :crops
      session[:analysis] = session[:analysis].merge(analysis_params.to_h)
      @analysis = Analysis.new(session[:analysis])
      @analysis.save
      redirect_to analysis_path(@analysis)
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def analysis_params
      params.require(:analysis).permit(:geo_location_id, :area, :yield,
        :is_shaded, :crop, :tillage, :agrochemical_amount, :rice_type,
        :irrigation_regime, :flooding, :cultivation_time,
        :lime_amount, :dolomite_amount,
        fertilizers_attributes: [ :amount, :category, :addition_type, :area ],
        manures_attributes: [ :amount, :category, :addition_type, :area ],
        fuels_attributes: [ :amount, :category, :addition_type, :area, :unit ],
        nutrient_managements_attributes: [ :amount, :category, :addition_type, :area ],
        transportation_fuels_attributes: [ :amount, :category, :addition_type, :area ],
        irrigation_fuels_attributes: [ :amount, :category, :addition_type, :area ],
        crop_management_practices: [])
    end
end
