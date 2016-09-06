class Api::V1::AnalysesController < ApiController
  before_action :set_analysis, only: [:show]

  # GET /api/v1/analyses/1
  def show
    render json: @analysis
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_analysis
      @analysis = Analysis.find(params[:id])
    end
end
