require "rails_helper"

feature "Signing out" do
  background do
    login_admin
    visit edit_admin_registration_path
  end

  it "redirects to the sign in page" do
    click_link t("shared.navigation.sign_out")
    expect(current_path).to eq(new_admin_session_path)
  end
end
