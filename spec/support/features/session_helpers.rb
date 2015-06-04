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
  end
end
