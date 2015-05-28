require 'rails_helper'

feature 'Locations page' do
  context 'when not signed in' do
    before :each do
      visit '/admin/locations'
    end

    it 'redirects to the admin sign in page' do
      expect(current_path).to eq(new_admin_session_path)
    end

    it 'prompts the user to sign in or sign up' do
      expect(page).
        to have_content 'You need to sign in or sign up before continuing.'
    end

    it 'does not include a link to the Home page in the navigation' do
      within '.navigation' do
        expect(page).not_to have_link 'Home', href: root_path
      end
    end

    it 'does not include a link to Your locations in the navigation' do
      within '.navigation' do
        expect(page).not_to have_link 'Your locations', href: admin_locations_path
      end
    end
  end
end
