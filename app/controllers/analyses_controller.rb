class AnalysesController < ApplicationController
  before_action :set_analysis, only: [:show]

  # GET /analyses/1
  # GET /analyses/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_analysis
      @analysis = Analysis.find(params[:id])
    end
end
