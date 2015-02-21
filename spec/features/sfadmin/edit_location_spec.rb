require "rails_helper"

feature "Editing a location" do
  scenario "accessing the form through navigation" do
    admin = create(:admin)
    location = create(:location)

    sign_in_as(admin)
    click_on "Browse"
    click_on location.organization.name
    click_on location.name

    expect(page).to have_content(location.name)
  end

  def sign_in_as(admin)
    visit "/"

    fill_in "Email", with: admin.email
    fill_in "Password", with: admin.password

    click_on "Sign in"
  end
end
