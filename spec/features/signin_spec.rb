require "rails_helper"

feature "Signing in" do
  context "with correct credentials" do
    before :each do
      valid_user = FactoryGirl.create(:user)
      sign_in(valid_user.email, valid_user.password)
    end
  end

  scenario "with invalid credentials" do
    sign_in("hello@example.com", "wrongpassword")
    expect(page).to have_content t("devise.failure.invalid")
  end

  scenario "with an unconfirmed user" do
    unconfirmed_user = FactoryGirl.create(:unconfirmed_user)
    sign_in(unconfirmed_user.email, unconfirmed_user.password)
    expect(page).to have_content t("devise.failure.unconfirmed")
  end

  def sign_in(email, password)
    visit "/users/sign_in"

    within("#new_user") do
      fill_in "Email", with: email
      fill_in "Password", with: password
    end

    click_button "Sign in"
  end
end
