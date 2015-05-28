require "rails_helper"

feature "Visiting the Sign in page" do
  before :each do
    visit "/admin/sign_in"
  end

  it "includes a link to the sign in page in the navigation" do
    expect(page).to have_button "Sign in"
  end

  it "includes a link to the sign up page in the navigation" do
    expect(page).to have_link "Sign up", href: new_admin_registration_path
  end

  it "does not include a link to the Docs page in the navigation" do
    within ".navigation" do
      expect(page).not_to have_link "Docs", href: docs_path
    end
  end

  it "does not include a link to the Home page in the navigation" do
    within ".navigation" do
      expect(page).not_to have_link "Home", href: root_path
    end
  end
end

feature "Signing in" do
  context "with correct credentials" do
    it "sets the current path to the admin root path" do
      admin = create(:admin)

      sign_in_admin(admin.email, admin.password)

      expect(current_path).to eq(sfadmin_import_jobs_path)
    end

    it "displays a success message" do
      admin = create(:admin)

      sign_in_admin(admin.email, admin.password)

      expect(page).to have_content "Signed in successfully"
    end
  end

  scenario "with invalid credentials" do
    sign_in_admin("hello@example.com", "wrongpassword")

    expect(page).to have_content t("devise.failure.invalid")
  end

  scenario "with an unconfirmed admin" do
    unconfirmed_admin = create(:unconfirmed_admin)

    sign_in_admin(unconfirmed_admin.email, unconfirmed_admin.password)

    expect(page).
      to have_content(t("devise.failure.unconfirmed"))
  end

  def sign_in_admin(email, password)
    visit "/admin/sign_in"
    within("#new_admin") do
      fill_in "admin_email", with: email
      fill_in "admin_password", with: password
    end
    click_button "Sign in"
  end
end
