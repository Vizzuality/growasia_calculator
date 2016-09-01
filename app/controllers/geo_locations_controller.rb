class GeoLocationsController < ApplicationController
  def states_for
    @geo_locations = GeoLocation.where(country: params[:country]).
      order(:state)
    respond_to do |format|
      format.js
    end
  end
end
