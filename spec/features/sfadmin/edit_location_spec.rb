require "rails_helper"

feature "Editing a location" do
  scenario "accessing the form through navigation" do
    location = create(:location)

    sign_in_as_admin
    click_on "Browse"
    click_on location.organization.name
    click_on location.name

    expect(page).to have_content(location.name)
  end

  scenario "changing the location's name" do
    location = create(:location)

    sign_in_as_admin
    visit location_page(location)
    fill_in("Name", with: "Foobar")
    click_on "Update Location"

    expect(page).to have_content("Foobar")
  end

  scenario "adding a location URL", :js do
    new_url = "http://foobar.com"
    location = create(:location)
    first_url_field = ".location_urls .array-element:first-child"

    sign_in_as_admin
    visit location_page(location)
    click_on "Add url"
    find(first_url_field).set(new_url)
    click_on "Update Location"

    url_field = find(first_url_field)
    expect(url_field.value).to eq(new_url)
  end

  scenario "checking accessibility boxes" do
    location = create(:location, accessibility: [])

    sign_in_as_admin
    visit location_page(location)
    check "location_accessibility_disabled_parking"
    click_on "Update Location"

    expect(find("#location_accessibility_disabled_parking")).to be_checked
  end

  def sign_in_as_admin
    admin = create(:admin)

    visit "/"

    fill_in "Email", with: admin.email
    fill_in "Password", with: admin.password

    click_on "Sign in"
  end

  def location_page(location)
    sfadmin_organization_location_path(location.organization, location)
  end
end
