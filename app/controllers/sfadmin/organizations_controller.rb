require "tempfile"

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

      respond_to do |format|
        format.html
        format.csv do
          response.headers["Content-Disposition"] =
            "attachment; filename=\"#{filename}.csv\""
        end
        format.txt do
          template = File.read(Rails.root + "app/views/sfadmin/organizations/index.txt.erb")
          markdown = ERB.new(template).result
          file = "locations.md"
          document = "locations.docx"
          `rm #{document} #{file}`
          File.write(file, markdown)
          `pandoc -s -S #{file} --reference-docx template.docx -o #{document}`
          send_file Rails.root + document
        end
      end
    end

    def show
    end

    def update
      @organization.update(organization_params)
      render :show
    end

    private

    def filename
      "ohana_organizations_#{Time.current.to_date.to_s}"
    end

    def organization_params
      params.require(:organization).permit(:name, urls: [])
    end

    def load_organization
      @organization = Organization.friendly.find params[:id]
    end
  end
end
