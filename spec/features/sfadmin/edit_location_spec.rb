require "rails_helper"

feature "Editing a location" do
  scenario "accessing the form through navigation" do
    location = create(:location)

    login_admin
    visit "/"
    click_on "Browse"
    click_on location.organization.name
    click_on location.name

    expect(page).to have_content(location.name)
  end

  scenario "changing the location's name" do
    location = create(:location)

    login_admin
    visit "/"
    visit location_page(location)
    fill_in("Name", with: "Foobar")
    click_on "Update Location"

    expect(page).to have_content("Foobar")
  end

  scenario "checking accessibility boxes" do
    location = create(:location, accessibility: [])

    login_admin
    visit "/"
    visit location_page(location)
    check "location_accessibility_disabled_parking"
    click_on "Update Location"

    expect(find("#location_accessibility_disabled_parking")).to be_checked
  end

  def location_page(location)
    sfadmin_organization_location_path(location.organization, location)
  end
end
