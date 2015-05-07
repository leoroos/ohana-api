require "rails_helper"

feature "CSV Download" do
  pending "a non-signed in user tries to access and is rerouted to sign in" do
    visit sfadmin_organizations_path(format: :csv)

    expect(current_path).to eq(new_admin_session_path)
    expect(page).to have_content(I18n.t("devise.failure.unauthenticated"))
  end

  scenario "an admin downloads a CSV" do
    organization = create(:organization)

    login_super_admin
    visit sfadmin_organizations_path(format: :csv)

    header = page.response_headers['Content-Disposition']
    expect(header).to match(/^attachment/)
    expect(header).to match(/filename="ohana_organizations_[\d-]+.csv"$/)
    expect(page.body).to have_content(organization.name)
  end
end
