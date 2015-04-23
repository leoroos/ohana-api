module Features
  # Helper methods you can use in specs to perform common and
  # repetitive actions.
  module SessionHelpers
    def login_admin
      @admin = FactoryGirl.create(:admin)
      login_as(@admin, scope: :admin)
    end

    def login_as_admin(admin)
      login_as(admin, scope: :admin)
    end

    def login_super_admin
      @super_admin = FactoryGirl.create(:super_admin)
      login_as(@super_admin, scope: :admin)
    end

    def login_user
      user = FactoryGirl.create(:user)
      login_as(user, scope: :user)
    end

    def create_api_app(name, main_url, callback_url)
      click_link 'Register new application'
      within('#new_api_application') do
        fill_in 'Name',         with: name
        fill_in 'Main URL',     with: main_url
        fill_in 'Callback URL', with: callback_url
      end
      click_button 'Register application'
    end

    def update_api_app(name, main_url, callback_url)
      within('.edit_api_application') do
        fill_in 'Name',         with: name
        fill_in 'Main URL',     with: main_url
        fill_in 'Callback URL', with: callback_url
      end
      click_button 'Update application'
    end

    def visit_app(name, main_url)
      visit('/api_applications')
      click_link "#{name} (#{main_url})"
    end
  end
end
