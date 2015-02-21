class Sfadmin::LocationsController < ApplicationController
  def show
    @location = find_location
  end

  def update
    @location = find_location
    @location.update(location_params)
    render :show
  end

  private

  def find_location
    Location.friendly.find(params[:id])
  end

  def location_params
    params.require(:location).permit(
      :name,
      :short_desc,
      :description,
      :hours,
      :transportation,
      :latitude,
      :longitude,
      urls: [],
      emails: [],
      admin_emails: [],
      languages: [],
      accessibility: [],
    )
  end
end
