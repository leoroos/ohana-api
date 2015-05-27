module Sfadmin
  class OrganizationsController < Sfadmin::AdminController
    before_action :load_organization, except: [:index]
    respond_to :json, only: [:update]

    def index
      @organizations = Organization
      @organizations = @organizations.where('name ILIKE ?', "%#{params[:query]}%") unless params[:query].blank?

      @counts = @organizations.group(:aasm_state).reorder(nil).count
      @counts['all'] = @counts.values.reduce(:+)

      @organizations = @organizations.where(aasm_state: params[:filter]) unless params[:filter].blank?
      @organizations = @organizations.reorder(:name).page params[:page]
    end

    def show
      @location = @organization.locations.first
    end

    def update
      @organization.update(organization_params)
      render :show
    end

    private

    def organization_params
      params.require(:organization).permit(:name, urls: [])
    end

    def load_organization
      @organization = Organization.friendly.find params[:id]
    end
  end
end
