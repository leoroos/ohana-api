class Sfadmin::LocationsController < ApplicationController
  def show
    @location = Location.friendly.find(params[:id])
  end
end
