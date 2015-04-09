require "rails_helper"

feature "Update admin_emails" do
  scenario "when no admin_emails exist" do
    create(:location)
    login_super_admin
    visit "/admin/locations/vrs-services"

    expect(page).to have_no_xpath("//input[@name='location[admin_emails][]']")
    expect(page).to_not have_link "Delete this admin permanently"
  end
end
